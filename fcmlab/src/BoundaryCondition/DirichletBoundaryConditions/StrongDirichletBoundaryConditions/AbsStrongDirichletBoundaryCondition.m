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
 
% Strong Dirichlet Boundary Condition class

classdef AbsStrongDirichletBoundaryCondition < AbsDirichletBoundaryCondition
    %%
    methods (Access = public)
        function obj = AbsStrongDirichletBoundaryCondition(PrescribedFunction,Direction,StrongDirichletAlgorithm)
            obj = obj@AbsDirichletBoundaryCondition(PrescribedFunction,Direction);
            obj.StrongDirichletAlgorithm = StrongDirichletAlgorithm;
        end
    end
    
    %%
    methods (Access = protected)
        
        function [K, F] = constrainFaces(obj,K,F,Faces)
            % set face dofs to zero: flat faces
            % modify K and F
            idsToConstrain = [];

            for j = 1:length(obj.Direction)
                if obj.Direction(j) ~= 0
                    for i = 1:length(Faces)
                        dofsToConstrain = Faces(i).getDofsForIndex(j);
                        
                        for k = 1:length(dofsToConstrain)
                            idsToConstrain(end+1) = dofsToConstrain(k).Id;
                        end
                    end
                end
                       
            end
            
            prescribedValues = zeros(length(idsToConstrain), 1);
            [K, F] = obj.StrongDirichletAlgorithm.modifyLinearSystem(idsToConstrain,prescribedValues,K,F);
            
        end
        
            function [K, F] = constrainEdges(obj,K,F,Edges)
            % set edge dofs to zero: straight edges 
            idsToConstrain = [];
            
            % modify K and F
   
            for j = 1:length(obj.Direction)
                if obj.Direction(j) ~= 0
                    for i = 1:length(Edges)
                        dofsToConstrain = Edges(i).getDofsForIndex(j);
                        
                        for k = 1:length(dofsToConstrain)
                            idsToConstrain(end+1) = dofsToConstrain(k).Id;
                        end
                    end
                end
                       
            end
            
            prescribedValues = zeros(length(idsToConstrain), 1);
            [K, F] = obj.StrongDirichletAlgorithm.modifyLinearSystem(idsToConstrain,prescribedValues,K,F);

        end
        
        function[K, F] = setNodalDofs(obj,K,F,Nodes)
            
            idsToPrescribe = [];
            prescribedValues = [];
               
            % modify K and F
            
            for j = 1:length(obj.Direction)
                if obj.Direction(j) ~= 0
                    for i = 1:length(Nodes)
                        dofsToConstrain = Nodes(i).getDofsForIndex(j);
                        
                        nodeCoordinates = Nodes(i).getCoords();
                        value = obj.PrescribedFunction(nodeCoordinates(1),nodeCoordinates(2),nodeCoordinates(3));
                        
                        for k = 1:length(dofsToConstrain)
                            idsToPrescribe(end+1) = dofsToConstrain(k).Id;
                            prescribedValues(end+1,1) = value;
                        end
                    end
                end
                       
            end
            
            [K, F] = obj.StrongDirichletAlgorithm.modifyLinearSystem(idsToPrescribe,prescribedValues,K,F);
            
        end
    
    end
    %%
    properties (Access = protected)
        StrongDirichletAlgorithm
    end
end
