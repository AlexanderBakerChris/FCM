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
 
% creates nodes in both x and y directions
% StartPoint is Southwest (x,y minimal)
% EndPoint is NorthEast (x,y maximal)

function NodesOnRectangle = createNodesOnRectangle(obj,...
    StartPoint,EndPoint)

yIncrement = (EndPoint(2) - StartPoint(2))/obj.NumberOfYDivisions;

%initialize
NodesStartOfLine = 1;
NodesEndOfLine = NodesStartOfLine + (obj.NumberOfXDivisions);

% loop; at each step, a line of nodes (x direction) is created
% at y coordinate YCoordinate

for i=1:obj.NumberOfYDivisions+1
    YCoordinate = StartPoint(2)+(i-1)*yIncrement;
    
    NodesOnRectangle(NodesStartOfLine:NodesEndOfLine)...
        = obj.createNodesOnLine([StartPoint(1) YCoordinate StartPoint(3)],...
        [EndPoint(1) YCoordinate EndPoint(3)]);
    
    %increment
    % Each line has (obj.NumberOfXDivisions+1) nodes
    NodesStartOfLine = NodesStartOfLine + (obj.NumberOfXDivisions+1);
    NodesEndOfLine = NodesStartOfLine + (obj.NumberOfXDivisions);
end

end