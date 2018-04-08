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
 
% testing of class Node

classdef NodeTest < TestCase
    
    properties
        Node1D
        Node2D
        Node3D
    end
    
    methods
        
        %% constructor
        function obj = NodeTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.Node1D = Node([2 0 0],1);
            obj.Node2D = Node([2 3 0],2);
            obj.Node3D = Node([2,3,4],3);
        end
        
        function tearDown(obj)
        end
        
        
        %% test coordinates of a node in 1D
        function test1DCoords(obj)
            assertEqual(obj.Node1D.getX(),2);
            assertEqual(obj.Node1D.getY(),0);
            assertEqual(obj.Node1D.getZ(),0);
        end
        
        %% test coordinates of a node in 2D
        function test2DCoords(obj)
            assertEqual(obj.Node2D.getX(),2);
            assertEqual(obj.Node2D.getY(),3);
            assertEqual(obj.Node2D.getZ(),0);
        end
        
        %% test coordinates of a node in 3D
        function test3DCoords(obj)
            assertEqual(obj.Node3D.getX(),2);
            assertEqual(obj.Node3D.getY(),3);
            assertEqual(obj.Node3D.getZ(),4);
        end
        
        %% test the Dofs of a node
        function testDof(obj)
            assertEqual(obj.Node1D.getDof(),Dof(0));
            assertEqual(obj.Node2D.getDof(),[Dof(0) Dof(0)]);
            assertEqual(obj.Node3D.getDof(),[Dof(0) Dof(0) Dof(0)]);
        end
               
    end
    
end

