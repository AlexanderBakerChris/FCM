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
 
% Weak Neumann Boundary Condition

classdef WeakNeumannBoundaryCondition < AbsNeumannBoundaryCondition
    
    methods (Access = public)
        %% Constructor
        function obj = WeakNeumannBoundaryCondition(LoadFunction,IntegrationScheme,BoundaryGeometry)
            obj = obj@AbsNeumannBoundaryCondition(LoadFunction);
            obj.IntegrationScheme = IntegrationScheme;
            obj.BoundaryGeometry = BoundaryGeometry;
        end
        
        function F = augmentLoadVector(obj,Mesh,F)
            Logger.TaskStart(['Adding Weak Neumann Boundary Condition on ' num2str(length(obj.BoundaryGeometry)) ' ' ...
                class(obj.BoundaryGeometry) 's'],'release');
            for i = 1:length(obj.BoundaryGeometry)
                
                IntegrationCoords = obj.IntegrationScheme.getCoordinates(obj.BoundaryGeometry);
                IntegrationWeights = obj.IntegrationScheme.getWeights(obj.BoundaryGeometry);
                
                for j = 1:size(IntegrationCoords,1)
                    detJ = obj.BoundaryGeometry(i).calcDetJacobian(IntegrationCoords(j,:));
                    GlobalCoordinate = obj.BoundaryGeometry(i).mapLocalToGlobal(IntegrationCoords(j,:));
                    Element = Mesh.findElementByPoint(GlobalCoordinate);
                    
                    LocationMatrix = Element.getLocationMatrix;
                    
                    LoadValue = obj.LoadFunction(GlobalCoordinate(1),GlobalCoordinate(2),GlobalCoordinate(3));
                    
                    LocalCoordinate = Element.mapGlobalToLocal(GlobalCoordinate);
                    N = Element.getShapeFunctionsMatrix(LocalCoordinate);
                    
                    LoadVector = IntegrationWeights(j)* detJ * (N'*LoadValue);
                    F = Mesh.scatterElementVectorIntoGlobalVector(LoadVector,LocationMatrix,F);
                end
                
            end
            Logger.TaskFinish('Adding Weak Neumann Boundary Condition','release');
        end
    end
    
    properties (Access = private)
        BoundaryGeometry
        IntegrationScheme
    end
    
end

