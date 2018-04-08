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
 
%% testing of class MeshFactory3DUniform

classdef MeshFactory3DUniformTest < TestCase
    
    properties
        NumberOfXDivisions
        NumberOfYDivisions
        NumberOfZDivisions
        PolynomialDegree
        NumberingScheme
        DofDimension
        NumberGP
        Mat3D
        MeshOrigin
        Lx
        Ly
        Lz
        
        Nodes
        Edges
        Faces
        solids
        NumberOfDofs
        Elements
        MeshFactory
    end
    
    methods
        %% constructor
        function obj = MeshFactory3DUniformTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.NumberOfXDivisions = 2;
            obj.NumberOfYDivisions = 3;
            obj.NumberOfZDivisions = 4;
            obj.PolynomialDegree = 2;
            obj.NumberingScheme = PolynomialDegreeSorting();
            obj.DofDimension = 3;
            obj.NumberGP = obj.PolynomialDegree+1;
            obj.Mat3D = Hooke3D(1,0.3,3,1);
            obj.MeshOrigin = [0 0 0];
            obj.Lx = 2;
            obj.Ly = 3;
            obj.Lz = 4;
            
            % Creating ElementFactory 3D
            ElementFactory3D = ElementFactoryElasticHexa(obj.Mat3D,obj.NumberGP);
            % Creating Mesh
            obj.MeshFactory = MeshFactory3DUniform(obj.NumberOfXDivisions,...
                obj.NumberOfYDivisions,obj.NumberOfZDivisions,obj.PolynomialDegree,obj.NumberingScheme,...
                obj.DofDimension,obj.MeshOrigin,obj.Lx,obj.Ly,obj.Lz,ElementFactory3D);

            obj.Nodes = obj.MeshFactory.createNodes();
            obj.Edges = obj.MeshFactory.createEdges(obj.Nodes);
            obj.Faces = obj.MeshFactory.createFaces(obj.Nodes,obj.Edges);
            obj.solids = obj.MeshFactory.createSolids(obj.Nodes,obj.Edges,obj.Faces);
            obj.NumberOfDofs = obj.MeshFactory.assignDofs(obj.Nodes,obj.Edges,obj.Faces,obj.solids);
            obj.Elements = obj.MeshFactory.createElements(obj.Nodes,obj.Edges,obj.Faces,obj.solids);
        end
        
        function tearDown(obj)
        end
        
        %% test createNodes
        function testCreateNodes(obj)
            assertEqual(length(obj.Nodes),...
                (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1)*(obj.NumberOfZDivisions+1));
            xIncrement = obj.Lx/obj.NumberOfXDivisions;
            yIncrement = obj.Ly/obj.NumberOfYDivisions;
            zIncrement = obj.Lz/obj.NumberOfZDivisions;
            id = 1;
            for i = 1:(obj.NumberOfZDivisions+1)
                for j = 1:(obj.NumberOfYDivisions+1)
                    for k = 1:(obj.NumberOfXDivisions+1)
                        assertElementsAlmostEqual(obj.Nodes(id).getX,(k-1)*xIncrement);
                        assertElementsAlmostEqual(obj.Nodes(id).getY,(j-1)*yIncrement);
                        assertElementsAlmostEqual(obj.Nodes(id).getZ,(i-1)*zIncrement);
                        id = id + 1;
                    end
                end
            end
        end
        
        %% test createEdges
        function testCreateEdges(obj)
            NumberOfXEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1)*(obj.NumberOfZDivisions+1);
            NumberOfYEdges = obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1)*(obj.NumberOfXDivisions+1);
            NumberOfZEdges = obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
            
            assertEqual(length(obj.Edges),...
                NumberOfXEdges + NumberOfYEdges + NumberOfZEdges);
            %check x-edges
            for i = 1:obj.NumberOfZDivisions+1
                for j = 1:obj.NumberOfYDivisions+1
                    for k = 1:obj.NumberOfXDivisions
                        id = k+ (j-1)*obj.NumberOfXDivisions + (i-1)*((obj.NumberOfXDivisions)*(obj.NumberOfYDivisions+1));
                        nodeHandle = obj.Edges(id).getNodes;
                        Node1Id = k + (j-1)*(obj.NumberOfXDivisions+1)+(i-1)*((obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1));
                        Node2Id = Node1Id + 1;
                        assertEqual(nodeHandle,obj.Nodes(Node1Id:Node2Id));
                    end
                end
            end
            %check y-edges
            NumberOfXEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1)*(obj.NumberOfZDivisions+1);
            for k = 1:obj.NumberOfXDivisions+1
                for i = 1:obj.NumberOfZDivisions+1
                    for j = 1:obj.NumberOfYDivisions
                        id = NumberOfXEdges + j + (i-1)*obj.NumberOfYDivisions + (k-1)*((obj.NumberOfYDivisions)*(obj.NumberOfZDivisions+1));
                        nodeHandle = obj.Edges(id).getNodes;
                        Node1Id = k+(j-1)*(obj.NumberOfXDivisions+1)+(i-1)*((obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1));
                        Node2Id = Node1Id + obj.NumberOfXDivisions+1;
                        assertEqual(nodeHandle,obj.Nodes([Node1Id Node2Id]));
                    end
                end
            end
            %check z-edges
            NumberOfYEdges = obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1)*(obj.NumberOfXDivisions+1);
            for j = 1:obj.NumberOfYDivisions+1
                for k = 1:obj.NumberOfXDivisions+1
                    for i = 1:obj.NumberOfZDivisions
                        id = NumberOfXEdges+NumberOfYEdges + i + (k-1)*obj.NumberOfZDivisions + (j-1)*((obj.NumberOfZDivisions)*(obj.NumberOfXDivisions+1));
                        nodeHandle = obj.Edges(id).getNodes;
                        Node1Id = k+(j-1)*(obj.NumberOfXDivisions+1)+(i-1)*((obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1));
                        Node2Id = Node1Id + (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
                        assertEqual(nodeHandle,obj.Nodes([Node1Id Node2Id]));
                    end
                end
            end
        end
         
        %% test createFaces
        function testCreateFaces(obj)
            NumberOfXYFaces = obj.NumberOfXDivisions*obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
            NumberOfYZFaces = obj.NumberOfYDivisions*obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);
            NumberOfZXFaces = obj.NumberOfZDivisions*obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
            assertEqual(length(obj.Faces),NumberOfXYFaces+NumberOfYZFaces+NumberOfZXFaces);
            
            Face1 = obj.Faces(1);
            assertEqual(Face1.getNodes,obj.Nodes([1 2 5 4]));
            assertEqual(Face1.getEdges,obj.Edges([1 56 3 41]));
            
            Face2 = obj.Faces(31);
            assertEqual(Face2.getNodes,obj.Nodes([1 4 16 13]));
            assertEqual(Face2.getEdges,obj.Edges([41 98 44 86]));
            
            Face3 = obj.Faces(67);
            assertEqual(Face3.getNodes,obj.Nodes([1 13 14 2]));
            assertEqual(Face3.getEdges,obj.Edges([86 9 90 1]));
   
        end
        %% testCreateSolids
        function testCreateSolids(obj)
            NumberOfSolids = obj.NumberOfXDivisions*obj.NumberOfYDivisions*obj.NumberOfZDivisions;
            assertEqual(NumberOfSolids,length(obj.solids));
            
            %test first volume
            Nodes1 = [1 2 5 4 13 14 17 16];
            Edges1 = [1 56 3 41 86 90 102 98 9 59 11 44];
            Faces1 = [1 67 43 75 31 7];
            assertEqual(obj.Nodes(Nodes1),obj.solids(1).getNodes);
            assertEqual(obj.Edges(Edges1),obj.solids(1).getEdges);
            assertEqual(obj.Faces(Faces1),obj.solids(1).getFaces);
            
            %test last volume
            NodesEnd = [44 45 48 47 56 57 60 59];
            EdgesEnd = [30 82 32 67 117 121 133 129 38 85 40 70];
            FacesEnd = [24 90 66 98 54 30];
            assertEqual(obj.Nodes(NodesEnd),obj.solids(end).getNodes);
            assertEqual(obj.Edges(EdgesEnd),obj.solids(end).getEdges);
            assertEqual(obj.Faces(FacesEnd),obj.solids(end).getFaces);
        end
        
        
        %% test assignDofs
        function testAssignDofs(obj)
            TrueNumberOfDofs = obj.DofDimension*(length(obj.Nodes)...
                + length(obj.Edges)*(obj.PolynomialDegree-1)...
                + length(obj.Faces)*(obj.PolynomialDegree-1)^2 ...
                + length(obj.solids)*(obj.PolynomialDegree-1)^3);
            assertEqual(obj.NumberOfDofs,TrueNumberOfDofs);
        end
        
        %% test createElements
        function testCreateElements(obj)
            % Test size of elements
            NumberOfElements = obj.NumberOfXDivisions*obj.NumberOfYDivisions*obj.NumberOfZDivisions;
            assertEqual(length(obj.Elements),NumberOfElements);
            % Test if the nodes, edges, faces and volumens are stored 
            % correctly into the elements
            % Testing first element
            Nodes1 = [1 2 5 4 13 14 17 16];
            Edges1 = [1 56 3 41 86 90 102 98 9 59 11 44];
            Faces1 = [1 67 43 75 31 7];
            assertEqual(obj.Nodes(Nodes1),obj.Elements(1).getNodes);
            assertEqual(obj.Edges(Edges1),obj.Elements(1).getEdges);
            assertEqual(obj.Faces(Faces1),obj.Elements(1).getFaces);
            % Testing last element
            NodesEnd = [44 45 48 47 56 57 60 59];
            EdgesEnd = [30 82 32 67 117 121 133 129 38 85 40 70];
            FacesEnd = [24 90 66 98 54 30];
            assertEqual(obj.Nodes(NodesEnd),obj.Elements(end).getNodes);
            assertEqual(obj.Edges(EdgesEnd),obj.Elements(end).getEdges);
            assertEqual(obj.Faces(FacesEnd),obj.Elements(end).getFaces);
        end
    end 
end

