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
 
%Test of hexa class

classdef HexaTest < TestCase
    
    properties
        MyHexa
    end
    
    methods
        %% Constructor
        function obj = HexaTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Set up
        function setUp(obj)
            MyVertices(1) = Vertex([0 0 0]);
            MyVertices(2) = Vertex([6 0 0]);
            MyVertices(3) = Vertex([5 5 1]);
            MyVertices(4) = Vertex([1 3 1]);
            MyVertices(5) = Vertex([0 0 5]);
            MyVertices(6) = Vertex([6 0 4]);
            MyVertices(7) = Vertex([5 6 6]);
            MyVertices(8) = Vertex([-1 4 6]);
            
            MyLines( 1) = Line(MyVertices(1),MyVertices(2));
            MyLines( 2) = Line(MyVertices(2),MyVertices(3));
            MyLines( 3) = Line(MyVertices(3),MyVertices(4));
            MyLines( 4) = Line(MyVertices(4),MyVertices(1));
            MyLines( 5) = Line(MyVertices(1),MyVertices(5));
            MyLines( 6) = Line(MyVertices(2),MyVertices(6));
            MyLines( 7) = Line(MyVertices(3),MyVertices(7));
            MyLines( 8) = Line(MyVertices(4),MyVertices(8));
            MyLines( 9) = Line(MyVertices(5),MyVertices(6));
            MyLines(10) = Line(MyVertices(6),MyVertices(7));
            MyLines(11) = Line(MyVertices(7),MyVertices(8));
            MyLines(12) = Line(MyVertices(8),MyVertices(5));
            
            MyQuads(1) = Quad([MyVertices(1) MyVertices(2) MyVertices(3) MyVertices(4)], ...
                              [MyLines(1)    MyLines(2)    MyLines(3)    MyLines(4)]);
            MyQuads(2) = Quad([MyVertices(1) MyVertices(2) MyVertices(5) MyVertices(6)], ...
                              [MyLines(1)    MyLines(6)    MyLines(9)    MyLines(5)]);
            MyQuads(3) = Quad([MyVertices(2) MyVertices(3) MyVertices(7) MyVertices(6)], ...
                              [MyLines(2)    MyLines(7)    MyLines(10)   MyLines(6)]);
            MyQuads(4) = Quad([MyVertices(3) MyVertices(4) MyVertices(8) MyVertices(7)], ...
                              [MyLines(3)    MyLines(8)    MyLines(11)   MyLines(7)]);
            MyQuads(5) = Quad([MyVertices(4) MyVertices(1) MyVertices(5) MyVertices(8)], ...
                              [MyLines(4)    MyLines(5)    MyLines(12)   MyLines(8)]);
            MyQuads(6) = Quad([MyVertices(8) MyVertices(7) MyVertices(6) MyVertices(5)], ...
                              [MyLines(11)   MyLines(10)   MyLines(9)    MyLines(12)]);

            obj.MyHexa = Hexa(MyVertices, MyLines, MyQuads);
        end
        
        %% Test get vertices
        function testGetVertices(obj)
            assertEqual(obj.MyHexa.getVertices, ...
                [Vertex([0 0 0]) Vertex([6 0 0]) Vertex([5 5 1]) Vertex([1 3 1]) ...
                 Vertex([0 0 5]) Vertex([6 0 4]) Vertex([5 6 6]) Vertex([-1 4 6])  ] );
        end
        
        %% Test get verticesCoordinates
        function testGetVerticesCoordinates(obj)
            MyVertices = obj.MyHexa.getVertices();
            MyVerticesCoordinates = obj.MyHexa.getVerticesCoordinates();
            for i = 1:length(MyVertices)
                assertEqual(MyVerticesCoordinates(i,:),MyVertices(i).getCoords());
            end
        end
        
        %% Test get lines
        function testGetLines(obj)
            assertEqual(obj.MyHexa.getLines, ...
                [ ...
                Line(Vertex([0 0 0]),Vertex([6 0 0])) ...
                Line(Vertex([6 0 0]),Vertex([5 5 1])) ...
                Line(Vertex([5 5 1]),Vertex([1 3 1])) ...
                Line(Vertex([1 3 1]),Vertex([0 0 0])) ...
                Line(Vertex([0 0 0]),Vertex([0 0 5])) ...
                Line(Vertex([6 0 0]),Vertex([6 0 4])) ...
                Line(Vertex([5 5 1]),Vertex([5 6 6])) ...
                Line(Vertex([1 3 1]),Vertex([-1 4 6])) ...
                Line(Vertex([0 0 5]),Vertex([6 0 4])) ...
                Line(Vertex([6 0 4]),Vertex([5 6 6])) ...
                Line(Vertex([5 6 6]),Vertex([-1 4 6])) ...
                Line(Vertex([-1 4 6]),Vertex([0 0 5])) ...
                ] );
        end
        
        %% Test getQuads
        function testGetQuad(obj)
            obj.MyHexa.getQuads;
        end
        % too tedious to really test the output; this just tests that the
        % function doesn't bug
       
        %% Test calculate base vector1
        function testCalcBaseVector1(obj)
            LocalCoords = [0.3 0.4 -0.2];
            g1 = obj.MyHexa.calcBaseVector1(LocalCoords);
            assertElementsAlmostEqual(g1,[2.58 0.70 -0.06]);
        end
        
        %% Test calculate base vector2
        function testCalcBaseVector2(obj)
            LocalCoords = [0.3 0.4 -0.2];
            g2 = obj.MyHexa.calcBaseVector2(LocalCoords);
            assertElementsAlmostEqual(g2,[-0.29 2.35 0.63]);
        end
        
        %% Test calculate base vector2
        function testCalcBaseVector3(obj)
            LocalCoords = [0.3 0.4 -0.2];
            g3 = obj.MyHexa.calcBaseVector3(LocalCoords);
            assertElementsAlmostEqual(g3,[-0.245 0.35 2.4025]);
        end
        
        %% Test calculate jacobian
        function testCalcJacobian(obj)
            LocalCoords = [0.3 0.4 -0.2];
            J = obj.MyHexa.calcJacobian(LocalCoords);
            assertElementsAlmostEqual(J, [[2.58 0.70 -0.06];[-0.29 2.35 0.63];[-0.245 0.35 2.4025]]);
        end
        
        %% Test calculate det jacobian
        function testCalcDetJacobian(obj)
            LocalCoords = [0.3 0.4 -0.2];
            detJ = obj.MyHexa.calcDetJacobian(LocalCoords);
            assertElementsAlmostEqual(detJ,14.348675);
        end       
      
       %% Test Map from quad coordinates (r,s,t) to global coordinates
       function testMapLocalToGlobalCoords(obj)
           GlobalCoordinates1 = obj.MyHexa.mapLocalToGlobal([-1 -1 -1]);
           GlobalCoordinates2 = obj.MyHexa.mapLocalToGlobal([ 1 -1 -1]);
           GlobalCoordinates3 = obj.MyHexa.mapLocalToGlobal([ 1  1 -1]);
           GlobalCoordinates4 = obj.MyHexa.mapLocalToGlobal([-1  1 -1]);
           GlobalCoordinates5 = obj.MyHexa.mapLocalToGlobal([-1 -1  1]);
           GlobalCoordinates6 = obj.MyHexa.mapLocalToGlobal([ 1 -1  1]);
           GlobalCoordinates7 = obj.MyHexa.mapLocalToGlobal([ 1  1  1]);
           GlobalCoordinates8 = obj.MyHexa.mapLocalToGlobal([-1  1  1]);           
           GlobalCoordinatesCenter = obj.MyHexa.mapLocalToGlobal([0 0 0]);
           assertEqual(GlobalCoordinates1,[0 0 0]);
           assertEqual(GlobalCoordinates2,[6 0 0]);
           assertEqual(GlobalCoordinates3,[5 5 1]);
           assertEqual(GlobalCoordinates4,[1 3 1]);
           assertEqual(GlobalCoordinates5,[0 0 5]);
           assertEqual(GlobalCoordinates6,[6 0 4]);
           assertEqual(GlobalCoordinates7,[5 6 6]);
           assertEqual(GlobalCoordinates8,[-1 4 6]);
           assertEqual(GlobalCoordinatesCenter,[2.75 2.25 2.875]);
       end

   end
end