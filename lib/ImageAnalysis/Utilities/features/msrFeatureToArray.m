function featureArray = msrFeatureToArray(msrCell, msrFeature)
    x = zeros(1,length(msrCell));
    for j = 1:length(msrCell)
        %if (isscalar(msrCell{j}.id))
            if (length(msrCell{j}.size) > 1)
                [~,ind] = max(msrCell{j}.size);
            else
                ind = 1;
            end
            switch msrFeature
                case 'ID'
                    x(j) = j;
                case 'Size'
                    x(j) = double(msrCell{j}.size(ind));
                case 'Mean'
                    x(j) = double(msrCell{j}.mean(ind));
                case 'Mass'
                    x(j) = double(msrCell{j}.mass(ind));
                case 'Sum'
                    x(j) = double(msrCell{j}.sum(ind));
                case 'P2A'
                    x(j) = double(msrCell{j}.p2a(ind));
                case 'Center',
                    x(j) = double(msrCell{j}.center(ind));
                case 'StdDev'
                    x(j) = double(msrCell{j}.stddev(ind));
                case 'SurfaceArea'
                    x(j) = double(msrCell{j}.surfacearea(ind));
                case 'GreyDimensionsEllipsoid'
                    x(j) = double(msrCell{j}.greydimensionsellipsoid(ind));
                case 'DimensionsEllipsoid'
                    x(j) = double(msrCell{j}.dimensionsellipsoid(ind));
                otherwise
                    x(j) = 0;
            end
        %end
    end
    featureArray = x;
end
