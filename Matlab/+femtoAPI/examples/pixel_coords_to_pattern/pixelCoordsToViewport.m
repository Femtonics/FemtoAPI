% Copyright ©2023. Femtonics Ltd. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

classdef pixelCoordsToViewport
    %'coordsList' input parameter should be a json file containing a list of pixel coordinates 
    %   e.g.: [[10,10,0],[20,20,0],[15,50,-10]]
    %'handle' input parameter is the munit handle of the measurement
    %   unit in mesc of which viewport should be used for the transformation
    %getViewportCoordinates function returns the list of transformed coordinates
    
    properties
        urlAddressAndPort = 'ws://localhost:8888';
        newcords = [];
    end
    
    methods
        function obj = pixelCoordsToViewport(handle, coordsList)
            fileID = fopen('coords.json','r');
            jsonstr = fscanf(fileID, '%s');
            fclose(fileID);
            coordsList = jsondecode(jsonstr);
            coordsList = coordsList';

            mescapiObjP = FemtoAPIProcessing(obj.urlAddressAndPort);
            viewport = mescapiObjP.getUnitMetadata(handle,'ReferenceViewport');
            metadata = mescapiObjP.getUnitMetadata(handle,'BaseUnitMetadata');
            mescapiObjP.disconnect();
            
            pixX = metadata.pixelSizeX;
            pixY = metadata.pixelSizeY;
            rot = viewport.viewports.geomTransRot;
            trans = viewport.viewports.geomTransTransl;
            yDim = metadata.yDim;
            
            for coords = coordsList
                x = coords(1) * pixX;
                y = coords(2) * pixY;
                z = 0;
                pixval = [x y z];
                rotated = obj.rotq(pixval,rot);
                newp = [rotated(2) rotated(3) rotated(4)];
                translated = [newp(1)+trans(1),newp(2)+trans(2),newp(3)+trans(3)];
                obj.newcords = [obj.newcords;translated];
            end
        end
        
        function output = quatMult(obj,q1,q2)
            t1 = q1(1)*q2(1)-q1(2)*q2(2)-q1(3)*q2(3)-q1(4)*q2(4);
            t2 = q1(1)*q2(2)+q1(2)*q2(1)-q1(3)*q2(4)+q1(4)*q2(3);
            t3 = q1(1)*q2(3)+q1(2)*q2(4)+q1(3)*q2(1)-q1(4)*q2(2);
            t4 = q1(1)*q2(4)-q1(2)*q2(3)+q1(3)*q2(2)+q1(4)*q2(1);
            output = [t1;t2;t3;t4];
        end
        
        function invertedQ = quatInv(obj,q)
            invertedQ = [q(1);q(2)*-1;q(3)*-1;q(4)*-1];
        end
        
        function coords = rotq(obj,inputCoords,rotQ)
            p = [0;inputCoords(1);inputCoords(2);inputCoords(3)];
            q = [rotQ(4);rotQ(1);rotQ(2);rotQ(3)];
            qinv = obj.quatInv(q);
            tmp = obj.quatMult(qinv,p);
            coords = obj.quatMult(tmp,q);
        end
        
        function viewportCoords = getViewportCoordinates(obj)
            viewportCoords = obj.newcords;
        end
    end
end

