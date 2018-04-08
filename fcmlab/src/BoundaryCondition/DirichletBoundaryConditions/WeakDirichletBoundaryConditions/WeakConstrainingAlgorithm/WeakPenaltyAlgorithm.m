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
 
% Weak Penalty Dirichlet Algorithm

classdef WeakPenaltyAlgorithm < AbsWeakConstrainingAlgorithm
    %%
    methods (Access = public)
        % constructor
        function obj = WeakPenaltyAlgorithm(PenaltyValue)
            obj.PenaltyValue = PenaltyValue;
        end
        
        %
        function [K F] = modifyLinearSystem(obj,BoundaryGeometry,IntegrationScheme,PrescribedFunction,Direction,K,F,Mesh)
            
            IntegrationPoints = IntegrationScheme.getCoordinates(BoundaryGeometry);
            IntegrationWeights = IntegrationScheme.getWeights(BoundaryGeometry);
            
            for i = 1:size(IntegrationPoints,1)
                detJ = BoundaryGeometry.calcDetJacobian(IntegrationPoints(i,:));
                GlobalCoordinate = BoundaryGeometry.mapLocalToGlobal(IntegrationPoints(i,:));
                
                Element = Mesh.findElementByPoint(GlobalCoordinate);
                
                LocationMatrix = Element.getLocationMatrix;
                
                SpaceDimension = Element.getSpaceDimension;
                PolynomialDegree = Element.getPolynomialDegree;
                
                DofsPerDir = (PolynomialDegree+1)^SpaceDimension;
                
                for j = 1:length(Direction)
                    if (Direction(j) ~= 0)
                        
                        LocalCoordinate = Element.mapGlobalToLocal(GlobalCoordinate);
                        
                        N = Element.getShapeFunctionsMatrix(LocalCoordinate);
                        
                        OneDirectionN = N(1,1:DofsPerDir);
                        OneDirectionLocationMatrix = LocationMatrix(1+(j-1)*DofsPerDir:j*DofsPerDir);
                        
                        %add penalty term to K
                        M =  IntegrationWeights(i)* detJ*(OneDirectionN'*OneDirectionN) ;
                        M = obj.PenaltyValue*M;
                        
                        K = Mesh.scatterElementMatrixIntoGlobalMatrix(M,...
                            OneDirectionLocationMatrix,K);
                        
                        %add penalty term to F
                        
                        PrescribedValue = PrescribedFunction(GlobalCoordinate(1),GlobalCoordinate(2),GlobalCoordinate(3));
                        m =  IntegrationWeights(i) * detJ * PrescribedValue * OneDirectionN';
                        m = obj.PenaltyValue*m;
                        
                        % add to all Load Vectors
                        for k = 1:size(F,2)
                            F(:,k) = Mesh.scatterElementVectorIntoGlobalVector(m,...
                                OneDirectionLocationMatrix,F(:,k));
                        end
                    end
                    
                end
                
            end
        end
        
    end
    
    %%
    properties (Access = private)
        PenaltyValue
    end
end

