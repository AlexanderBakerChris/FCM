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
 
% Weak Face Dirichlet Boundary Condition

classdef WeakFaceDirichletBoundaryCondition < WeakTopologyDirichletBoundaryCondition
    
    properties (Access = private)
        FaceStart
        FaceEnd
    end
    
    methods (Access = public)
        %% Constructor
        function obj = WeakFaceDirichletBoundaryCondition(FaceStart,FaceEnd,integrationScheme,PrescribedFunction,Direction,WeakDirichletAlgorithm)
            obj = obj@WeakTopologyDirichletBoundaryCondition(PrescribedFunction,Direction,integrationScheme,WeakDirichletAlgorithm);
            
            obj.FaceStart = FaceStart;
            obj.FaceEnd = FaceEnd;
        end
        
        function [K F] = modifyLinearSystem(obj,Mesh,K,F)
            Faces = Mesh.findFaces(obj.FaceStart, obj.FaceEnd);
            for i = 1:length(Faces)
                Quads(i) = Faces(i).getQuad;
            end
            
            MyWeakDirichletBoundaryCondition = WeakDirichletBoundaryCondition(obj.PrescribedFunction,obj.Direction,obj.integrationScheme,Quads,obj.WeakDirichletAlgorithm);
            [K F] = MyWeakDirichletBoundaryCondition.modifyLinearSystem(Mesh,K,F);
        end
    end
    
end

