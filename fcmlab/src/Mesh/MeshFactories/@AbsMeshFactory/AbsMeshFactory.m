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
 
%Mesh factory
%   Helps to create the mesh without knowing exactly the class of mesh that
%   will be created, i.e. 1D, 2D or 3D mesh.

classdef AbsMeshFactory

    methods(Abstract,Access = public)
        %% interface methods
        Nodes = createNodes(obj)
        Edges = createEdges(obj)
        Faces = createFaces(obj)
        Solids = createSolids(obj)
        Elements = createElements(obj)
    end       
    
    methods(Access = public)
        %% constructor
        function obj = AbsMeshFactory(PolynomialDegree,DofDimension,...
                NumberingScheme,ElementFactory)
            obj.PolynomialDegree = PolynomialDegree;
            obj.DofDimension = DofDimension;
            obj.NumberingScheme = NumberingScheme;
            obj.ElementFactory = ElementFactory;
            
        end
    end

    methods(Access = public)   
        % assign degrees of freedom, and return number of dofs
        function NumberOfDofs = assignDofs(obj,Nodes,Edges,Faces,Solids)
            NumberOfDofs = obj.NumberingScheme.assignDofs(Nodes,Edges,Faces,Solids,...
                obj.PolynomialDegree,obj.DofDimension);
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
        %% get MeshOrigin
        function MeshOrigin = getMeshOrigin(obj)
            MeshOrigin = obj.MeshOrigin;
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
        
    end
    
    methods (Access = protected)
        %% create nodes on a straight line in x-dircetion
        NodesOnLine = createNodesOnLine(obj,StartPoint,EndPoint);

        %% create nodes on an xy-rectangle
        NodesOnRectangle = createNodesOnRectangle(obj,StartPoint,EndPoint);
                
        %% create all nodes for a cuboid
        NodesOnCuboid = createNodesOnCuboid(obj,StartPoint,EndPoint);
        
        %% creates edges on a line of nodes
        EdgesOnLine = createEdgesOnLine(obj,Nodes);
        
        %% create direction-1 edges for a rectangle (horizontal)
        EdgesDirection1 =  createEdgesOnRectangleDirection1(obj,...
            NodesOnRectangle,NumberOf1Divisions,NumberOf2Divisions);
        
        %% create direction-2 edges for a rectangle (vertical)
        EdgesDirection2 = createEdgesOnRectangleDirection2(obj,...
            NodesOnRectangle,NumberOf1Divisions,NumberOf2Divisions);
            
        %% creates all edges for a cuboid
        EdgesOnCuboid = createEdgesOnCuboid(obj,NodesOnCuboid);
        
        %% creates all faces for a rectangle
        FacesOnRectangle = createFacesOnRectangle(obj,NodesOnRectangle,...
            EdgesOnRectangle,NumberOf1Divisions,NumberOf2Divisions);
        
        %% creates all faces for a rectangle
        FacesOnCuboid = createFacesOnCuboid(obj,NodesOnCuboid,EdgesOnCuboid);
        
        %% create all volumes for a cuboid
        solidssOnCuboid = createSolidsOnCuboid(obj,NodesOnCuboid,...
            EdgesOnCuboid,FacesOnCuboid);
    end
    
    properties (Access = protected)
        PolynomialDegree
        NumberOfXDivisions
        NumberOfYDivisions
        NumberOfZDivisions
        DofDimension
        NumberingScheme
        Lx
        Ly
        Lz
        MeshOrigin
        ElementFactory
    end
end