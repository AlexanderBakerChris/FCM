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
 
%Test for point class

classdef VertexTest < TestCase
    
    properties
        MyVertex
    end
    
    methods
        
        %% constructor
        function obj = VertexTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.MyVertex = Vertex([4.5 3.2 5.7]);
        end
        
        function tearDown(obj)
        end
        
        
        %% test getX of a point
        function testGetX(obj)
            assertEqual(obj.MyVertex.getX(),4.5);
        end
        
        %% test getY of a point
        function testGetY(obj)
            assertEqual(obj.MyVertex.getY(),3.2);
        end
        
        %% test getZ of a point
        function testGetZ(obj)
            assertEqual(obj.MyVertex.getZ(),5.7);
        end
        
        %% test getCoordinates of a point
        function testGetCoords(obj)
            assertEqual(obj.MyVertex.getCoords(),[4.5 3.2 5.7]);
        end
        
        %% test getVertices
        function testGetVertices(obj)
            assertEqual(obj.MyVertex.getVertices(),obj.MyVertex);
        end
        
        %% test calcJacobian
        function testCalcJacobian(obj)
            assertEqual(obj.MyVertex.calcJacobian(),1);
        end
        
		%% test calcDetJacobian
        function testCalcDetJacobian(obj)
            assertEqual(obj.MyVertex.calcDetJacobian(),1);
        end
        
		%% test mapLocalToGlobal
        function testMapLocalToGlobalCoords(obj)       
            assertEqual(obj.MyVertex.mapLocalToGlobal(),[4.5 3.2 5.7]);
        end
        
		%% test mapGlobalToLocal
        function testMapGlobalToLocalCoords(obj)
            assertEqual(obj.MyVertex.mapGlobalToLocal(),0);
        end
               
    end
    
end

