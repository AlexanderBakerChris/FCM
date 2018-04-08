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
 
function FacesOnCuboid = createFacesOnCuboid(obj,...
    NodesOnCuboid,EdgesOnCuboid)

%number of edges
NumberOfXEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1)*(obj.NumberOfZDivisions+1);
NumberOfYEdges = obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1)*(obj.NumberOfXDivisions+1);

%initialize faces on cuboid
FacesOnCuboid = [];


%create xy faces

%initialize NodesOnRectangle indices
NodesStartOfRectangle = 1;
NodesEndOfRectangle = (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
NodesOnRectangleIndices = NodesStartOfRectangle:NodesEndOfRectangle;

%initialize x-edges indices
XEdgesStartOfRectangle = 1;
XEdgesEndOfRectangle = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
XEdgesOnRectangleIndices = XEdgesStartOfRectangle:XEdgesEndOfRectangle;

%initialize y-edges indices
YEdgesOnRectangleIndices = [];
OneYLine = NumberOfXEdges+1:NumberOfXEdges+obj.NumberOfYDivisions;

for i=1:obj.NumberOfXDivisions+1
    YEdgesOnRectangleIndices = [YEdgesOnRectangleIndices OneYLine];
    OneYLine = OneYLine + obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
end

%loop in z direction
for i=1:obj.NumberOfZDivisions+1    
    %pick nodes array for xy-rectangle
    NodesOnRectangle = NodesOnCuboid(NodesOnRectangleIndices);
    
    %pick edges array for xy-rectangle

    %pick x-edges
    XEdgesOnRectangle = EdgesOnCuboid(XEdgesOnRectangleIndices);

    %pick y-edges
    YEdgesOnRectangle = EdgesOnCuboid(YEdgesOnRectangleIndices);

    %edges on rectangle
    EdgesOnRectangle = [XEdgesOnRectangle YEdgesOnRectangle];
    
    %create faces on xy-rectangle
    FacesOnCuboid = [FacesOnCuboid ...
        obj.createFacesOnRectangle(NodesOnRectangle,EdgesOnRectangle,obj.NumberOfXDivisions,obj.NumberOfYDivisions)];
    
    %increment nodes
    NodesOnRectangleIndices = NodesOnRectangleIndices+ (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
    
    %increment x-edges
    XEdgesOnRectangleIndices = XEdgesOnRectangleIndices + obj.NumberOfXDivisions *(obj.NumberOfYDivisions+1);
    
    %increment y-edges
    YEdgesOnRectangleIndices = YEdgesOnRectangleIndices+obj.NumberOfYDivisions;
end


%create yz faces

%initialize NodesOnRectangle indices
OneYLine = 1:(obj.NumberOfXDivisions+1):((obj.NumberOfYDivisions)*(obj.NumberOfXDivisions+1)+1);
NodesOnRectangleIndices = [];

for i=1:obj.NumberOfZDivisions+1
    NodesOnRectangleIndices = [NodesOnRectangleIndices OneYLine];
    OneYLine = OneYLine+(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
end

%initialize y-edges indices
YEdgesStartOfRectangle = NumberOfXEdges + 1;
YEdgesEndOfRectangle = NumberOfXEdges + obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
YEdgesOnRectangleIndices = YEdgesStartOfRectangle:YEdgesEndOfRectangle;

%initialize z-edges indices
ZEdgesOnRectangleIndices = [];
OneZLine = NumberOfXEdges+NumberOfYEdges+1:NumberOfXEdges+NumberOfYEdges+obj.NumberOfZDivisions;

for i=1:obj.NumberOfYDivisions+1
    ZEdgesOnRectangleIndices = [ZEdgesOnRectangleIndices OneZLine];
    OneZLine = OneZLine + obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);
end

%loop in x direction
for i=1:obj.NumberOfXDivisions+1 

    %pick nodes array for yz-rectangle
    NodesOnRectangle = NodesOnCuboid(NodesOnRectangleIndices);

    %pick edges array for yz-rectangle

    %pick y-edges
    YEdgesOnRectangle = EdgesOnCuboid(YEdgesOnRectangleIndices);

    %pick z-edges
    ZEdgesOnRectangle = EdgesOnCuboid(ZEdgesOnRectangleIndices);
    EdgesOnRectangle = [YEdgesOnRectangle ZEdgesOnRectangle];

    %create faces on yz-rectangle
    FacesOnCuboid = [FacesOnCuboid ...
        obj.createFacesOnRectangle(NodesOnRectangle,EdgesOnRectangle,obj.NumberOfYDivisions,obj.NumberOfZDivisions)];

    %increment nodes
    NodesOnRectangleIndices = NodesOnRectangleIndices + 1;

    %increment y-edges
    YEdgesOnRectangleIndices = YEdgesOnRectangleIndices + obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);

    %increment z-edges
    ZEdgesOnRectangleIndices = ZEdgesOnRectangleIndices + obj.NumberOfZDivisions;
end

%create zx faces

%initialize NodesOnRectangle indices
OneZLine = 1:(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1):(obj.NumberOfZDivisions)*(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1)+1;
NodesOnRectangleIndices = [];

for i=1:obj.NumberOfXDivisions+1
    NodesOnRectangleIndices = [NodesOnRectangleIndices OneZLine];
    OneZLine = OneZLine + 1;
end

%initialize z-edges indices
ZEdgesStartOfRectangle = NumberOfXEdges + NumberOfYEdges + 1;
ZEdgesEndOfRectangle = NumberOfXEdges+NumberOfYEdges+ obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);
ZEdgesOnRectangleIndices = ZEdgesStartOfRectangle:ZEdgesEndOfRectangle;

%initialize x-edges indices
XEdgesOnRectangleIndices = [];
OneXLine = 1:obj.NumberOfXDivisions;

for i=1:obj.NumberOfZDivisions+1
    XEdgesOnRectangleIndices = [XEdgesOnRectangleIndices OneXLine];
    OneXLine = OneXLine + obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
end

%loop in y direction
for i=1:obj.NumberOfYDivisions+1 

    %pick nodes array for zx-rectangle
    NodesOnRectangle = NodesOnCuboid(NodesOnRectangleIndices);

    %pick edges array for yz-rectangle

    %pick z-edges
    ZEdgesOnRectangle = EdgesOnCuboid(ZEdgesOnRectangleIndices);

    %pick x-edges
    XEdgesOnRectangle = EdgesOnCuboid(XEdgesOnRectangleIndices);
    EdgesOnRectangle = [ZEdgesOnRectangle XEdgesOnRectangle];

    %create faces on yz-rectangle
    FacesOnCuboid = [FacesOnCuboid ...
        obj.createFacesOnRectangle(NodesOnRectangle,EdgesOnRectangle,obj.NumberOfZDivisions,obj.NumberOfXDivisions)];

    %increment nodes
    NodesOnRectangleIndices = NodesOnRectangleIndices + obj.NumberOfXDivisions + 1;

    %increment z-edges
    ZEdgesOnRectangleIndices = ZEdgesOnRectangleIndices + obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);

    %increment x-edges
    XEdgesOnRectangleIndices = XEdgesOnRectangleIndices + obj.NumberOfXDivisions;
end

end
