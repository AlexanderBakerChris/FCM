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
 
function Quads = getBoundaryWithVisual(obj)

Partitioner = QuadTree(obj.Geometry, obj.partDepth);
subDomains = Partitioner.partition(obj.BoundingBox);
retQuads=[];
for j=1:length(subDomains)
    
    xVerts=[subDomains(j).getVerticesCoordinates zeros(4,1)];
    for k=1:4
        xVerts(k,1:3)=obj.BoundingBox.mapLocalToGlobal([xVerts(k,1) xVerts(k,2)]);
        xVerts(k,4)=getDomainIndex(obj.Geometry,xVerts(k,1:3));
    end
    x=[xVerts(1,1) xVerts(2,1)];
    y=[xVerts(1,2) xVerts(4,2)];
    z=[xVerts(1,4) xVerts(2,4);
        xVerts(4,4) xVerts(3,4)];
    x4=[0 0;0 0];
    x5=[1 1; 1 1];
    
    %plots only for visual checking
    hold on;
    surf(x,y,x4)
    
 if (z(1,1)==z(1,2)&&z(1,1)==z(2,1)&&z(1,1)==z(2,2))
 else
    retQuads=[  retQuads subDomains(j)];
    surf(x,y,x5)
 end
 
end




Quads=retQuads;


