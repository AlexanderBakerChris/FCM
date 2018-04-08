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
 
% Test of volume class
classdef SolidTest < TestCase
    
    properties
        solid
        PolynomialDegree
        DofDimension
    end
    
    methods
        %% Constructor
        function obj = SolidTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Set up
        function setUp(obj)
            obj.DofDimension = 3;
            obj.PolynomialDegree = 4;
            
            nodes(1) = Node([0 0 0],obj.DofDimension);
            nodes(2) = Node([6 0 0],obj.DofDimension);
            nodes(3) = Node([6 8 0],obj.DofDimension);
            nodes(4) = Node([0 8 0],obj.DofDimension);
            nodes(5) = Node([0 0 5],obj.DofDimension);
            nodes(6) = Node([6 0 5],obj.DofDimension);
            nodes(7) = Node([6 8 5],obj.DofDimension);
            nodes(8) = Node([0 8 5],obj.DofDimension);
            
            edges( 1) = Edge([nodes(1) nodes(2)],obj.PolynomialDegree,obj.DofDimension);
            edges( 2) = Edge([nodes(2) nodes(3)],obj.PolynomialDegree,obj.DofDimension);
            edges( 3) = Edge([nodes(3) nodes(4)],obj.PolynomialDegree,obj.DofDimension);
            edges( 4) = Edge([nodes(4) nodes(1)],obj.PolynomialDegree,obj.DofDimension);
            edges( 5) = Edge([nodes(1) nodes(5)],obj.PolynomialDegree,obj.DofDimension);
            edges( 6) = Edge([nodes(2) nodes(6)],obj.PolynomialDegree,obj.DofDimension);
            edges( 7) = Edge([nodes(3) nodes(7)],obj.PolynomialDegree,obj.DofDimension);
            edges( 8) = Edge([nodes(4) nodes(8)],obj.PolynomialDegree,obj.DofDimension);
            edges( 9) = Edge([nodes(5) nodes(6)],obj.PolynomialDegree,obj.DofDimension);
            edges(10) = Edge([nodes(6) nodes(7)],obj.PolynomialDegree,obj.DofDimension);
            edges(11) = Edge([nodes(7) nodes(8)],obj.PolynomialDegree,obj.DofDimension);
            edges(12) = Edge([nodes(8) nodes(5)],obj.PolynomialDegree,obj.DofDimension);
            
            faces(1) = Face([nodes(1) nodes(2) nodes(3) nodes(4)],...
                              [edges(1) edges(2) edges(3) edges(4)],obj.PolynomialDegree,obj.DofDimension);
            faces(2) = Face([nodes(1) nodes(2) nodes(6) nodes(5)],...
                              [edges(1) edges(6) edges(9) edges(5)],obj.PolynomialDegree,obj.DofDimension);
            faces(3) = Face([nodes(2) nodes(3) nodes(7) nodes(6)],...
                              [edges(2) edges(7) edges(10) edges(6)],obj.PolynomialDegree,obj.DofDimension);
            faces(4) = Face([nodes(3) nodes(4) nodes(8) nodes(7)], ...
                              [edges(3) edges(8) edges(11) edges(7)],obj.PolynomialDegree,obj.DofDimension);
            faces(5) = Face([nodes(4) nodes(1) nodes(5) nodes(8)],...
                              [edges(4) edges(5) edges(12) edges(8)],obj.PolynomialDegree,obj.DofDimension);
            faces(6) = Face([nodes(8) nodes(7) nodes(6) nodes(5)],...
                              [edges(11) edges(10) edges(9)  edges(12)],obj.PolynomialDegree,obj.DofDimension);

            obj.solid = Solid(nodes,edges,faces,...
                obj.PolynomialDegree,obj.DofDimension);
        end
        
        %% Tear Down
        function tearDown(obj)
        end
        
        %% Get Nodes
        function getNodesTest(obj)
            assertEqual(obj.solid.getNodes, ...
                [Node([0 0 0],obj.DofDimension) Node([6 0 0],obj.DofDimension) ...
                 Node([6 8 0],obj.DofDimension) Node([0 8 0],obj.DofDimension) ...
                 Node([0 0 5],obj.DofDimension) Node([6 0 5],obj.DofDimension) ...
                 Node([6 8 5],obj.DofDimension) Node([0 8 5],obj.DofDimension) ]);
        end
        
        %% Get Edges
        function getEdgesTest(obj)
            assertEqual(obj.solid.getEdges, ...
                [ Edge([Node([0 0 0],obj.DofDimension) Node([6 0 0],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([6 0 0],obj.DofDimension) Node([6 8 0],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([6 8 0],obj.DofDimension) Node([0 8 0],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([0 8 0],obj.DofDimension) Node([0 0 0],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([0 0 0],obj.DofDimension) Node([0 0 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ... 
                  Edge([Node([6 0 0],obj.DofDimension) Node([6 0 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([6 8 0],obj.DofDimension) Node([6 8 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([0 8 0],obj.DofDimension) Node([0 8 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([0 0 5],obj.DofDimension) Node([6 0 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([6 0 5],obj.DofDimension) Node([6 8 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([6 8 5],obj.DofDimension) Node([0 8 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ...
                  Edge([Node([0 8 5],obj.DofDimension) Node([0 0 5],obj.DofDimension)],obj.PolynomialDegree,obj.DofDimension) ]);
        end
        
        %% Get Faces
        function testGetFaces(obj)
            obj.solid.getFaces;
        end
        % too tedious to really test the output; this just tests that the
        % function doesn't bug
        
        %% Get Dof Dimension
        function getDofTest(obj)
            for i=1:obj.DofDimension*(obj.PolynomialDegree-1)^3
                SolidDofTrue(i) = Dof(0);
            end
            assertEqual(obj.solid.getDof,SolidDofTrue);
            
        end
        
    end
    
end

