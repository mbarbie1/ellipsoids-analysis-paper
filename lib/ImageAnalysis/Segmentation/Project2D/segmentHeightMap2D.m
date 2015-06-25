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
%               the z-buffer and thresholding the resulting image.
%               Afterwards this mask is labeled and the intensity of the
%               MIP is compared where labeled objects with an intensity
%               below 'thresholdIntensity' are removed.
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
%           maxRangeZ                   : threshold for the maximal range
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
%           thresholdIntensity          : if not empty: [], the objects in
%                                           the obtained labeled image are
%                                           compared with this value and
%                                           removed if their mean intensity
%                                           is smaller.
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
function lab = segmentHeightMap2D( imgMIPZ, imgMIPZH, pixelSize, minRadius, neighbourhoodRadius, maxRangeZ, removeBorderObjectsInPlane, removeBorderObjectsInZ, borderZRemoveMethod, thresholdIntensity)

    fprintf('Process: segmentHeightMap2D\n');
    tic;

    kernelSize = 2 * max( 1, round( neighbourhoodRadius / pixelSize(1) ) )  +  1;
    %disp(kernelSize);
    maxRangeZPixels = max( 1 + 0.0001, maxRangeZ / pixelSize(3) );
    %disp('maxRangeZPixels = ');
    %disp(maxRangeZPixels);

    minH = min(imgMIPZH);
    maxH = max(imgMIPZH);
    img_range = dip_image( rangefilt( dip_array(imgMIPZH), true(kernelSize) ) );
    
    % Be carful with filling holes: if the background has large regions of
    % similar height and becomes identified as foreground, by filling holes
    % at this stage we remove the opportunity to remove low intensity
    % regions up front
    imgt = fillholes(img_range < maxRangeZPixels );
    
    lab = label(  imgt, 1, round( pi*(minRadius/pixelSize(1))^2), 0  );

    %%% Threshold intensity
    if ( ~isempty(thresholdIntensity) && ( max(lab) > 0 ) )
        msr = measure(lab, imgMIPZ, ({'mean'}));
        imgMean = msr2obj(lab,msr,'mean');
        imgt_intensity = threshold(imgMean, 'fixed', thresholdIntensity);
        imgt = imgt .* imgt_intensity;
        lab = label(  imgt, 1, round( pi*(minRadius/pixelSize(1))^2), 0  );
    end

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
    endTime = toc();
    fprintf('segmentHeightMap2D: time duration: %s\n', num2str(endTime));
end