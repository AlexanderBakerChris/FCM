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

function Lines = getBoundaryAndNormalsOut(obj)

Partitioner = QuadTree(obj.Geometry, obj.partDepth);
subDomains = Partitioner.partition(obj.BoundingBox);
retLines=[];
% in every leave of the space tree
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
    
    
    
    if (obj.seedPoints~=0)
        x = linspace(xVerts(1,1),xVerts(2,1),obj.seedPoints);
        y = linspace(xVerts(1,2),xVerts(4,2),obj.seedPoints);
        z = zeros( length(x),length(y) );
        
        for i = 1:size(z,1)
            for l = 1:size(z,2)
                z(i,l) = getDomainIndex(obj.Geometry, [x(l) y(i) 0] );
            end
        end
        
    end
    
    c=contourc(x,y,z,[1.5 1.5]);
 
    if (not(isempty(c)))
        
        for i=1:(size(c,2)-2)
            vertex1 = Vertex([c(1,(i+1)) c(2,(i+1)) 0.0]);
            vertex2 = Vertex([c(1,(i+2)) c(2,(i+2)) 0.0]);
            
            TestLine=Line(vertex1,vertex2);
            NormalVector = TestLine.calcNormalVector();
            
            StartPoint=[x(1) y(1) 0];
            
            if (obj.seedPoints~=0)
                %Find the right point to compare with:
                Center=TestLine.calcCentroid();
                dx=(xVerts(2,1)-xVerts(1,1))/(obj.seedPoints-1);                              
                StartPoint(1)=dx*floor((Center(1)/dx));
                StartPoint(2)=dx*floor((Center(2)/dx));                
            end
            
            TestVector=StartPoint-[c(1,(i+1)) c(2,(i+1)) 0.0];
           
            %To decide if the Normal has to be flipped, the scalar product of
            %the normal vector to the Testline and the vector from the
            %starting point to one corner point of the space tree leave is
            %calculated.
            if(getDomainIndex(obj.Geometry, StartPoint )==1&&sign([NormalVector 0]*TestVector')==1)
                % Point in the left lower corner is in and Normal points inwards
                retLines=[retLines Line(vertex2,vertex1)];
                
            elseif(getDomainIndex(obj.Geometry, StartPoint )==2&&sign([NormalVector 0]*TestVector')~=1)
                % Point in the left lower corner is in and Normal points
                % outwards
                retLines=[retLines Line(vertex2,vertex1)];
                
                
            else
                retLines=[retLines Line(vertex1,vertex2)];
                
                
                
            end
        end
    end
    Lines=retLines;
end





