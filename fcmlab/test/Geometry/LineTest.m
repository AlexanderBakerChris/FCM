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
 
%Test of line class

classdef LineTest < TestCase
    
    properties
        MyLine
    end
    
    methods
         %% Constructor
        function obj = LineTest(name)
            obj = obj@TestCase(name);
        end
        
       %% Set up
       function setUp(obj)
           Vertex1 = Vertex([1 2 3]);
           Vertex2 = Vertex([6 5 4]);
           obj.MyLine = Line(Vertex1,Vertex2);
       end
       
       %% Tear Down
       function tearDown(obj)
       end
       
       %% Test get vertices
       function testGetVertices(obj)
           assertEqual(obj.MyLine.getVertices, [Vertex([1 2 3]) Vertex([6 5 4])]);
       end
       
       %% Test calc centroid
       function testCalcCentroid(obj)
           assertElementsAlmostEqual(obj.MyLine.calcCentroid, [3.5 3.5 3.5]);
       end
       
       %% Test Calculate Jacobian
       function testCalcJacobian(obj)
           anyLocalCoord = 0.3;
           assertEqual(obj.MyLine.calcJacobian(anyLocalCoord), [5/2 3/2 1/2]);
       end
       
       %% Test Calculate det Jacobian
       function testCalcDetJacobian(obj)
           anyLocalCoord = 0.4;
           assertElementsAlmostEqual(obj.MyLine.calcDetJacobian(anyLocalCoord),0.5*sqrt(35));
       end
       
       %% Test Normal vector
       function testNormalVector(obj)
           NormalVector = obj.MyLine.calcNormalVector();
           assertElementsAlmostEqual(NormalVector,[3 -5]/sqrt(34));
       end
       
       %% Test Map from local coordinates to global coordinates
       function testMapLocalToGlobalCoords(obj)
           GlobalCoordinates1 = obj.MyLine.mapLocalToGlobal(-1);
           GlobalCoordinates2 = obj.MyLine.mapLocalToGlobal(0);
           GlobalCoordinates3 = obj.MyLine.mapLocalToGlobal(1);
           assertEqual(GlobalCoordinates1,[1 2 3]);
           assertEqual(GlobalCoordinates2,[3.5 3.5 3.5]);
           assertEqual(GlobalCoordinates3,[6 5 4]);
       end
       
       %% Test Map from global coordinates to local coordinates
       function testMapGlobalToLocalCoords(obj)
           % centroid
           Centroid = obj.MyLine.calcCentroid();
           LocalCoordCentroid = obj.MyLine.mapGlobalToLocal(Centroid);
           assertElementsAlmostEqual(LocalCoordCentroid,0);
           % vertex 1
           Vertices = obj.MyLine.getVertices;
           LocalCoordVertex1 = obj.MyLine.mapGlobalToLocal(Vertices(1).getCoords());
           assertElementsAlmostEqual(LocalCoordVertex1,-1);
           % vertex 2
           LocalCoordVertex2 = obj.MyLine.mapGlobalToLocal(Vertices(2).getCoords());
           assertElementsAlmostEqual(LocalCoordVertex2,1);
       end
   end
end