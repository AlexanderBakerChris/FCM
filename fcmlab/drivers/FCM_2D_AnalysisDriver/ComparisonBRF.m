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
 
%% 2D FCM - Comparison BRF with Spacetree, Seedpoints

clear all;
close all;


    % BoundingBox
vertex1 = Vertex([0.0 0.0 0.0]);
vertex2 = Vertex([.5 0.0 0.0]);
vertex3 = Vertex([.5 .5 0.0]);
vertex4 = Vertex([0.0 .5 0.0]);

line1 = Line(vertex1,vertex2);
line2 = Line(vertex2,vertex3);
line3 = Line(vertex3,vertex4);
line4 = Line(vertex4,vertex1);

BoundingBox = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);

%Geometry

domainFunctionHandle = @(x,y,z) ...
    2 - ((x^2+y^2)<0.25);

Geometry = FunctionHandleDomain(domainFunctionHandle);

PartDepth=[1 2 3 1 2 3 1 2 3];
SeedP=[0 0 0 3 3 3 9 9 9];
figure('Name','Comparison BRF with Spacetree, Seedpoints')
colormap([1 1 1]);
for i=1:9


subplot(3,3,i)
axis equal
PartitionDepth=PartDepth(i);
SeedPoints=SeedP(i);

BoundaryRecoveryFactory=BoundaryRecoveryFactory(Geometry,BoundingBox,PartitionDepth,SeedPoints);
BoundaryRecoveryFactory.getBoundaryWithVisual();
circle(0.0,0.0,.5)
axis([0 0.5 0 0.5])

 title({['Partition Depth of SpaceTree: ',num2str(PartitionDepth)];
     ['Number of Seed Points: ',num2str(SeedPoints)]})
clear BoundaryRecoveryFactory

end


