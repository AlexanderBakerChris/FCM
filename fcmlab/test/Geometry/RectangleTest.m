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
 
%Test of rectangle class

classdef RectangleTest < TestCase
    
    properties
        MyRectangle
    end
    
    methods
        %% Constructor
        function obj = RectangleTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Set up
        function setUp(obj)
            Vertex1 = Vertex([0 0 0]);
            Vertex2 = Vertex([6 0 0]);
            Vertex3 = Vertex([6 8 0]);
            Vertex4 = Vertex([0 8 0]);
            Line1 = Line(Vertex1,Vertex2);
            Line2 = Line(Vertex2,Vertex3);
            Line3 = Line(Vertex3,Vertex4);
            Line4 = Line(Vertex4,Vertex1);
            MyVertices = [Vertex1 Vertex2 Vertex3 Vertex4];
            MyLines = [Line1 Line2 Line3 Line4];
            obj.MyRectangle = Rectangle(MyVertices, MyLines);
        end
        
        %% Test get vertices
        function testGetVertices(obj)
            assertEqual(obj.MyRectangle.getVertices, ...
                [Vertex([0 0 0]) Vertex([6 0 0]) Vertex([6 8 0]) Vertex([0 8 0])] );
        end
        %% Test get verticesCoordinates
        function testGetVerticesCoordinates(obj)
            MyVertices = obj.MyRectangle.getVertices();
            MyVerticesCoordinates = obj.MyRectangle.getVerticesCoordinates();
            for i = 1:length(MyVertices)
                assertEqual(MyVerticesCoordinates(i,:),MyVertices(i).getCoords());
            end
        end
        
        %% Test get lines
        function testGetLines(obj)
            assertEqual(obj.MyRectangle.getLines, ...
                [ ...
                Line(Vertex([0 0 0]),Vertex([6 0 0])) ...
                Line(Vertex([6 0 0]),Vertex([6 8 0])) ...
                Line(Vertex([6 8 0]),Vertex([0 8 0])) ...
                Line(Vertex([0 8 0]),Vertex([0 0 0])) ...
                ] );
        end
        
        %% Test calc centroid
        function testCalcCentroid(obj)
            assertElementsAlmostEqual(obj.MyRectangle.calcCentroid, [3 4 0]);
        end
        
        %% Test calculate jacobian
        function testCalcJacobian(obj)
            AnyLocalCoords = [0.3 0.4];
            J = obj.MyRectangle.calcJacobian(AnyLocalCoords);
            assertElementsAlmostEqual(J, [3 0 0; 0 4 0]);
        end
        
        %% Test calculate det jacobian
        function testCalcDetJacobian(obj)
            LocalCoords = [0.3 0.4];
            detJ = obj.MyRectangle.calcDetJacobian(LocalCoords);
            assertElementsAlmostEqual(detJ,12);
        end       
      
       %% Test Map from quad coordinates (r,s) to global coordinates
       function testMapLocalToGlobalCoords(obj)
           GlobalCoordinates1 = obj.MyRectangle.mapLocalToGlobal([-1 -1]);
           GlobalCoordinates2 = obj.MyRectangle.mapLocalToGlobal([ 1 -1]);
           GlobalCoordinates3 = obj.MyRectangle.mapLocalToGlobal([ 1  1]);
           GlobalCoordinates4 = obj.MyRectangle.mapLocalToGlobal([-1  1]);
           GlobalCoordinatesCentroid = obj.MyRectangle.mapLocalToGlobal([0 0]);
           assertEqual(GlobalCoordinates1,[0 0 0]);
           assertEqual(GlobalCoordinates2,[6 0 0]);
           assertEqual(GlobalCoordinates3,[6 8 0]);
           assertEqual(GlobalCoordinates4,[0 8 0]);
           assertEqual(GlobalCoordinatesCentroid,[3 4 0]);
       end

   end
end