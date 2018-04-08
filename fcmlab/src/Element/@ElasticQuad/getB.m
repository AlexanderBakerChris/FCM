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
 
% function getB
% It returns the B-Matrix for element stiffness matrix calculation at
% specified local coordinates

function B = getB(obj,Coord)

    % Size M per Dof dimension for the B matrix
    SizeMPerDofDimension = (obj.PolynomialDegree+1)^2;
    
    Jacobian = obj.getJacobianZeroZero();
    B = zeros(3,obj.DofDimension*SizeMPerDofDimension);
            
    % Calculating derivatives of shape functions divided by Jacobian
    % Derivatives in r and s direction (returns a vector 1xM)
    DerivShapeFunction = obj.evalDerivOfShapeFunct(Coord);
    % Dividing by Jacobian
    DerivShapeFunctionR = DerivShapeFunction(1,1:SizeMPerDofDimension)/Jacobian(1,1);
    DerivShapeFunctionS = DerivShapeFunction(1,SizeMPerDofDimension+1:2*SizeMPerDofDimension)/Jacobian(2,2);
    
    % Assembling derivatives into B matrix
    B(1,1:SizeMPerDofDimension) = DerivShapeFunctionR;
    B(2,SizeMPerDofDimension+1:obj.DofDimension*SizeMPerDofDimension) = DerivShapeFunctionS;
    B(3,1:SizeMPerDofDimension) = DerivShapeFunctionS;
    B(3,SizeMPerDofDimension+1:obj.DofDimension*SizeMPerDofDimension) = DerivShapeFunctionR;
    
end