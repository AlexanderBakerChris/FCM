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
 
%Test of quad class

classdef QuadTest < TestCase
    
    properties
        MyQuad
    end
    
    methods
        %% Constructor
        function obj = QuadTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Set up
        function setUp(obj)
            Vertex1 = Vertex([0 0 0]);
            Vertex2 = Vertex([6 0 0]);
            Vertex3 = Vertex([5 5 1]);
            Vertex4 = Vertex([1 3 1]);
            Line1 = Line(Vertex1,Vertex2);
            Line2 = Line(Vertex2,Vertex3);
            Line3 = Line(Vertex3,Vertex4);
            Line4 = Line(Vertex4,Vertex1);
            MyVertices = [Vertex1 Vertex2 Vertex3 Vertex4];
            MyLines = [Line1 Line2 Line3 Line4];
            obj.MyQuad = Quad(MyVertices, MyLines);
        end
        
        %% Test get vertices
        function testGetVertices(obj)
            assertEqual(obj.MyQuad.getVertices, ...
                [Vertex([0 0 0]) Vertex([6 0 0]) Vertex([5 5 1]) Vertex([1 3 1])] );
        end
        %% Test get verticesCoordinates
        function testGetVerticesCoordinates(obj)
            MyVertices = obj.MyQuad.getVertices();
            MyVerticesCoordinates = obj.MyQuad.getVerticesCoordinates();
            for i = 1:length(MyVertices)
                assertEqual(MyVerticesCoordinates(i,:),MyVertices(i).getCoords());
            end
        end
        
        %% Test get lines
        function testGetLines(obj)
            assertEqual(obj.MyQuad.getLines, ...
                [ ...
                Line(Vertex([0 0 0]),Vertex([6 0 0])) ...
                Line(Vertex([6 0 0]),Vertex([5 5 1])) ...
                Line(Vertex([5 5 1]),Vertex([1 3 1])) ...
                Line(Vertex([1 3 1]),Vertex([0 0 0])) ...
                ] );
        end
        
        %% Test calc centroid
        function testCalcCentroid(obj)
            assertElementsAlmostEqual(obj.MyQuad.calcCentroid, [3 2 0.5]);
        end
        
        %% Test calculate base vector1
        function testCalcBaseVector1(obj)
            LocalCoords = [0.3 0.4];
            g1 = obj.MyQuad.calcBaseVector1(LocalCoords);
            assertElementsAlmostEqual(g1,[2.3 0.7 0.0]);
        end
        
        %% Test calculate base vector2
        function testCalcBaseVector2(obj)
            LocalCoords = [0.3 0.4];
            g2 = obj.MyQuad.calcBaseVector2(LocalCoords);
            assertElementsAlmostEqual(g2,[-0.15 2.15 0.50]);
        end
        
        %% Test calculate normal vector
        function testCalcNormalVector(obj)
            LocalCoords = [0.3 0.4];
            NormalVector = obj.MyQuad.calcNormalVector(LocalCoords);
            assertElementsAlmostEqual(NormalVector,[0.067423113550 -0.22153308738 0.97281920979]);
        end
        
        %% Test calculate jacobian
        function testCalcJacobian(obj)
            LocalCoords = [0.3 0.4];
            J = obj.MyQuad.calcJacobian(LocalCoords);
            assertElementsAlmostEqual(J, [[2.3 0.7 0.0];[-0.15 2.15 0.50]]);
        end
        
        %% Test calculate det jacobian
        function testCalcDetJacobian(obj)
            LocalCoords = [0.3 0.4];
            detJ = obj.MyQuad.calcDetJacobian(LocalCoords);
            assertElementsAlmostEqual(detJ,5.191098149);
        end       
      
       %% Test Map from quad coordinates (r,s) to global coordinates
       function testMapLocalToGlobalCoords(obj)
           GlobalCoordinates1 = obj.MyQuad.mapLocalToGlobal([-1 -1]);
           GlobalCoordinates2 = obj.MyQuad.mapLocalToGlobal([ 1 -1]);
           GlobalCoordinates3 = obj.MyQuad.mapLocalToGlobal([ 1  1]);
           GlobalCoordinates4 = obj.MyQuad.mapLocalToGlobal([-1  1]);
           GlobalCoordinatesCentroid = obj.MyQuad.mapLocalToGlobal([0 0]);
           assertEqual(GlobalCoordinates1,[0 0 0]);
           assertEqual(GlobalCoordinates2,[6 0 0]);
           assertEqual(GlobalCoordinates3,[5 5 1]);
           assertEqual(GlobalCoordinates4,[1 3 1]);
           assertEqual(GlobalCoordinatesCentroid,[3 2 0.5]);
       end

   end
end