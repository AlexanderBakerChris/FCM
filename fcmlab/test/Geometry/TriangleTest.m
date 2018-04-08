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
 
%Test of triangle class

classdef TriangleTest < TestCase
    
    properties
        MyTriangle
    end
    
    methods
        %% Constructor
        function obj = TriangleTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Set up
        function setUp(obj)
            Vertex1 = Vertex([0 0 0]);
            Vertex2 = Vertex([6 0 0]);
            Vertex3 = Vertex([5 5 1]);
            Line1 = Line(Vertex1,Vertex2);
            Line2 = Line(Vertex2,Vertex3);
            Line3 = Line(Vertex3,Vertex1);
            MyVertices = [Vertex1 Vertex2 Vertex3];
            MyLines = [Line1 Line2 Line3];
            obj.MyTriangle = Triangle(MyVertices, MyLines);
        end
        
        %% Test get vertices
        function testGetVertices(obj)
            assertEqual(obj.MyTriangle.getVertices, ...
                [Vertex([0 0 0]) Vertex([6 0 0]) Vertex([5 5 1]) Vertex([5 5 1])] );
        end
        %% Test get verticesCoordinates
        function testGetVerticesCoordinates(obj)
            MyVertices = obj.MyTriangle.getVertices();
            MyVerticesCoordinates = obj.MyTriangle.getVerticesCoordinates();
            for i = 1:length(MyVertices)
                assertEqual(MyVerticesCoordinates(i,:),MyVertices(i).getCoords());
            end
        end
        
        %% Test get lines
        function testGetLines(obj)
            assertEqual(obj.MyTriangle.getLines, ...
                [ ...
                Line(Vertex([0 0 0]),Vertex([6 0 0])) ...
                Line(Vertex([6 0 0]),Vertex([5 5 1])) ...
                Line(Vertex([5 5 1]),Vertex([5 5 1])) ...
                Line(Vertex([5 5 1]),Vertex([0 0 0])) ...
                ] );
        end
        
        %% Test calc centroid
        function testCalcCentroid(obj)
            % the centroid for a triangle is not used and this result is
            % taking the mean value of 4 vertices, since a triangle takes
            % twice the vertex 3
            assertElementsAlmostEqual(obj.MyTriangle.calcCentroid, [4 2.5 0.5]);
        end
        
        %% Test calculate base vector1
        function testCalcBaseVector1(obj)
            LocalCoords = [0.3 0.4];
            g1 = obj.MyTriangle.calcBaseVector1(LocalCoords);
            assertElementsAlmostEqual(g1,[0.9 0.0 0.0]);
        end
        
        %% Test calculate base vector2
        function testCalcBaseVector2(obj)
            LocalCoords = [0.3 0.4];
            g2 = obj.MyTriangle.calcBaseVector2(LocalCoords);
            assertElementsAlmostEqual(g2,[0.55 2.50 0.50]);
        end
        
        %% Test calculate normal vector
        function testCalcNormalVector(obj)
            LocalCoords = [0.3 0.4];
            NormalVector = obj.MyTriangle.calcNormalVector(LocalCoords);
            assertElementsAlmostEqual(NormalVector,[0 -0.19611613513 0.98058067569]);
        end
        
        %% Test calculate jacobian
        function testCalcJacobian(obj)
            LocalCoords = [0.3 0.4];
            J = obj.MyTriangle.calcJacobian(LocalCoords);
            assertElementsAlmostEqual(J, [[0.9 0.0 0.0];[0.55 2.50 0.50]]);
        end
        
        %% Test calculate det jacobian
        function testCalcDetJacobian(obj)
            LocalCoords = [0.3 0.4];
            detJ = obj.MyTriangle.calcDetJacobian(LocalCoords);
            assertElementsAlmostEqual(detJ,2.2945587811);
        end       
      
       %% Test Map from quad coordinates (r,s) to global coordinates
       function testMapLocalToGlobalCoords(obj)
           GlobalCoordinates1 = obj.MyTriangle.mapLocalToGlobal([-1 -1]);
           GlobalCoordinates2 = obj.MyTriangle.mapLocalToGlobal([ 1 -1]);
           GlobalCoordinates3 = obj.MyTriangle.mapLocalToGlobal([ 1  1]);
           GlobalCoordinates4 = obj.MyTriangle.mapLocalToGlobal([-1  1]);
           assertEqual(GlobalCoordinates1,[0 0 0]);
           assertEqual(GlobalCoordinates2,[6 0 0]);
           assertEqual(GlobalCoordinates3,[5 5 1]);
           assertEqual(GlobalCoordinates4,[5 5 1]);
       end

   end
end