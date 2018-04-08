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
 
%% testing of class MeshFactory1DUniform

classdef MeshFactory1DUniformTest < TestCase
    
    properties
        NumberOfXDivisions
        PolynomialDegree
        NumberingScheme
        DofDimension
        NumberGP
        Mat1D
        A 
        MeshOrigin
        L
        fHandle
        
        Nodes
        Edges
        NumberOfDofs
        Elements
        MeshFactory1
        
        
    end
    
    methods
        %% constructor
        function obj = MeshFactory1DUniformTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.NumberOfXDivisions = 10;
            obj.PolynomialDegree = 3;
            obj.DofDimension = 1;
            obj.NumberingScheme = PolynomialDegreeSorting();
            obj.NumberGP = obj.PolynomialDegree+1;
            obj.A = 1;
            obj.Mat1D = Hooke1D(obj.A,1,0,1);
            obj.MeshOrigin = 0;
            obj.L = 1;
            
            % Creating ElementFactory 1D
            ElementFactory1D = ElementFactoryElasticBar(obj.Mat1D,obj.NumberGP);
            % Creating MeshFactory 1D
            obj.MeshFactory1 = MeshFactory1DUniform(obj.NumberOfXDivisions,...
    obj.PolynomialDegree,obj.NumberingScheme,obj.DofDimension,obj.MeshOrigin,obj.L,ElementFactory1D);

            obj.Nodes = obj.MeshFactory1.createNodes;
            obj.Edges = obj.MeshFactory1.createEdges(obj.Nodes);
            obj.NumberOfDofs = obj.MeshFactory1.assignDofs(obj.Nodes,obj.Edges,[],[]);
            obj.Elements = obj.MeshFactory1.createElements(obj.Nodes,obj.Edges);
        end
        
        function tearDown(obj)
        end
        
        %% test createNodes
        function testCreateNodes(obj)
            assertEqual(length(obj.Nodes),obj.NumberOfXDivisions+1);
            for i = 1:length(obj.Nodes)
                assertElementsAlmostEqual(obj.Nodes(i).getX,(i-1)*obj.L/obj.NumberOfXDivisions,'absolute')
            end
        end
        
        %% test createEdges
        function testCreateEdges(obj)
            assertEqual(length(obj.Edges),obj.NumberOfXDivisions);
            for i = 1:length(obj.Edges)
                nodeHandle = obj.Edges(i).getNodes;
                assertEqual(length(nodeHandle),2)
                assertEqual(obj.Edges(i).getNodes,obj.Nodes(i:i+1))
            end
        end
        
        %% test assignDofs
        function testAssignDofs(obj)
            assertEqual(obj.NumberOfDofs...
                ,(obj.NumberOfXDivisions*obj.PolynomialDegree+1))
        end
        
        %% test createElements
        function testCreateElements(obj)
            assertEqual(length(obj.Elements),obj.NumberOfXDivisions)
            for i = 1:length(obj.Elements)
                nodesHandle = obj.Elements(i).getNodes;
                assertEqual(length(nodesHandle),2)
                assertEqual(nodesHandle,obj.Nodes(i:i+1))
                edgeHandle = obj.Elements(i).getEdges;
                assertEqual(length(edgeHandle),1)
                assertEqual(edgeHandle,obj.Edges(i))
            end
        end
    end
    
end

