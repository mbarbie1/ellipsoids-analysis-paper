function lab = segmentGreyHeightMap2D( imgMIPZ, imgMIPZH, pixelSize, minRadius, neighbourhoodRadius, maxRangeZ, removeBorderObjectsInPlane, removeBorderObjectsInZ, borderZRemoveMethod, thresholdIntensity, minP)
% -----------------------------------------------------------------------
% 
% FUNCTION: segmentHeightMap2D
% 
% DESCRIPTION: Segmentation of spheroidal objects in 2D for 3D image-
%               stacks (grey-valued images). 
%               The (bright) objects have to be more or less
%               compact in space for the algorithm. For the z-projection
%               algorithm which we use here they have to be compact in
%               particular in the z-direction.
%
%              Algorithm description:
%               For the segmentation the algorithm uses the MIP or
%               Maximal Intensity Projection of the image and the z-buffer
%               of this projection (which we refer to as the height map of
%               the MIP. The homogeneity of the z-buffer is taken to be the
%               measure to distinguish between foreground and background.
%               This measure is calculated by applying a range filter to
%               the z-buffer. The homogeneity measure is multiplied by the
%               normalized mip intensity values to obtain a probability of
%               foreground, afterwards this probability is thresholded.
%               Then this mask is labeled.
% 
% INPUT: 
%           imgMIPZ                     : MIP (DIPimage 2D image)
%           imgMIPZH                    : z-buffer of the MIP (DIPimage 2D
%                                           image)
%           pixelSize                   : pixel size in x,y,z (vector)
%           minRadius                   : minimal radius (in micron) of the
%                                           ellipsoidal object (scalar)
%           neighbourhoodRadius         : neighbourhood of the range filter
%                                           (scalar)
%           maxRangeZ                   : threshold (sigmoid inclination point)
%                                           for the maximal range
%                                           on the filtered z-buffer
%                                           (scalar)
%           removeBorderObjectsInPlane  : whether the output should contain
%                                           the objects which touch the
%                                           border in the plane (boolean)
%           removeBorderObjectsInZ      : whether the output should contain
%                                           the objects which include the
%                                           upper or lower layer of the 3D
%                                           image stack (boolean)
%           borderZRemoveMethod         : Which method to use when
%                                           removeBorderObjectsInZ is true
%           thresholdIntensity          : Intensity threshold ( sigmoid
%                                           inclination point) (scalar)
%           minP                        : Minimal probability (range small
%                                           enough and intensity high
%                                           enough) to be spheroid region
%
% OUTPUT:
%           lab         : labeled image of the segmentation
%
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
    kernelSize = 2 * max( 1, round( neighbourhoodRadius / pixelSize(1) ) )  +  1;
    disp(kernelSize);
    maxRangeZPixels = max( 1 + 0.0001, maxRangeZ / pixelSize(3) );
    disp(maxRangeZPixels);

    minH = min(imgMIPZH);
    maxH = max(imgMIPZH);
    img_range = dip_image( rangefilt( dip_array(imgMIPZH), true(kernelSize) ) );

    tValue = thresholdIntensity;
    wValue = thresholdIntensity / 2;
    img_mip = sigmoidNormalizedAB(imgMIPZ, tValue, wValue, 0, max(imgMIPZ));

    tValue = maxRangeZPixels;
    wValue = maxRangeZPixels / 2;
    img_range = sigmoidNormalizedAB(img_range, tValue, wValue, 0, max(img_range));

    img_prob = (1-img_range) .* img_mip;
    dipshow(stretch(img_range));
    dipshow(stretch(img_mip));
    dipshow(stretch(img_prob));

    imgt = fillholes(img_prob > minP );
    
    lab = label(  imgt, 1, round( pi*(minRadius/pixelSize(1))^2), 0  );
    H = dipshow(stretch(lab)); dipmapping(H, 'labels')

    
    
    %%% REMOVE EDGE OBJECTS in (x,y)-plane
    if ( removeBorderObjectsInPlane == true )
        imgt = brmedgeobjs(imgt,1);
        lab = label(  imgt, 1, round( pi*(minRadius/pixelSize(1))^2), 0  );
    end
    

    %%% REMOVE EDGE OBJECTS along z
    if (removeBorderObjectsInZ == true)
        if strcmp(borderZRemoveMethod, 'meanBorder') 
            img_borderOfSpheroids = (imgt-berosion(imgt));
            msr = measure(img_borderOfSpheroids, imgMIPZH, {'mean'});
            imgZmean = msr2obj(lab,msr,'mean');
            lab(imgZmean >= max(imgZmean)-1) = 0;
            lab(imgZmean <= min(imgZmean)+1) = 0;
        else
            lab = removeBorderObjects(lab, imgMIPZH, minH+1, maxH-1);
        end
    end

end