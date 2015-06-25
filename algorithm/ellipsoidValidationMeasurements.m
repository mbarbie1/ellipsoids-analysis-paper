function msr = ellipsoidValidationMeasurements( imgMIPZ, imgMIPZH, lab, labEllipse, pixelSize )


    lab = dip_image(lab, 'sint16');
    labEllipse = dip_image(labEllipse, 'sint16');
    [ msr, msrEllipse ] = spheroidValidation(imgMIPZ, imgMIPZH, lab, labEllipse, pixelSize );

%     nExtend = 3;
%     penaltyMissedRegion = 1;
%     penaltyFalseRegion = 1;
%     [error, errorOverlap, MSingle, mSingle, MPenalty, mPenalty, numDaughters, isDaughter]...
%         = errorTwoLabs( labEllipse, lab, nExtend,...
%     imgMIPZ, pixelSize(1:2), penaltyMissedRegion, penaltyFalseRegion );
% 
%     msr.errorOverlap = errorOverlap;

%    disp(size(msr));
%    disp(size(msrEllipse));

    fn = fieldnames(msrEllipse);
    nfn = length(fn);
    for k = 1:nfn
        msr.([fn{k} 'Ellipse'] ) = msrEllipse.(fn{k});
    end

end

