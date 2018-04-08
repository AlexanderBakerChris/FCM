%=======================================================================%
%                     ______________  _____          __                 %
%                    / ____/ ____/  |/  / /   ____ _/ /_                %
%                   / /_  / /   / /|_/ / /   / __ `/ __ \               %
%                  / __/ / /___/ /  / / /___/ /_/ / /_/ /               %
%                 /_/    \____/_/  /_/_____/\__,_/_.___/                %
%                                                                       %
%                                                                       %
% Copyright (c) 2012, 2013                                              %
% Computation in Engineering, Technische Universitaet Muenchen          %
%                                                                       %
% This file is part of the MATLAB toolbox FCMLab. This library is free  %
% software; you can redistribute it and/or modify it under the terms of %
% the GNU General Public License as published by the Free Software      %
% Foundation; either version 3, or (at your option) any later version.  %
%                                                                       %
% This library is distributed in the hope that it will be useful,       %
% but WITHOUT ANY WARRANTY; without even the implied warranty of        %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          %
% GNU General Public License for more details.                          %
%                                                                       %
% You should have received a copy of the GNU General Public License     %
% along with this program; see the files COPYING respectively.          %
% If not, see <http://www.gnu.org/licenses/>.                           %
%                                                                       %
% In case of a scientific publication of results obtained using FCMLab, %
% we ask the authors to cite the introductory article                   %
%                                                                       %
% N. Zander, T. Bog, M. Elhaddad, R. Espinoza, H. Hu, A. F. Joly,       %
% C. Wu, P. Zerbe, A. Duester, S. Kollmannsberger, J. Parvizian,        %
% M. Ruess, D. Schillinger, E. Rank:                                    %
% "FCMLab: A Finite Cell Research Toolbox for MATLAB."                  %
% Submitted to Advances in Engineering Software, 2013					%
%                                                                       %
%=======================================================================%
 
% Find faces according to starting point and end point
%   used for the definition of face loads
%   StartPoint and EndPoint are two opposite vertices of a rectangle
        
function [Faces,NumberOfFacesAlong1,NumberOfFacesAlong2] = findFaces(obj,StartPoint,EndPoint)

% this function returns an array of all faces between StartPoint and EndPoint
% Assumption : StartPoint and EndPoint are real nodes and are on an
% actual face plane. Furthermore, every coordinate of StartPoint
% should be smaller than the corresponding coordinate of EndPoint (the 
% rectangle is defined in positive coordinate direction).

    % testing that input points are actual nodes
%%
    CoordinatesDifference = EndPoint - StartPoint;
    [ShouldBeZero,FaceType] = min(abs(CoordinatesDifference));
    % According to the assumptions, one and only one coordinate difference is non-zero
    % FaceType = 1 for yz, 2 for zx, 3 for xy
    %% Testing input
    % Test: StartPoint and EndPoint are mesh nodes
    if ~obj.checkPointIsNode(StartPoint)
        Logger.ThrowException('(Error in face load definition: StartPoint has a problem.)');
    end
    if ~obj.checkPointIsNode(EndPoint)
        Logger.ThrowException('(Error in face load definition: EndPoint has a problem.)');
    end  
    % Test: At least one entry of CoordinatesDifference is zero
    if ShouldBeZero ~= 0 
        Logger.ThrowException('Error in face load definition: StartPoint and EndPoint should be on the same plane (xy, yz or zx)');
    end
    % Test: Only one entry of CoordinatesDifference is zero
    if sum(CoordinatesDifference.^2)== max(CoordinatesDifference)^2
        Logger.ThrowException(['Error in face load definition:'...
            '\n input points should have different coordinates' ...
            '\n and the line between StartPoint and EndPoint should not be parallel to x-, y- or z-axis.']);
    end
    
    %% Find step size depending on the type of faces
    switch FaceType
        case 1 %yz
            [StartEndDistanceY,StartEndDistanceZ,NumberOfFacesAlongY,NumberOfFacesAlongZ] ...
             = defineParametersOfLoadRectangle(2,3,obj.Ly,obj.Lz,obj.NumberOfYDivisions,obj.NumberOfZDivisions,CoordinatesDifference);
            checkPositiveOrientationOfPoints(StartEndDistanceY,StartEndDistanceZ);
            NumberOfFacesAlong1 = NumberOfFacesAlongY;
            NumberOfFacesAlong2 = NumberOfFacesAlongZ;
        
        case 2 %zx
            [StartEndDistanceZ,StartEndDistanceX,NumberOfFacesAlongZ,NumberOfFacesAlongX] ...
             = defineParametersOfLoadRectangle(3,1,obj.Lz,obj.Lx,obj.NumberOfZDivisions,obj.NumberOfXDivisions,CoordinatesDifference);
            checkPositiveOrientationOfPoints(StartEndDistanceZ,StartEndDistanceX);
            NumberOfFacesAlong1 = NumberOfFacesAlongZ;
            NumberOfFacesAlong2 = NumberOfFacesAlongX;
        
        case 3 %xy
            [StartEndDistanceX,StartEndDistanceY,NumberOfFacesAlongX,NumberOfFacesAlongY] ...
             = defineParametersOfLoadRectangle(1,2,obj.Lx,obj.Ly,obj.NumberOfXDivisions,obj.NumberOfYDivisions,CoordinatesDifference);
            checkPositiveOrientationOfPoints(StartEndDistanceX,StartEndDistanceY);
            NumberOfFacesAlong1 = NumberOfFacesAlongX;
            NumberOfFacesAlong2 = NumberOfFacesAlongY;
    end
    
    %% Convert coordinates of StartPoint into indices k,j,i
    [i,j,k] = obj.convertCoordinatesIntoIndices(StartPoint,@round);
    
    % Define number of xy and yz faces
    NumberOfXYFaces = obj.NumberOfXDivisions*obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
    NumberOfYZFaces = obj.NumberOfYDivisions*obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);
    
    %% Assign the faces according to the face type
    switch FaceType
        case 1 %yz
            Faces = pickFaces(j+1,k+1,i+1,obj.NumberOfYDivisions,obj.NumberOfZDivisions,...
                NumberOfFacesAlongY,NumberOfFacesAlongZ,NumberOfXYFaces,obj.Faces);
        case 2 %zx
            Faces = pickFaces(k+1,i+1,j+1,obj.NumberOfZDivisions,obj.NumberOfXDivisions,...
                NumberOfFacesAlongZ,NumberOfFacesAlongX,NumberOfXYFaces+NumberOfYZFaces,obj.Faces);
        case 3 % xy
            Faces = pickFaces(i+1,j+1,k+1,obj.NumberOfXDivisions,obj.NumberOfYDivisions,...
                NumberOfFacesAlongX,NumberOfFacesAlongY,0,obj.Faces);
    end    

end

% function to define geometric parameters
function [StartEndDistance1,StartEndDistance2,NumberOfFacesAlong1,NumberOfFacesAlong2] ...
    = defineParametersOfLoadRectangle(direction1,direction2,L1,L2,...
    NumberOf1Divisions,NumberOf2Divisions,CoordinatesDifference)

    StepSize1 = L1/NumberOf1Divisions;
    StepSize2 = L2/NumberOf2Divisions;
    StartEndDistance1 = CoordinatesDifference(direction1);
    StartEndDistance2 = CoordinatesDifference(direction2);
    NumberOfFacesAlong1 = round(StartEndDistance1/StepSize1);
    NumberOfFacesAlong2 = round(StartEndDistance2/StepSize2);
    
end

% function to get the wanted faces
function Faces = pickFaces(Direction1,Direction2,Direction3,...
    NumberOf1Divisions,NumberOf2Divisions,...
    NumberOfFacesAlong1,NumberOfFacesAlong2,Zero,MeshFaces)

    Faces = [];
    StartFaceId = Zero + Direction1 + (Direction2-1)*NumberOf1Divisions...
        + (Direction3-1)*NumberOf1Divisions*NumberOf2Divisions;
    % loop from 1 to NumberOfFacesAlongDirection2
    for j = 1:NumberOfFacesAlong2
        Faces = [Faces MeshFaces(StartFaceId:StartFaceId+NumberOfFacesAlong1-1)];
        StartFaceId = StartFaceId + NumberOf1Divisions;
    end
    
end

% function to test that the coordinates of the start point are smaller
% thant the ones of the end point
function checkPositiveOrientationOfPoints(StartEndDistance1,StartEndDistance2)
    if ( StartEndDistance1 < 0 || StartEndDistance2 < 0 )
        Logger.ThrowException('Error in face load definition: The line between StartPoint and EndPoint should have a positive orientation.');
    end
end
