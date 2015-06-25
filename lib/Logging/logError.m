function logError( logFid, err )
    fprintf(logFid, '\t \t Error-id: %s\n', err.identifier);
    fprintf(logFid, '\t \t Error-message: %s\n', err.message);
    stackTrace = {err.stack.name};
    stackTraceLine = [err.stack.line];
    fprintf(logFid, '\t \t Stack trace:\n');
    for traceInd = 1:length(stackTrace)
        fprintf(logFid, '\t \t \t %s at line %i\n', stackTrace{traceInd}, stackTraceLine(traceInd));
    end
end
