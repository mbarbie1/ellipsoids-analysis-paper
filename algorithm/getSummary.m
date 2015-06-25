% FUNCTION: Summary of the segmentation and spot detection algorithm
%           results. This gives a quick overview of the spheroids and spots
%           detected, whether the procedure didn't got stuck due to an
%           error, and what the coverage of the image was.
%
% INPUT:
%
%           options         : struct containing
%                               .imageId
%                               .pixelSize -> e.g. [ 1.2, 1.2, 5 ] (um)
%                               .size -> e.g. [ 521, 512, 100 ]
%           mip             : maximum intensity projection of the
%                               spheroid-channel.
%           msra            : struct array with spheroid measurements
%           spotTable       : 
%           radiusDilationUnit : The dilation radius to define the sample
%                               region vs background region, this is the
%                               distance from the nearest spheroid that a
%                               pixel must be to be 'outside' the sample.
% 
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function summary = getSummary(options, succesfullAnalysis, err, mip, msra, spotTable)

    fprintf('Starting getSummary on imageId %i\n', options.input.imageId);
    tstartTotal = tic;

    summary = struct(...
        'imageId',options.input.imageId,...
        'succesfullAnalysis', succesfullAnalysis,...
        'errorAnalysis',err,...
        'imageVolume',-1,...
        'imageVolumeUnit',-1,...
        'sampleVolume',-1,...
        'sampleVolumeUnit',-1,...
        'sampleVolumeRatio',-1,...
        'nSpheroids',-1,...
        'nSpots',-1,...
        'avgSpotIntensity',-1,...
        'stdSpotIntensity',-1,...
        'avgSpheroidIntensity',-1,...
        'stdSpheroidIntensity',-1,...
        'avgSpotsPerSpheroid',-1,...
        'stdSpotsPerSpheroid',-1,...
        'avgSpheroidAreaUnit',-1,...
        'avgSpheroidVolumeUnit',-1,...
        'areaCoverage',-1,...
        'volumeCoverage',-1,...
        'avgSpheroidZUnit',-1,...
        'stdSpheroidZUnit',-1,...
        'avgSpheroidZ',-1,...
        'stdSpheroidZ',-1 ...
    );

    if (succesfullAnalysis == true )
%        try

            
            imgSize = [ imsize(mip), options.input.size(3) ];
            imgKS = newim( imgSize );
            t = round([msra(:,1).Center])';
            avgRadius = ([msra(:,1).ellipsoidVolumeUnit] * 3 / 4 / pi).^(1/3);
            try
                radiusDilationUnit = options.summary.radiusDilationUnit;
                n = 4;
                coords = round([ t(:,1)/n , t(:,2)/n, [msra(:,1).CenterRimHeight_3]' ]);
                imgSubSize = ceil( [imgSize(1)/n, imgSize(2)/n, imgSize(3)] );
                pixelSubSize = [options.input.pixelSize(1)*n, options.input.pixelSize(2)*n, options.input.pixelSize(3)];
                tKS = drawSpheres( newim( imgSubSize ), coords, pixelSubSize, ones(length(msra),1), avgRadius + radiusDilationUnit, 0 );
                summary.sampleVolume = n^2 * sum(tKS);
            catch
                summary.sampleVolume = prod(size(mip)) * options.input.size(3);
            end

            %% Draw spheres: method to find sample volume 

            
            %% Distance transform
%             imgKS(sub2ind(imgKS,coords)) = 1;
%             vv = vdt(imgKS==0);
%             imgKS = sqrt( vv{1}.^2 * options.input.pixelSize(1).^2 + vv{2}.^2 * options.input.pixelSize(2).^2 + vv{3}.^2 * options.input.pixelSize(1).^2 );
%             dipshow(imgKS);
%             tKS = imgKS < radiusDilationUnit;
%             dipshow(tKS);

             %% Grey dilation
%             coords = [t(:,1) , t(:,2), [msra(:,1).CenterRimHeight_3]' ];
%             imgKS(sub2ind(imgKS,coords)) = 1;
%             sigma = radiusDilationUnit ./ options.input.pixelSize;
%             imgKS = dilation(imgKS, sigma);
%             tKS = threshold(imgKS);

            %% Gaussian 
%             imgKS(sub2ind(imgKS,coords)) = avgRadius + radiusDilationUnit;
%             sigma = radiusDilationUnit ./ options.input.pixelSize;
%             imgKS = gaussf( imgKS, sigma );
%             %imgKS = imgKS/max(imgKS);
%             FWHM = 1/2  /   (sqrt( (2*pi)^3)  *  prod(sigma) );
%             tKS = threshold(imgKS,'fixed',FWHM);

            summary.sampleVolumeUnit = summary.sampleVolume * prod(options.input.pixelSize);
            summary.imageVolume = prod(size(mip)) * options.input.size(3);
            summary.imageVolumeUnit = summary.imageVolume * prod(options.input.pixelSize);
            summary.sampleVolumeRatio = summary.sampleVolume / summary.imageVolume;
            summary.nSpheroids = length(msra);

            summary.avgSpheroidAreaUnit = mean( [msra(:,1).SizeUnit] );
            summary.avgSpheroidVolumeUnit = mean( [msra(:,1).ellipsoidVolumeUnit] );
            summary.areaCoverage = sum([msra(:,1).Size]) / prod(size(mip));
            summary.volumeCoverage = sum([msra(:,1).ellipsoidVolume]) / prod(size(mip)) / options.input.size(3);

            summary.avgSpheroidZ = mean( [msra(:,1).CenterRimHeight_3] );
            summary.stdSpheroidZ = std( [msra(:,1).CenterRimHeight_3] );
            summary.avgSpheroidZUnit = mean( [msra(:,1).CenterRimHeight_3] * options.input.pixelSize(3) );
            summary.stdSpheroidZUnit = std( [msra(:,1).CenterRimHeight_3] * options.input.pixelSize(3) );

            summary.avgSpheroidIntensity = mean( [msra(:,1).Mean] );
            summary.stdSpheroidIntensity = std( [msra(:,1).Mean] );

            if ( exist('spotTable','var') && ~isempty(spotTable) )
                summary.nSpots = length(spotTable);
                summary.avgSpotsPerSpheroid = mean( [msra(:,1).spotCount] );
                summary.stdSpotsPerSpheroid = std( [msra(:,1).spotCount] );
                summary.avgSpotIntensity = mean( [spotTable(:).intensity] );
                summary.stdSpotIntensity = std( double( [spotTable(:).intensity] ) );
            end
    end
    tstopTotal = toc(tstartTotal);
    fprintf('Total processing time getSummary = %i\n', tstopTotal);

end
