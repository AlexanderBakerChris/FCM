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
 
%TopologicalSorting
% Scheme: Nodes - Edges - Faces - solids

classdef TopologicalSorting < AbsNumberingScheme
    
    methods (Access = public)
        %% Constructor
        function obj = TopologicalSorting()
            Logger.Log('Using Topological Sorting.','release');
        end
        
        %% Interface Method
        function TotalDofCounter= assignDofs(obj,Nodes,Edges,Faces,Solids,...
                PolynomialDegree,DofDimension)
            TotalDofCounter = 0;
            
            for CurrentDofDimension = 1:DofDimension
                TotalDofCounter = obj.assignDofsToNodes(CurrentDofDimension,TotalDofCounter,Nodes);
                TotalDofCounter = obj.assignDofsToEdges(CurrentDofDimension,TotalDofCounter,Edges,PolynomialDegree);
                TotalDofCounter = obj.assignDofsToFaces(CurrentDofDimension,TotalDofCounter,Faces,PolynomialDegree);
                TotalDofCounter = obj.assignDofsToSolids(CurrentDofDimension,TotalDofCounter,Solids,PolynomialDegree);
            end
        end
        
    end
    
    methods (Access = protected)
        %% Assign Dofs to edges
        function EdgeDofCounter = assignDofsToEdges(obj,CurrentDofDimension,TotalDofCounter,Edges,PolynomialDegree)
            EdgeDofCounter = assignDofsToTopology(obj,CurrentDofDimension,TotalDofCounter,Edges,PolynomialDegree,1);
        end
        
        %% Assign Dofs to faces
        function FaceDofCounter = assignDofsToFaces(obj,CurrentDofDimension,TotalDofCounter,Faces,PolynomialDegree)
            FaceDofCounter = assignDofsToTopology(obj,CurrentDofDimension,TotalDofCounter,Faces,PolynomialDegree,2);
        end
        
        %% Assign Dofs to solids
        function solidDofCounter = assignDofsToSolids(obj,CurrentDofDimension,TotalDofCounter,solids,PolynomialDegree)
            solidDofCounter = assignDofsToTopology(obj,CurrentDofDimension,TotalDofCounter,solids,PolynomialDegree,3);
        end
        
        %% Assign Dofs to topology
        function TopologyDofCounter = assignDofsToTopology(obj,CurrentDofDimension,TotalDofCounter,Topology,PolynomialDegree,TopologySpaceDimension)
            TopologyDofCounter = TotalDofCounter;
            for i = 1:length(Topology)
                DofHandle = Topology(i).getDof;
                for j = 1:(PolynomialDegree - 1)^TopologySpaceDimension
                    DofHandle(j+(CurrentDofDimension-1)*((PolynomialDegree-1)^TopologySpaceDimension)).Id = TopologyDofCounter+1;
                    TopologyDofCounter = TopologyDofCounter+1;
                end
                
            end
        end
        
    end
    
    properties (Access = private)
    end
    
end

