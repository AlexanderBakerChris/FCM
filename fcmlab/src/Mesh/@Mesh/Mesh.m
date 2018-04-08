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
 
% Mesh Class
%   This class contains elements, nodes, edges, faces, volumes and
%   number of Dofs of the mesh also assembles the Global Stiffness matrix,
%   Global Mass Matrix and Global Load Vector.

classdef Mesh < handle
  
    methods (Access = public)
        %% Constructor
        function obj = Mesh(MeshFactory)
            obj.Nodes = MeshFactory.createNodes();
            obj.Edges = MeshFactory.createEdges(obj.Nodes);
            obj.Faces = MeshFactory.createFaces(obj.Nodes, obj.Edges);
            obj.solids = MeshFactory.createSolids(obj.Nodes, obj.Edges, obj.Faces);
            obj.NumberOfDofs = MeshFactory.assignDofs(obj.Nodes,obj.Edges,obj.Faces,obj.solids);
            obj.Elements = MeshFactory.createElements(obj.Nodes,obj.Edges,obj.Faces,obj.solids);
            obj.NumberOfXDivisions = MeshFactory.getNumberOfXDivisions();
            obj.NumberOfYDivisions = MeshFactory.getNumberOfYDivisions();
            obj.NumberOfZDivisions = MeshFactory.getNumberOfZDivisions();
            obj.MeshOrigin = MeshFactory.getMeshOrigin();
            obj.Lx = MeshFactory.getLX();
            obj.Ly = MeshFactory.getLY();
            obj.Lz = MeshFactory.getLZ();
        end
        
        %% Assembly of the system
        K = assembleStiffnessMatrix(obj)
        M = assembleMassMatrix(obj)
        F = assembleLoadVector(obj,LoadCase)
        
        %% Scattering Solution
        scatterSolution(obj,SolutionVector)
        
        %% Get Number of Dofs
        function n = getNumberOfDofs(obj)
            n = obj.NumberOfDofs;
        end
        %% Get Nodes
        function Nodes = getNodes(obj)
            Nodes = obj.Nodes;
        end
        %% Get Edges
        function Edges = getEdges(obj)
            Edges = obj.Edges;
        end
        %% Get Faces
        function Faces = getFaces(obj)
            Faces = obj.Faces;
        end
        %% Get solids
        function solids = getSolids(obj)
            solids = obj.Solids;
        end
        %% Get Elements
        function Elements = getElements(obj)
            Elements = obj.Elements;
        end
        %% get Element
        function Element = getElement(obj,id)
            Element = obj.Elements(id);
        end
	    %% get Mesh Origin
        function Origin = getMeshOrigin(obj)
            Origin = obj.MeshOrigin;
        end
        %% get Number Of Elements
        function NumberOfElements = getNumberOfElements(obj)
            NumberOfElements = length(obj.Elements);
        end
        %% get NumberOfXDivisions
        function NumberOfXDivisions = getNumberOfXDivisions(obj)
            NumberOfXDivisions = obj.NumberOfXDivisions;
        end
        %% get NumberOfYDivisions
        function NumberOfYDivisions = getNumberOfYDivisions(obj)
            NumberOfYDivisions = obj.NumberOfYDivisions;
        end
        %% get NumberOfZDivisions
        function NumberOfZDivisions = getNumberOfZDivisions(obj)
            NumberOfZDivisions = obj.NumberOfZDivisions;
        end
        %% get Lx
        function Lx = getLX(obj)
            Lx = obj.Lx;
        end
        %% get Ly
        function Ly = getLY(obj)
            Ly = obj.Ly;
        end
        %% get Lz
        function Lz = getLZ(obj)
            Lz = obj.Lz;
        end
        
        %% Find Functions
        % used when defining the loads or boundary conditions
        
        % Returns an element given a Point's coordinates [1x3] row vector
        Element = findElementByPoint(obj,Point);
        
        % Find node according to position vector [1x3] row vector
        Node = findNode(obj,Position);
        
        % Find edges line according to LineStart Positon [1x3] row vector 
        % and LineEnd Position [1x3] row vector
        Edges = findEdges(obj,LineStart,LineEnd);
        
        % Find faces according to starting point [1x3] row vector
        % and end point [1x3] row vector - 
        [Faces,NumberOfFacesAlong1,NumberOfFacesAlong2] = findFaces(obj,StartPoint,EndPoint);
        
        % Check that a point is a node of the mesh
        IsNode = checkPointIsNode(obj,Position);
        
        % Convert coordinates x,y,z into indices i,j,k on the mesh
        [i,j,k] = convertCoordinatesIntoIndices(obj,NodePosition,roundingFunctionHandle);
        
        %%
        function subDomains = getIntegrationCells( obj )
            subDomains = [];
            for i = 1:length(obj.Elements)
                subDomains = [ subDomains, obj.Elements(i).getIntegrationCells( ) ];
            end
        end
    end
    
    %%
    methods (Access = public, Static)
        GlobalMatrix = scatterElementMatrixIntoGlobalMatrix(ElementMatrix,LocationMatrix,GlobalMatrix)
        GlobalVector = scatterElementVectorIntoGlobalVector(ElementVector,LocationMatrix,GlobalVector)
    end
    
    %%
    properties(Access = private)
        NumberOfDofs
        Nodes
        Edges
        Faces
        solids
        Elements
        NumberOfXDivisions
        NumberOfYDivisions
        NumberOfZDivisions
        MeshOrigin
        Lx
        Ly
        Lz
    end
    
end
