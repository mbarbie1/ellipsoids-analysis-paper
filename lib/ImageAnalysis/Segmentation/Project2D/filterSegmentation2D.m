function labFilter = filterSegmentation2D( lab, imgMIPZ, pixelSize, minRadius, maxRadius, removeBorderObjectsInPlane, thresholdIntensity)
% -----------------------------------------------------------------------
% 
% FUNCTION: filterSegmentation2D
% 
% DESCRIPTION: Filter the labeled image lab from a 2D segmentation2D of
%				spheroidal objects in 2D for 3D image-
%               stacks (grey-valued images). 
% 
% INPUT: 
%           imgMIPZ                     : MIP (DIPimage 2D image)
%           pixelSize                   : pixel size in x,y,z (vector)
%           minRadius                   : minimal radius (in micron) of the
%                                           ellipsoidal object (scalar)
%           removeBorderObjectsInPlane  : whether the output should contain
%                                           the objects which touch the
%                                           border in the plane (boolean)
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
% 	Micha�l Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
    fprintf('Process: filterSegmentation2D\n');
    tic;

	imgt = lab > 0;
	
	%%% Filter on the minimal and maximal radius
	lab = label(  imgt, 1, round( pi*(minRadius/pixelSize(1))^2), round( pi*(maxRadius/pixelSize(1))^2)  );
	imgt = lab > 0;
	
    %%% Threshold intensity
    if ( ~isempty(thresholdIntensity) && ( max(lab) > 0 ) )
        msr = measure(lab, imgMIPZ, ({'mean'}));
        imgMean = msr2obj(lab,msr,'mean');
        imgt_intensity = threshold(imgMean, 'fixed', thresholdIntensity);
        imgt = imgt .* imgt_intensity;
        lab = label(  imgt, 1, 0, 0  );
		imgt = lab > 0;
	end

    %%% REMOVE EDGE OBJECTS in (x,y)-plane
    if ( removeBorderObjectsInPlane == true )
        imgt = brmedgeobjs(imgt,1);
        lab = label(  imgt, 1, 0, 0  );
	end

	labFilter = lab;
    endTime = toc();
    fprintf('filterSegmentation2D: time duration: %s\n', num2str(endTime));
end
