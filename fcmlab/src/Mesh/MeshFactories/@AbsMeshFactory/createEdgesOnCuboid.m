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
 
function EdgesOnCuboid = createEdgesOnCuboid(obj,NodesOnCuboid)

EdgesOnCuboid = [];

%create x-edges

%initialize NodesOnRectangleIndices
NodesStartOfRectangle = 1;
NodesEndOfRectangle = (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
NodesOnRectangleIndices = NodesStartOfRectangle:NodesEndOfRectangle;

%loop in z direction
for i=1:obj.NumberOfZDivisions+1
    
    %pick nodes array for xy-rectangle
    NodesOnRectangle = NodesOnCuboid(NodesOnRectangleIndices);
    
    %create edges in x-direction
    EdgesOnCuboid = [EdgesOnCuboid ...
        obj.createEdgesOnRectangleDirection1(NodesOnRectangle,...
        obj.NumberOfXDivisions,obj.NumberOfYDivisions)];
    
    %increment
    NodesOnRectangleIndices = NodesOnRectangleIndices+(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
end


%create y-edges

%initialize NodesOnRectangleIndices
OneYLine = 1:(obj.NumberOfXDivisions+1):((obj.NumberOfYDivisions)*(obj.NumberOfXDivisions+1)+1);
NodesOnRectangleIndices = [];
for i=1:obj.NumberOfZDivisions+1
    NodesOnRectangleIndices = [NodesOnRectangleIndices OneYLine];
    OneYLine = OneYLine+(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
end

%loop in x direction
for i=1:obj.NumberOfXDivisions+1
    
    %pick nodes array for yz-rectangle
    NodesOnRectangle = NodesOnCuboid(NodesOnRectangleIndices);
    
    %create edges in y-direction
    EdgesOnCuboid = [EdgesOnCuboid ...
        obj.createEdgesOnRectangleDirection1(NodesOnRectangle,obj.NumberOfYDivisions,obj.NumberOfZDivisions)];
    
    %increment
    NodesOnRectangleIndices = NodesOnRectangleIndices + 1;
end


%create z-edges

%initialize NodesOnRectangleIndices
OneZLine = 1:(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1):(obj.NumberOfZDivisions)*(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1)+1;
NodesOnRectangleIndices = [];
for i=1:obj.NumberOfXDivisions+1
    NodesOnRectangleIndices = [NodesOnRectangleIndices OneZLine];
    OneZLine = OneZLine+1;
end

%loop in y direction
for i=1:obj.NumberOfYDivisions+1
    
    %pick nodes array for zx-rectangle
    NodesOnRectangle = NodesOnCuboid(NodesOnRectangleIndices);
    
    %create edges in z-direction
    EdgesOnCuboid = [EdgesOnCuboid ...
        obj.createEdgesOnRectangleDirection1(NodesOnRectangle,obj.NumberOfZDivisions,obj.NumberOfXDivisions)];
    
    %increment NodesOnRectangleIndices
    NodesOnRectangleIndices = NodesOnRectangleIndices + obj.NumberOfXDivisions + 1;
end

end