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
 
%Mesh factory for a 2D Uniform case
%   This class creates a uniform mesh for a 2D element, it is derived from
%   the MeshFactory

classdef MeshFactory2DUniform < AbsMeshFactory
    
    methods (Access = public)
        %% constructor
        function obj = MeshFactory2DUniform(NumberOfXDivisions,NumberOfYDivisions,...
                PolynomialDegree,NumberingScheme,DofDimension,MeshOrigin,Lx,Ly,ElementFactory)
            obj = obj@AbsMeshFactory(PolynomialDegree,DofDimension,NumberingScheme,ElementFactory);
            obj.NumberOfXDivisions = NumberOfXDivisions;
            obj.NumberOfYDivisions = NumberOfYDivisions;
            obj.NumberOfZDivisions = 0;
            obj.Lx = Lx;
            obj.Ly = Ly;
            obj.Lz = 1; % needed for find functions
            obj.MeshOrigin = MeshOrigin;
            obj.MeshOrigin(3) = 0;
        end
        %% createNodes
        function Nodes = createNodes(obj)
            Nodes = obj.createNodesOnRectangle(obj.MeshOrigin,[obj.Lx obj.Ly 0.0]+obj.MeshOrigin);
            Logger.Log('Creating nodes......','release');
        end
        %% createEdges
        function Edges = createEdges(obj,Nodes)
            HorizontalEdges = obj.createEdgesOnRectangleDirection1(Nodes,obj.NumberOfXDivisions,obj.NumberOfYDivisions);
            VerticalEdges = obj.createEdgesOnRectangleDirection2(Nodes,obj.NumberOfXDivisions,obj.NumberOfYDivisions);
            Edges = [HorizontalEdges VerticalEdges];
            Logger.Log('Creating edges......','release');
        end
        %% createFaces
        function Faces = createFaces(obj,Nodes,Edges)
            Faces = obj.createFacesOnRectangle(Nodes,Edges,...
                obj.NumberOfXDivisions,obj.NumberOfYDivisions);
            Logger.Log('Creating faces......','release');
        end
        
        %% create solids
        function solids = createSolids(obj,Nodes,Edges,Faces)
            solids = [];
        end
        
        %% createElements
        function Elements = createElements(obj,Nodes,Edges,Faces,solids)
            Logger.Log('Creating elements......','release');
            
            for i = 1:length(Faces)
                OneFace = Faces(i);
                FourNodes = Faces(i).getNodes;
                FourEdges = Faces(i).getEdges;
                Elements(i) = obj.ElementFactory.createElement(FourNodes,...
                    FourEdges,OneFace,[],obj.PolynomialDegree,obj.DofDimension);
            end
        end
    end
    
    properties (Access = private)
    end
end

