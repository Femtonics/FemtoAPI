function exportCurves(measurementFileHandle)
    %exports all curves as CSV files into the current folder
    %from the measurement file definet by the parameter
    %example: exportCurves(10)
    urlAddressAndPort = 'ws://localhost:8888'; 
    mescapiObjP = FemtoAPIProcessing(urlAddressAndPort);
    try
        munitData = mescapiObjP.getChildTree([measurementFileHandle 0]);
        for x = 1 : length(munitData.measurements)
            if isstruct(munitData.measurements)
                handle = munitData.measurements(x).handle;
            else
                handle = munitData.measurements{x}.handle;
            end
            %handle = munitData.measurements{x}.handle;
            curve = curveExportAll(mescapiObjP ,handle);
            names = curve{1};
            curves = curve{2};

            for i = 1 : length(curves)
                disp(handle')
                disp(names{i})
                T = array2table(curves{i});
                T.Properties.VariableNames(1:2) = {'timestamp','value'};
                filename = strcat(string(handle(1)),',',string(handle(2)),',',string(handle(3)),'_', names{i},".csv");
                writetable(T,filename);
            end
        end
        mescapiObjP.disconnect();
    catch ERR
        disp(ERR)
        clear mescapiObjP;
    end
    clear mescapiObjP;
end

function result = curveExportAll(mescapiObjP, handle)
    % reads a specific curve from a measurement file and returns it
    % mescapiObjP is a femtoAPI object which fold the connection
    % handle is the measurement handle eg.: [59 0 0]
    % curveName is a string with the name of a specific curve
    % if no curve found with curveName an empty vector is returned
    munitData = mescapiObjP.getChildTree(handle);
    curves    = {};
    names     = {};
    result    = [];
    for i = 1 : length(munitData.curves)
        name                = munitData.curves(i).name;
        [ curvedata, info ] = mescapiObjP.readCurve(handle, munitData.curves(i).curveIdx);
        curve               = formatCurve(curvedata, info);
        names               = [ names , name ];
        curves              = [ curves , curve ];
    end
    result = { names; curves };
end

function curve = formatCurve(sourceCurves, info)
    sizeC = info.size;
    curveX = zeros(1, sizeC);
    curveY = zeros(1, sizeC);
    if info.xType == "equidistant"
        %disp("equidistant")
        init = sourceCurves{1}(1);
        delta = sourceCurves{1}(2);
        curveX(1) = [init];
        for i=2:sizeC
            curveX(i) = curveX(i-1) + delta;
        end
    else
        curveX = sourceCurves(1);
    end   
    if info.yType == "rle"
        %disp("rle")
        sourceLen = length(sourceCurves{2});
        y = 1;
        for i=1:2:sourceLen
            for j=1:sourceCurves{2}(i)
                curveY(y) = sourceCurves{2}(i+1);
                y = y + 1;
            end
        end
    else
        curveY = sourceCurves(2);
    end
    curveX = curveX';
    curveY = curveY';
    curve = [curveX, curveY];
end