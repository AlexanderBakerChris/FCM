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
 
% Handle class for the Faces
%   This class constructs the faces asigning their edges and nodes, also
%   assign the Dofs
classdef Face < AbsTopology
    
    methods
        %% constructor
        function obj = Face(nodes,edges,polynomialDegree,dofDimension)

            for i=1:4
                vertices(i) = nodes(i).getVertex();
                lines(i) = edges(i).getLine();
            end
            
            myQuad = Rectangle(vertices,lines);
            
            numberOfDofsPerFieldComponent = (polynomialDegree-1) ^ 2;
            
            obj = obj@AbsTopology( myQuad,dofDimension, numberOfDofsPerFieldComponent );
            
            obj.nodes = nodes;
            obj.edges = edges;
        end
        
        %% get Nodes
        function Nodes = getNodes(obj)
            Nodes = obj.nodes;
        end
        
        %% get Edges
        function Edges = getEdges(obj)
            Edges = obj.edges;
        end
        
        %% get Quad
        function quad = getQuad(obj)
            quad = obj.geometricSupport;
        end
    end
    
    properties (Access = private)
        nodes
        edges
    end
    
end

