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
 
%Mesh factory for a 1D Uniform case
%   This class creates a uniform mesh for a 1D element, it is derived from
%   the MeshFactory

classdef MeshFactory1DUniform < AbsMeshFactory
    
    methods (Access = public)
        %% Constructor
        function obj = MeshFactory1DUniform(NumberOfXDivisions,...
                PolynomialDegree,NumberingScheme,DofDimension,MeshOrigin,...
                Lx,ElementFactory)
            obj = obj@AbsMeshFactory(PolynomialDegree,DofDimension,...
                NumberingScheme,ElementFactory);
            obj.NumberOfXDivisions = NumberOfXDivisions;
            obj.NumberOfYDivisions = 0;
            obj.NumberOfZDivisions = 0;
            obj.Lx = Lx;
            obj.Ly = 1.0; % needed for find functions
            obj.Lz = 1.0;
            obj.MeshOrigin = MeshOrigin;
            obj.MeshOrigin(2) = 0.0;
            obj.MeshOrigin(3) = 0.0;
        end
            
        %% createNodes
        function Nodes = createNodes(obj)
            Logger.Log('Creating nodes......','release');
            Nodes = obj.createNodesOnLine([0 0 0]+obj.MeshOrigin,...
                [obj.Lx 0 0]+obj.MeshOrigin);

        end
        
        %% createEdges
        function Edges = createEdges(obj,Nodes)
            Logger.Log('Creating edges......','release');
            Edges = obj.createEdgesOnLine(Nodes);
        end
        
        %% create Faces
        function Faces = createFaces(obj,Nodes,Edges)
            Faces = [];
        end
        
        %% create solids
        function solids = createSolids(obj,Nodes,Edges,Faces)
            solids = [];
        end
        
        %% createElements
        function Elements = createElements(obj,Nodes,Edges,Faces,solids)
            Logger.Log('Creating elements......','release');
            
            for i=1:obj.NumberOfXDivisions
                NodePair = Nodes(i:i+1);
                OneEdge = Edges(i);                
                Elements(i) = obj.ElementFactory.createElement(NodePair,...
                    OneEdge,[],[],obj.PolynomialDegree,obj.DofDimension);
            end
        end
    end
    
    properties (Access = private)
    end
end
