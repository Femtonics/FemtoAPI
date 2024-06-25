function curve = curveExport(mescapiObjP ,handle, curveName)
    % reads a specific curve from a measurement file and returns it
    % mescapiObjP is a femtoAPI object which fold the connection
    % handle is the measurement handle eg.: [59 0 0]
    % curveName is a string with the name of a specific curve
    % if no curve found with curveName an empty vector is returned
    munitData = mescapiObjP.getChildTree(handle);
    curve = [];
    for i = 1:length(munitData.curves)
        name = munitData.curves(i).name;
        if strcmp(name, curveName)
            [curvedata, info] = mescapiObjP.readCurve(handle, munitData.curves(i).curveIdx);
            curve = formatCurve(curvedata, info);
        end
    end
end

function curves = formatCurve(sourceCurves, info)
    sizeC = info.size;
    curveX = zeros(1, sizeC);
    curveY = zeros(1, sizeC);
    if info.xType == "equidistant"
        disp("equidistant")
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
        disp("rle")
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
    curves = {curveX, curveY};
end