function [ profileStop, profileStopRange, depthPercentage, depthType ] = analyseAttenuationProfile(centerZ, centerProfiles, spheroidIndexStart, spheroidIndexStop, profileAttenuationRatio )

    n = length(centerProfiles);
    m = length(profileAttenuationRatio);
    profileStop = ones(n,m);
    spheroidRange = ones(n,1);
    profileStopRange = profileStop;
    depthPercentage =  profileStop; 
    depthType = cell(n,m); 
    for k = 1:n
        profile = centerProfiles{k};
        % profileMaxIndex = index of maximum intensity relative to first spheroid slice (spheroidIndexStart)
        [profileMax, spheroidMaxIndex] = max(profile(spheroidIndexStart(k):spheroidIndexStop(k)));
        % profileMaxIndex --> index relative to first z of profile
        profileMaxIndex = spheroidIndexStart(k) - 1 + spheroidMaxIndex;
        % spheriodRange = number of z-slices of the spheroid
        spheroidRange(k) = (spheroidIndexStop(k) + 0.5) - (spheroidIndexStart(k) - 0.5);
        for j = 1:length(profileAttenuationRatio)
            % profileThresh = threshold, percentage of maximal intensity
            % inside spheroid
            profileThresh = max( profileAttenuationRatio(j) * profileMax, min( profile(spheroidIndexStart(k):spheroidIndexStop(k)) ) );
            % t = profile proj. which is true when profile smaller or equal
            % to the threshold
            % inside spheroid
            t = (profile - profileThresh) <= 0;
            %tt = t((profileMaxIndex+1):end);
            tt = min( find( t((profileMaxIndex+1):end), 1, 'first'), spheroidRange(k)-spheroidMaxIndex );
            if (  ~isempty( tt )  )
                profileStopRange(k,j) = tt + spheroidMaxIndex;
            else
                warning('empty find( t((profileMaxIndex+1):end), 1, first)');
                profileStopRange(k,j) = spheroidRange(k);
            end
            profileStop(k,j) = profileStopRange(k,j) + spheroidIndexStart(k) - 1;
            depthPercentage(k,j) = profileStopRange(k,j) / spheroidRange(k);
            if (depthPercentage(k,j) >= 1)
                depthType{k,j} = 'full';
            else if (depthPercentage(k,j) >= 0.5)
                    depthType{k,j} = 'half';
                else
                    depthType{k,j} = 'less';
                end
            end
        end
    end

end
