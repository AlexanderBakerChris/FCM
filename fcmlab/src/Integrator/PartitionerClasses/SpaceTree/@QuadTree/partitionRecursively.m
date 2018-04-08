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
 
%%
function subDomains = partitionRecursively(obj, indexGeometry, support, subDomains, depthCounter)
   
    if(obj.isIntersected(indexGeometry,support) && depthCounter < obj.Depth)
        
        % 7--5--8--6--9
        % |     |     |
        % 10    11    12
        % |     |     |
        % 4--3--5--4--6
        % |     |     |
        % 7     8     9
        % |     |     |
        % 1--1--2--2--3
       
        vertices = Vertex.empty(9,0);
        
        vertices(1) = Vertex(indexGeometry.mapLocalToGlobal([-1.0,-1.0]));
        vertices(2) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0,-1.0]));
        vertices(3) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0,-1.0]));
        vertices(4) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 0.0]));
        vertices(5) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 0.0]));
        vertices(6) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 0.0]));
        vertices(7) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 1.0]));
        vertices(8) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 1.0]));
        vertices(9) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 1.0]));

        lines = Line.empty(12,0);
        lines(1) = Line( vertices(1), vertices(2) );
        lines(2) = Line( vertices(2), vertices(3) );
        lines(3) = Line( vertices(4), vertices(5) );
        lines(4) = Line( vertices(5), vertices(6) );
        lines(5) = Line( vertices(7), vertices(8) );
        lines(6) = Line( vertices(8), vertices(9) );
        lines(7) = Line( vertices(1), vertices(4) );
        lines(8) = Line( vertices(2), vertices(5) );
        lines(9) = Line( vertices(3), vertices(6) );
        lines(10) = Line( vertices(4), vertices(7) );
        lines(11) = Line( vertices(5), vertices(8) );
        lines(12) = Line( vertices(6), vertices(9) );
        
        
        quadLowerLeft  = Rectangle( vertices([1 2 5 4]), lines([1 8 3 7]) );
        quadLowerRight = Rectangle( vertices([2 3 6 5]), lines([2 9 4 8]) );
        quadUpperLeft  = Rectangle( vertices([4 5 8 7]), lines([3 11 5 10]) );
        quadUpperRight = Rectangle( vertices([5 6 9 8]), lines([4 12 6 11]) );
        
        depthCounter = depthCounter + 1;

        subDomains = obj.partitionRecursively(quadLowerLeft,support,subDomains, depthCounter);
        subDomains = obj.partitionRecursively(quadLowerRight,support,subDomains, depthCounter);
        subDomains = obj.partitionRecursively(quadUpperLeft,support,subDomains, depthCounter);
        subDomains = obj.partitionRecursively(quadUpperRight,support,subDomains, depthCounter);
    else
        subDomains = [subDomains indexGeometry];
    end

end

