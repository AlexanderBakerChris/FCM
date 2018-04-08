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
 
% Handle Class for Solids
%   This class constructs solids asigning their faces, edges and nodes,
%   also assign the Dofs
classdef Solid < AbsTopology
    
    methods
        %% constructor
        function obj = Solid(nodes,edges,faces,polynomialDegree,dofDimension)
            
            for i = 1:8
                vertices(i) = nodes(i).getVertex;
            end
            
            for i = 1:12
                lines(i) = edges(i).getLine;
            end
            
            for i = 1:6
                quads(i) = faces(i).getQuad;
            end
            
            myHexa = Cuboid(vertices,lines,quads);
            
            numberOfDofsPerFieldComponent = (polynomialDegree - 1) ^ 3;
            
            obj = obj@AbsTopology(myHexa, dofDimension, numberOfDofsPerFieldComponent);
            
            obj.nodes = nodes;
            obj.edges = edges;
            obj.faces = faces;
        end
        
        %% get Nodes
        function Nodes = getNodes(obj)
            Nodes = obj.nodes;
        end
        
        %% get Edges
        function Edges = getEdges(obj)
            Edges = obj.edges;
        end
        
        %% get Faces
        function Edges = getFaces(obj)
            Edges = obj.faces;
        end
        
        %%
        function solid = getSolid(obj)
            solid = obj.geometricSupport;
        end
    end
    
    properties (Access = private)
        nodes
        edges
        faces
    end
    
end

