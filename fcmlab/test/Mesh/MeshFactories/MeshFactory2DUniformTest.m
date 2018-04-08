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
 
%% testing of class MeshFactory2DUniform

classdef MeshFactory2DUniformTest < TestCase
    
    properties
        NumberOfXDivisions
        NumberOfYDivisions
        PolynomialDegree
        NumberingScheme
        DofDimension
        NumberGP
        Mat2D
        MeshOrigin
        Lx
        Ly
        
        Nodes
        Edges
        Faces
        NumberOfDofs
        Elements
        MeshFactory
    end
    
    methods
        %% constructor
        function obj = MeshFactory2DUniformTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.NumberOfXDivisions = 3;
            obj.NumberOfYDivisions = 4;
            obj.PolynomialDegree = 3;
            obj.NumberingScheme = PolynomialDegreeSorting();
            obj.DofDimension = 2;
            obj.NumberGP = obj.PolynomialDegree+1;
            obj.Mat2D = HookePlaneStrain(1,0.5,7,1);
            obj.MeshOrigin = [0 0];
            obj.Lx = 6;
            obj.Ly = 8;
            
            % Creating ElementFactory 2D
            ElementFactory2D = ElementFactoryElasticQuad(obj.Mat2D,obj.NumberGP);
            % Creating MeshFactory 2D
            obj.MeshFactory = MeshFactory2DUniform(obj.NumberOfXDivisions,...
                obj.NumberOfYDivisions,obj.PolynomialDegree,obj.NumberingScheme,...
                obj.DofDimension,obj.MeshOrigin,obj.Lx,obj.Ly,ElementFactory2D);

            obj.Nodes = obj.MeshFactory.createNodes();
            obj.Edges = obj.MeshFactory.createEdges(obj.Nodes);
            obj.Faces = obj.MeshFactory.createFaces(obj.Nodes,obj.Edges);
            obj.NumberOfDofs = obj.MeshFactory.assignDofs(obj.Nodes,obj.Edges,obj.Faces,[]);
            obj.Elements = obj.MeshFactory.createElements(obj.Nodes,obj.Edges,obj.Faces);
        end
        
        function tearDown(obj)
        end
        
        %% test createNodes
        function testCreateNodes(obj)
            assertEqual(length(obj.Nodes),...
                (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1));
            xIncrement = obj.Lx/obj.NumberOfXDivisions;
            yIncrement = obj.Ly/obj.NumberOfYDivisions;
            id = 1;
            for i = 1:(obj.NumberOfYDivisions+1)
                for j = 1:(obj.NumberOfXDivisions+1)
                    assertElementsAlmostEqual(obj.Nodes(id).getX,(j-1)*xIncrement);
                    assertElementsAlmostEqual(obj.Nodes(id).getY,(i-1)*yIncrement);
                    id = id + 1;
                end
            end
        end
        
        %% test createEdges
        function testCreateEdges(obj)
            NumberOfHorizontalEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
            NumberOfVerticalEdges = obj.NumberOfYDivisions*(obj.NumberOfXDivisions+1);
            assertEqual(length(obj.Edges),...
                NumberOfHorizontalEdges + NumberOfVerticalEdges);
             
            %check horizontal edges
            for i = 1:obj.NumberOfYDivisions+1
                for j = 1:obj.NumberOfXDivisions
                    id = (i-1)*obj.NumberOfXDivisions + j;
                    nodeHandle = obj.Edges(id).getNodes;
                    assertEqual(nodeHandle,obj.Nodes(id+i-1:id+i));
                end
            end
            
            %check vertical edges
            for i=1:obj.NumberOfXDivisions+1
                for j=1:obj.NumberOfYDivisions
                    id = NumberOfHorizontalEdges+(i-1)*obj.NumberOfYDivisions + j;
                    nodeHandle = obj.Edges(id).getNodes;
                    nodeId = i + (j-1)*(obj.NumberOfXDivisions+1);
                    assertEqual(nodeHandle,[obj.Nodes(nodeId) obj.Nodes(nodeId+obj.NumberOfXDivisions+1)]);
                end
            end
        end
        
        %% test createFaces
        function testCreateFaces(obj)
            assertEqual(length(obj.Faces),obj.NumberOfXDivisions*obj.NumberOfYDivisions);
            NumberOfHorizontalEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);          
            for i=1:obj.NumberOfYDivisions
                for j=1:obj.NumberOfXDivisions
                    Node1Id = (i-1)*(obj.NumberOfXDivisions+1)+j;
                    Node2Id = (i-1)*(obj.NumberOfXDivisions+1)+j+1;
                    Node4Id = (i)*(obj.NumberOfXDivisions+1)+j;
                    Node3Id = (i)*(obj.NumberOfXDivisions+1)+j+1;
                    Edge1Id = (i-1)*obj.NumberOfXDivisions+j;
                    Edge3Id = (i)*obj.NumberOfXDivisions+j;
                    Edge4Id = (j-1)*obj.NumberOfYDivisions+i+NumberOfHorizontalEdges;
                    Edge2Id = (j)*obj.NumberOfYDivisions+i+NumberOfHorizontalEdges;
                    FaceId = (i-1)*obj.NumberOfXDivisions+j;

                    assertEqual(obj.Faces(FaceId).getNodes,[obj.Nodes(Node1Id) obj.Nodes(Node2Id) obj.Nodes(Node3Id) obj.Nodes(Node4Id)]);
                    assertEqual(obj.Faces(FaceId).getEdges,[obj.Edges(Edge1Id) obj.Edges(Edge2Id) obj.Edges(Edge3Id) obj.Edges(Edge4Id)]);
                end
            end
        end
        
        %% test assignDofs
        function testAssignDofs(obj)
            TrueNumberOfDofs = obj.DofDimension*(length(obj.Nodes)+...
                length(obj.Edges)*(obj.PolynomialDegree-1)+...
                length(obj.Faces)*(obj.PolynomialDegree-1)^2);
            assertEqual(obj.NumberOfDofs,TrueNumberOfDofs);
        end
        
        %% test createElements
        function testCreateElements(obj)
            % Check size of elements
            assertEqual(length(obj.Elements),obj.NumberOfXDivisions*obj.NumberOfYDivisions);
            % Check if the nodes, edges and faces are stored correctly into
            % the elements
            NumberOfHorizontalEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
            for i=1:obj.NumberOfYDivisions
                for j=1:obj.NumberOfXDivisions
                    ElementId = (i-1)*obj.NumberOfXDivisions+j;
                    % Checking Nodes
                    Node1Id = (i-1)*(obj.NumberOfXDivisions+1)+j;
                    Node2Id = (i-1)*(obj.NumberOfXDivisions+1)+j+1;
                    Node4Id = (i)*(obj.NumberOfXDivisions+1)+j;
                    Node3Id = (i)*(obj.NumberOfXDivisions+1)+j+1;
                    nodesHandle = obj.Elements(ElementId).getNodes;
                    assertEqual(length(nodesHandle),4);
                    assertEqual(nodesHandle,[obj.Nodes(Node1Id) obj.Nodes(Node2Id) obj.Nodes(Node3Id) obj.Nodes(Node4Id)]);
                    % Checking Edges
                    Edge1Id = (i-1)*obj.NumberOfXDivisions+j;
                    Edge3Id = (i)*obj.NumberOfXDivisions+j;
                    Edge4Id = (j-1)*obj.NumberOfYDivisions+i+NumberOfHorizontalEdges;
                    Edge2Id = (j)*obj.NumberOfYDivisions+i+NumberOfHorizontalEdges;
                    edgesHandle = obj.Elements(ElementId).getEdges;
                    assertEqual(length(edgesHandle),4);
                    assertEqual(edgesHandle,[obj.Edges(Edge1Id) obj.Edges(Edge2Id) obj.Edges(Edge3Id) obj.Edges(Edge4Id)]);
                    % Checking Faces
                    FaceId = (i-1)*obj.NumberOfXDivisions+j;
                    faceHandle = obj.Elements(ElementId).getFaces;
                    assertEqual(length(faceHandle),1);
                    assertEqual(faceHandle,obj.Faces(FaceId));
                end
            end            
        end
    end 
end

