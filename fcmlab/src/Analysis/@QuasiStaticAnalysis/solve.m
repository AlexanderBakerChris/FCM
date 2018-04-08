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
 
        %% Solver
        function [solutionVectors, strainEnergy] = solve(obj)

            stiffnessMatrix = obj.mesh.assembleStiffnessMatrix;
            K = stiffnessMatrix;
            
            lengthLoadCases = length(obj.loadCases);
            
            for i = 1:lengthLoadCases
                loadVectors(:,i) = obj.mesh.assembleLoadVector(obj.loadCases(i));
            end
            
            lengthBC = length(obj.dirichletBoundaryConditions);
            
            for i = 1:lengthBC    
                [stiffnessMatrix ,loadVectors] = ...
                    obj.dirichletBoundaryConditions{i}.modifyLinearSystem(obj.mesh,stiffnessMatrix,loadVectors);
            end
            
            for i = 1:length(obj.loadCases)
                Logger.TaskStart('Solving the Linear Equation System','release');
                obj.solutionVectors(:,i) = stiffnessMatrix \ loadVectors(:,i);
                Logger.TaskFinish('Solving the Linear Equation System','release');
                
                obj.strainEnergy = 0.5 * obj.solutionVectors(:,i)' * K * obj.solutionVectors(:,i);
                
                Logger.Log(['Strain Energy:', num2str(obj.strainEnergy,'%10.9E' ),'\n'],'release');
            end

            obj.mesh.scatterSolution(obj.solutionVectors);
            
            solutionVectors = obj.solutionVectors;
            strainEnergy = obj.strainEnergy;
            
        end  
