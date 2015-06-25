function s = logErrorString( err )
    s = sprintf('\t \t Error-id: %s\n', err.identifier);
    s = [ s  sprintf('\t \t Error-message: %s\n', err.message) ];
    stackTrace = {err.stack.name};
    stackTraceLine = [err.stack.line];
    s = [ s  sprintf('\t \t Stack trace:\n') ];
    for traceInd = 1:length(stackTrace)
        s = [ s  sprintf('\t \t \t %s at line %i\n', stackTrace{traceInd}, stackTraceLine(traceInd)) ];
    end
end
