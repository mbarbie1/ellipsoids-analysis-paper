function saveMeasurements( msr, outputFile, outputFormat )

    switch (outputFormat)
        case 'json'
            msr = struct(msr);
            savejson('table', msr, outputFile );
        case 'mat'
            table = struct2table( msr , 'AsArray', true );
            save(outputFile, 'table');
        case 'excel'
            table = struct2table( msr, 'AsArray', true );
            writetable( table, outputFile );
        case 'csv'
            table = struct2table( msr, 'AsArray', true );
            writetable( table, outputFile );
        otherwise
            warning('saveMeasurements: unknown format to save');
    end
    
end
