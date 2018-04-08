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
 
% evaluate the derivative of a shape function in direction r and s
% This function evaluates the derivatives of the nodal, edge, face modes
% in direction r and s at a local coordinate.

function dN = evalDerivOfShapeFunct(obj,Coord)

    DofsLocalDirection = obj.PolynomialDegree-1;
    
    DerivPhiR = zeros(1,DofsLocalDirection);
    PhiS = zeros(1,DofsLocalDirection);
    
    DerivPhiS = zeros(1,DofsLocalDirection);
    PhiR = zeros(1,DofsLocalDirection);

    for i = 1:DofsLocalDirection
        DerivPhiR(1,i) = obj.evalDerivOfPhi(i+1,Coord(1));
        PhiS(1,i) = obj.evalPhi(i+1,Coord(2));
        DerivPhiS(1,i) = obj.evalDerivOfPhi(i+1,Coord(2));
        PhiR(1,i) = obj.evalPhi(i+1,Coord(1));
    end
    
    OneMinusS = 1 - Coord(2);
    OnePlusS = 1 + Coord(2);
    OneMinusR = 1 - Coord(1);
    OnePlusR = 1 + Coord(1);
    
    NodalModesDeriv = obj.evalNodalModesDeriv(OneMinusR,OnePlusR,OneMinusS,OnePlusS);
    EdgeModesDeriv = obj.evalEdgeModesDeriv(OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,DerivPhiR,DerivPhiS,DofsLocalDirection);
    FaceModesDeriv = obj.evalFaceModesDeriv(PhiR,PhiS,DerivPhiR,DerivPhiS,DofsLocalDirection);
    
    dN = [NodalModesDeriv(1,1:4) EdgeModesDeriv(1,1:4*DofsLocalDirection) FaceModesDeriv(1,1:DofsLocalDirection^2),...
        NodalModesDeriv(1,5:8) EdgeModesDeriv(1,4*DofsLocalDirection+1:8*DofsLocalDirection) FaceModesDeriv(1,DofsLocalDirection^2+1:2*DofsLocalDirection^2)];
    
end