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

function Triangles = getBoundary(obj)

xmin=obj.BoundingBox(1);
xmax=obj.BoundingBox(2);
ymin=obj.BoundingBox(3);
ymax=obj.BoundingBox(4);
zmin=obj.BoundingBox(5);
zmax=obj.BoundingBox(6);


inc=(xmax-xmin)/obj.partDepth;

[x,y,z] = meshgrid(xmin:inc:xmax, ymin:inc:ymax,zmin:inc:zmax);



domainIndices = zeros( size(x) );

for i = 1:size(domainIndices,1)
    for j = 1:size(domainIndices,2)
        for k = 1:size(domainIndices,3)
            
            domainIndices(i,j,k) = getDomainIndex(obj.Geometry, [x(i,j,k) y(i,j,k) z(i,j,k)] );
        end
    end
end

[F,V] = isosurface(x,y,z,domainIndices,1.5);

% To visualize the results
patch(isosurface(x,y,z,domainIndices,1.5),'FaceColor','g')

% aus F und V m�ssen jetzt noch FCMLab Triangles gemacht werden.

%Convert V to array of FCMLab Vertices
VertexArray=[];
for l=1:size(V,1)
    VertexArray=[VertexArray; Vertex(V(l,:))];
end

retTriangles=[];
for m = 1:size(F,1)
    
    Line1=Line(VertexArray(F(m,2)),VertexArray(F(m,3)));
    Line2=Line(VertexArray(F(m,3)),VertexArray(F(m,1)));
    Line3=Line(VertexArray(F(m,1)),VertexArray(F(m,2)));
    Lines=[Line1;Line2;Line3];
%     % For Visualization only
%     hold on;
%     line([;c(1,(i+2))],[c(2,(i+1)); c(2,(i+2))]) %plots lines
%     
%     
%     %------
    Vertices=[VertexArray(F(m,1));VertexArray(F(m,2));VertexArray(F(m,3))];
    
    retTriangles=[retTriangles Triangle(Vertices,Lines)];
end


Triangles=retTriangles;







