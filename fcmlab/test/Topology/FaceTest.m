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
 
% Test of face class
classdef FaceTest < TestCase
    
    properties
        MyFace
        Node1
        Node2
        Node3
        Node4
        Edge1
        Edge2
        Edge3
        Edge4
    end
    
    methods
        %% Constructor
        function obj = FaceTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Set up
        function setUp(obj)
            DofDimension = 2;
            PolynomialDegree = 4;
            obj.Node1 = Node([0 0 0],2);
            obj.Node2 = Node([1.5 0 0],2);
            obj.Node3 = Node([1.5 1.5 0],2);
            obj.Node4 = Node([0 1.5 0],2);
            obj.Edge1 = Edge([obj.Node1 obj.Node2],PolynomialDegree,DofDimension);
            obj.Edge2 = Edge([obj.Node2 obj.Node3],PolynomialDegree,DofDimension);
            obj.Edge3 = Edge([obj.Node3 obj.Node4],PolynomialDegree,DofDimension);
            obj.Edge4 = Edge([obj.Node4 obj.Node1],PolynomialDegree,DofDimension);
            obj.MyFace = Face([obj.Node1 obj.Node2 obj.Node3 obj.Node4],...
                [obj.Edge1 obj.Edge2 obj.Edge3 obj.Edge4],PolynomialDegree,...
                DofDimension);
        end
        
        %% Tear Down
        function tearDown(obj)
        end
        
        %% Get Nodes
        function getNodesTest(obj)
            assertEqual(obj.MyFace.getNodes,...
                [obj.Node1 obj.Node2 obj.Node3 obj.Node4],'absolute');
        end
        
        %% Get Edges
        function getEdgesTest(obj)
            assertEqual(obj.MyFace.getEdges,[obj.Edge1 obj.Edge2 obj.Edge3 obj.Edge4]); 
        end
        
        %% Get Dof Dimenstion
        function getDofTest(obj)
            for i=1:18 % DofDimension*(PolynomialDegree-1)^2 = 18
                FaceDofTrue(i) = Dof(0);
            end
            assertEqual(obj.MyFace.getDof,FaceDofTrue);
        end
        
%         %% Get Load Function
%         function getLoadFunctionTest(obj)
%             f = obj.MyFace.getLoadFunction;
%             assertEqual(f(0),0);
%         end
%         
%         %% Set Load Function
%         function setLoadFunctionTest(obj)
%             obj.MyFace.setLoadFunction(@(x)(x^2),[0.5 1]);
%             f = obj.MyFace.getLoadFunction;
%             assertEqual(f(3),9);
%         end
    end
    
end

