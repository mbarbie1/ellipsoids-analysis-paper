% -----------------------------------------------------------------------
% 
%   FUNCTION        : ErrorTwoLabs
%
%   DESCRIPTION     : Calculates an error measure from the difference
%                       between a automatically segmented labeled image 
%                       and a ground truth image. The method is dedicated
%                       to images that are showing nuclei. The nucleus
%                       regions in the ground truth are denoted M_j and 
%                       the ones in the other labeled image are denoted 
%                       m_i. When m_i have enough overlap with M_j then 
%                       m_i belongs to M_j (is a daughter of M_j).
%
%   DIPimage!
%
%   INPUT:  
%       lab                 : the labeled image (dip_image)
%       lab_GT              : the ground truth labeled image (dip_image)
%       nExtend             : the nucleus M_j is cut out 'lab_GT', this 
%                               cut should be large enough to include the 
%                               m_i from 'lab', nExtend is the amount of 
%                               extra border pixels to the cut out M_j.
%       img                 : the image-stack (dip_image)
%       image               : struct with the parameters of the image
%                               .[ dx | dy | dz ] : Pixelsize along the
%                                  different dimensions
%       penaltyMissedRegion : the penalty added to the error measure for
%                              each M_j without daughters
%       penaltyFalseRegion  : the penalty added to the error measure for
%                               each m_i without parent M_j
%
%   OUTPUT:
%       error               : The total error measure
%       errorOverlap        : The error for each ground truth nucleus M_j
%                             calculated from its 'daughters' m_i. 
%                             (1d array).
%       MSingle             : For each M_j whether it has not any 
%                              daughters m_i (missed nucleus region)
%                              (1d array).
%       mSingle             : For each m_i whether it is not a daughter
%                              of any M_j (false detected nucleus) 
%                              (1d array).
%       MPenalty            : Penalty added to the error for all missed
%                               nucleus region.
%       mPenalty            : Penalty added to the error for all false
%                               detected nucleus region
%       numDaughters        : The number of daughters for every M_j 
%                               (1d arrray).
%       isDaughter          : Table: isDaughter(k,l) = 1 if m_l is a 
%                               daughter of M_k.
% 
% -----------------------------------------------------------------------
% 
function [error, errorOverlap, MSingle, mSingle, MPenalty, mPenalty,...
    numDaughters, isDaughter]  = errorTwoLabs( lab, lab_GT, nExtend,...
    img, pixelSize, penaltyMissedRegion, penaltyFalseRegion )


    % overlap m with Mi is largest --> m is element of Mi
    % for all Mi, get all daughter m's
    overlapM = zeros( max(lab_GT), max(lab) );
    overlapm = zeros( max(lab_GT), max(lab) );
    numDaughters = zeros( max(lab_GT), 1 );
    for k = 1:max(lab_GT)
        M = (lab_GT == k);
        for j = 1:max(lab)
            m = (lab == j);
            overlapM(k,j) = sum( m .* M ) / sum( M );
            overlapm(k,j) = sum( m .* M ) / sum( m );
            isDaughter(k,j) = overlapm(k,j) > 0.5;
        end
        daughters{k} = find( isDaughter(k,:) );
        numDaughters(k) = sum( isDaughter(k,:) );
        numDaughters = numDaughters';
    end
    
    % for all m not overlapping any Mi give penalty
    %( mj .* M ) = 0 --> mj gives penalty error 'penaltyFalseRegion ~= 2'
    mSingle = max(overlapm,[],1) <= 0.5;
    mPenalty = sum(mSingle) * penaltyFalseRegion;

    % for all M not having any daughter object mj give penalty
    %( m .* Mi ) = 0 --> Mi has penalty error 'penaltyMissedRegion ~= 1'
    MSingle = numDaughters == 0;
    MPenalty = sum(MSingle) * penaltyMissedRegion;

    % for all M calculate the distance map and for each daughter m find the
    % error from the distance map (errorOverlap):
    [ ~, maskImages_GT, imgCutSize, origin3D ] = blobImageAndMasksFromLab( lab_GT, img, nExtend);
    %
    errorOverlap = zeros( 1, max(lab_GT) );
    %
    for k = 1:max(lab_GT)

        M = maskImages_GT{k};

        for l = 1:numDaughters(k)

            labInd = daughters{k}(l);
            % Cut out the same sub-image from 'lab' as M from 'lab_GT'
            m = cut(lab == labInd, imgCutSize{k}, origin3D{k});

            % Surface of M
            Msurf = M-berosion(M);

            % Distance-map from M's surface (for anisotropic pixelsize)
            MdistVec = vdt(~Msurf);
            Mdist = sqrt(  sum(  ( pixelSize(:) .* MdistVec{:} ).^2  )  );

            % Apply a sigmoid function to the distance-map
            tDist = 1.5;
            wDist = 0.5;
            Mdist = sigmoidNormalizedAB(Mdist, tDist, wDist, 0, max(Mdist));

            % The error contribution of the pixels inside M but not in m
            errorInNorm = sum( Mdist .* M );
            errorIn = sum(  (M - ( m .* M )) .* Mdist  );

            % The error contribution of the pixels outside M while in m
            errorOutNorm = sum( Mdist .* M );
            errorOut = sum(  (m - ( m .* M)) .* Mdist  );

            errorOverlap(k) = errorOverlap(k) + (errorIn / errorInNorm) + (errorOut / errorOutNorm);
        end

    end
    %
    % The total error is the error due to not completely overlap of
    % daughters plus the penalties given for missed nuclei and falsely
    % detected nuclei.
    error = sum(errorOverlap) + MPenalty + mPenalty;

end
