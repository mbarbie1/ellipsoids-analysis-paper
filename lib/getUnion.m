% img is cell array of dipimage images
function [AUmask, BUmask, Uimg] = getUnion(Aminp, Amaxp, Bminp, Bmaxp, img, Amask, Bmask)

    Uminp = min( Aminp, Bminp);
    Umaxp = max( Amaxp, Bmaxp);

    for k = 1:length(img)
        try
            Uimg{k} = img{k}( Uminp(1):Umaxp(1), Uminp(2):Umaxp(2) );
        catch e
            sz = imsize(img{k});
            disp(sz);
            warning('Error: k = %i  and Uminp = (%i, %i), and Umaxp = (%i, %i) and image size was: %i x %i', k, Uminp(1), Uminp(2), Umaxp(1), Umaxp(2), sz(1), sz(2) );
            warning('Error message was: %s', e.message );
        end
    end
    AminpRel = Aminp - Uminp;
    BminpRel = Bminp - Uminp;
    AmaxpRel = Amaxp - Uminp;
    BmaxpRel = Bmaxp - Uminp;
    AUmask = newim( imsize( Uimg{1} ) );
    AUmask( AminpRel(1):AmaxpRel(1), AminpRel(2):AmaxpRel(2) ) = Amask;
    BUmask = newim( imsize( Uimg{1} ) );
    BUmask( BminpRel(1):BmaxpRel(1), BminpRel(2):BmaxpRel(2) ) = Bmask;

end