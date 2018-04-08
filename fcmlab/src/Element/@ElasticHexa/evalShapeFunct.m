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
 
% evaluate the shape function
% This function evaluates a specified shape function at a local coordinate.

function N = evalShapeFunct(obj,Coord)

    DofsLocalDirection = obj.PolynomialDegree-1;
    
    PhiR = zeros(1,DofsLocalDirection);
    PhiS = zeros(1,DofsLocalDirection);
    PhiT = zeros(1,DofsLocalDirection);
    
    for i = 1:DofsLocalDirection
        PhiR(1,i) = obj.evalPhi(i+1,Coord(1));
        PhiS(1,i) = obj.evalPhi(i+1,Coord(2));
        PhiT(1,i) = obj.evalPhi(i+1,Coord(3));
    end
    
    OneMinusR = (1 - Coord(1));
    OnePlusR = (1 + Coord(1));
    
    OneMinusS = (1 - Coord(2));
    OnePlusS = (1 + Coord(2));
    
    OneMinusT = (1 - Coord(3));
    OnePlusT = (1 + Coord(3));

    NodalModes = obj.evalNodalModes(OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS);

    EdgeModes = obj.evalEdgeModes(OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DofsLocalDirection);
    
    FaceModes = obj.evalFaceModes(OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DofsLocalDirection);
    
    VolumeModes = obj.evalVolumeModes(PhiR,PhiS,PhiT,DofsLocalDirection);
    
    N = [NodalModes EdgeModes FaceModes VolumeModes];

end