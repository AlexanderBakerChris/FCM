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
 
% Weak Nitsche Dirichlet Algorithm

classdef WeakNitscheDirichletAlgorithm < AbsWeakConstrainingAlgorithm
    
    methods (Access = public)
        %% constructor
        function obj = WeakNitscheDirichletAlgorithm(PenaltyValue,TractionOperand)
            obj.WeakPenaltyAlgorithm = WeakPenaltyAlgorithm(PenaltyValue);
            obj.TractionOperand = TractionOperand;
        end
        
        function [K F] = modifyLinearSystem(obj,BoundaryGeometry,IntegrationScheme,PrescribedFunction,Direction,K,F,Mesh)
            
            %add penalty term to K and F
            [K,F] = obj.WeakPenaltyAlgorithm.modifyLinearSystem(BoundaryGeometry,IntegrationScheme,PrescribedFunction,Direction,K,F,Mesh);
            
            IntegrationPoints = IntegrationScheme.getCoordinates(BoundaryGeometry);
            IntegrationWeights = IntegrationScheme.getWeights(BoundaryGeometry);
            
            for i = 1:size(IntegrationPoints,1)
                detJ = BoundaryGeometry.calcDetJacobian(IntegrationPoints(i,:));
                
                GlobalCoordinate = BoundaryGeometry.mapLocalToGlobal(IntegrationPoints(i,:));
                       
                Element = Mesh.findElementByPoint(GlobalCoordinate);
                
                LocationMatrix = Element.getLocationMatrix;
                               
                for j = 1:length(Direction)
                    if (Direction(j) ~= 0)
                        
                        LocalCoordinate = Element.mapGlobalToLocal(GlobalCoordinate);
                        
                        N = Element.getShapeFunctionsMatrix(LocalCoordinate);
                        
                        
                        % OneField means that we take the corresponding
                        % values of the 'j' field index
                        OneFieldN = N(j,:);
                        
                        
                        % Traction vector
                        TractionVector = obj.TractionOperand.getTractionVector(j,IntegrationPoints(i,:),...
                            Element,BoundaryGeometry,LocalCoordinate);
                  
                        
                        % Add -(G+G') to K
                        G = IntegrationWeights(i) * detJ * TractionVector * OneFieldN;
                        
                        K = Mesh.scatterElementMatrixIntoGlobalMatrix(-(G+G'),...
                            LocationMatrix,K);
                        
                        % Add -g to F
                        PrescribedValue = PrescribedFunction(GlobalCoordinate(1),GlobalCoordinate(2),GlobalCoordinate(3));
                        
                        g = IntegrationWeights(i) * detJ * TractionVector * PrescribedValue;
                        
                        % Add to all Load Vectors
                        for k = 1:size(F,2)
                            F(:,k) = Mesh.scatterElementVectorIntoGlobalVector(-g,...
                                LocationMatrix,F(:,k));
                        end
                        
                    end
                    
                end
                
            end
        end
        
    end
    
    properties (Access = protected)
        WeakPenaltyAlgorithm
        TractionOperand
    end
    
end

