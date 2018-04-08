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
 
% evaluate the derivative of a shape function in direction r, s and t
% This function evaluates the derivative with respect to direction r, s and
% t of a specified shape function at a local coordinate.

function dN = evalDerivOfShapeFunct(obj,Coord)

    DofsLocalDirection = obj.PolynomialDegree-1;
    
    DerivPhiR = zeros(1,DofsLocalDirection);
    DerivPhiS = zeros(1,DofsLocalDirection);
    DerivPhiT = zeros(1,DofsLocalDirection);
    PhiR = zeros(1,DofsLocalDirection);
    PhiS = zeros(1,DofsLocalDirection);
    PhiT = zeros(1,DofsLocalDirection);
    
    for i = 1:DofsLocalDirection
        DerivPhiR(1,i) = obj.evalDerivOfPhi(i+1,Coord(1));
        DerivPhiS(1,i) = obj.evalDerivOfPhi(i+1,Coord(2));
        DerivPhiT(1,i) = obj.evalDerivOfPhi(i+1,Coord(3));
        PhiR(1,i) = obj.evalPhi(i+1,Coord(1));
        PhiS(1,i) = obj.evalPhi(i+1,Coord(2));
        PhiT(1,i) = obj.evalPhi(i+1,Coord(3));
    end
    
    OneMinusT = (1 - Coord(3));
    OnePlusT = (1 + Coord(3));
    
    OneMinusR = (1 - Coord(1));
    OnePlusR = (1 + Coord(1));
    
    OneMinusS = (1 - Coord(2));
    OnePlusS = (1 + Coord(2));

    NodalModesDeriv = obj.evalNodalModesDeriv(OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS);
    EdgeModesDeriv = obj.evalEdgeModesDeriv(OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsLocalDirection);
    FaceModesDeriv = obj.evalFaceModesDeriv(OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsLocalDirection);
    VolumeModesDeriv = obj.evalVolumeModesDeriv(PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsLocalDirection);
    
    dN = [NodalModesDeriv(1,1:8) EdgeModesDeriv(1,1:12*DofsLocalDirection) FaceModesDeriv(1,1:6*DofsLocalDirection^2) VolumeModesDeriv(1,1:DofsLocalDirection^3) ...
        NodalModesDeriv(1,9:16) EdgeModesDeriv(1,12*DofsLocalDirection+1:24*DofsLocalDirection) FaceModesDeriv(1,6*DofsLocalDirection^2+1:12*DofsLocalDirection^2) VolumeModesDeriv(1,DofsLocalDirection^3+1:2*DofsLocalDirection^3) ...
        NodalModesDeriv(1,17:24) EdgeModesDeriv(1,24*DofsLocalDirection+1:36*DofsLocalDirection) FaceModesDeriv(1,12*DofsLocalDirection^2+1:18*DofsLocalDirection^2) VolumeModesDeriv(1,2*DofsLocalDirection^3+1:3*DofsLocalDirection^3)];
    
end


