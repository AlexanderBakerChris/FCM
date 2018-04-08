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
 
% Find edges line according to position start and end point
%   used for the definition of line loads
        
function Edges = findEdges(obj,StartPoint,EndPoint)
% this function returns an array of all edges between LineStart and Line End
% Assumption : LineStart and LineEnd are real nodes and are on an
% actual edge line. Furthermore, every coordinate of LineStart
% should be smaller than the corresponding coordinate of LineEnd (the line
% is defined in positive coordinate direction).

% Edge lines are stored unseparatedly in the Edge array.

%%
    CoordinatesDifference = EndPoint - StartPoint;
    [StartEndDistance,LineDirection] = max(abs(CoordinatesDifference));
    % According to the assumptions, only one coordinate difference is non-zero
    % LineDirection = 1, 2 or 3 for x, y or z direction
    
    %% Testing input
    % Test: StartPoint and EndPoint are mesh nodes
    if ~obj.checkPointIsNode(StartPoint)
        Logger.ThrowException('(Error in line load definition: StartPoint has a problem.)');
    end
    if ~obj.checkPointIsNode(EndPoint)
        Logger.ThrowException('(Error in line load definition: EndPoint has a problem.)');
    end    
    % Test: Edges on a line
    if sum(CoordinatesDifference.^2)~= StartEndDistance^2
        Logger.ThrowException('Error in line load definition: no edge line between StartPoint and EndPoint.');
    end
    StartEndDistance = CoordinatesDifference(LineDirection); % Now StartEndDistance might happen to be negative
    % Test: StartPoint and EndPoint are different
    if StartEndDistance == 0
        Logger.ThrowException('Error in line load definition: StartPoint and EndPoint must be different points.');
    end
    % Test: Edges line positively oriented
    if StartEndDistance < 0
        Logger.ThrowException('Error in line load definition: The line between StartPoint and EndPoint should have a positive orientation.');
    end
        
    %% Find step size depending on the line direction
    switch LineDirection
        case 1
            StepSize = obj.Lx/obj.NumberOfXDivisions;
        case 2
            StepSize = obj.Ly/obj.NumberOfYDivisions;
        case 3
            StepSize = obj.Lz/obj.NumberOfZDivisions;
    end
    
    NumberOfEdgesOnLine = StartEndDistance/StepSize; 
    
    %% Convert coordinates of StartPoint into indices k,j,i
    [i,j,k] = obj.convertCoordinatesIntoIndices(StartPoint,@round);
    
    %% Define number of x and y edges
    NumberOfXEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1)*(obj.NumberOfZDivisions+1);
    NumberOfYEdges = obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1)*(obj.NumberOfXDivisions+1);
    
    %% Find the first edge of the line
    switch LineDirection
        case 1
            StartEdgeId = (i+1) + j*obj.NumberOfXDivisions...
                + k*obj.NumberOfXDivisions*(obj.NumberOfYDivisions + 1);
        case 2
            StartEdgeId = NumberOfXEdges + (j+1) + k*obj.NumberOfYDivisions...
                + i*obj.NumberOfYDivisions*(obj.NumberOfZDivisions + 1);
        case 3
            StartEdgeId = NumberOfXEdges + NumberOfYEdges + (k+1) ...
                + i*obj.NumberOfZDivisions ...
                + j*obj.NumberOfZDivisions*(obj.NumberOfXDivisions + 1);
    end
    
    %% Return
    Edges = obj.Edges(StartEdgeId:StartEdgeId+NumberOfEdgesOnLine-1);
    
end
