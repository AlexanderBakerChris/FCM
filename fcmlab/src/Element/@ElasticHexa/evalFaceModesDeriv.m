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
 
% evaluate face modes derivatives in direction r, s and t
%  This function evaluates the face modes derivatives with respect to 
%  direction r, s and t at local coordinate.

function FaceModesDeriv = evalFaceModesDeriv(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsPerFace)
        
    % initializing a matrix to store all the face modes over each edge
    FaceModesDeriv = zeros(1,18*DofsPerFace^2);
    
    k = 1; % k just helps to have the value in the correct place
    for i = 1:DofsPerFace
        for j = 1:DofsPerFace
            FaceModesDeriv(1,k) = 0.5 * OneMinusT * DerivPhiR(i) * PhiS(j); % face 1 wrt r
            FaceModesDeriv(1,k+DofsPerFace^2) = 0.5 * OneMinusS * DerivPhiR(i) * PhiT(j); % face 2 wrt r
            FaceModesDeriv(1,k+2*DofsPerFace^2) = 0.5 * PhiS(i) * PhiT(j); % face 3 wrt r
            FaceModesDeriv(1,k+3*DofsPerFace^2) = 0.5 * OnePlusS * DerivPhiR(i) * PhiT(j); % face 4 wrt r
            FaceModesDeriv(1,k+4*DofsPerFace^2) = - 0.5 * PhiS(i) * PhiT(j); % face 5 wrt r
            FaceModesDeriv(1,k+5*DofsPerFace^2) = 0.5 * OnePlusT * DerivPhiR(i) * PhiS(j); % face 6 wrt r
            
            FaceModesDeriv(1,k+6*DofsPerFace^2) = 0.5 * OneMinusT * PhiR(i) * DerivPhiS(j); % face 1 wrt s
            FaceModesDeriv(1,k+7*DofsPerFace^2) = - 0.5 * PhiR(i) * PhiT(j); % face 2 wrt s
            FaceModesDeriv(1,k+8*DofsPerFace^2) = 0.5 * OnePlusR * DerivPhiS(i) * PhiT(j); % face 3 wrt s
            FaceModesDeriv(1,k+9*DofsPerFace^2) = 0.5 * PhiR(i) * PhiT(j); % face 4 wrt s
            FaceModesDeriv(1,k+10*DofsPerFace^2) = 0.5 * OneMinusR * DerivPhiS(i) * PhiT(j); % face 5 wrt s
            FaceModesDeriv(1,k+11*DofsPerFace^2) = 0.5 * OnePlusT * PhiR(i) * DerivPhiS(j); % face 6 wrt s
            
            FaceModesDeriv(1,k+12*DofsPerFace^2) = - 0.5 * PhiR(i) * PhiS(j); % face 1 wrt t
            FaceModesDeriv(1,k+13*DofsPerFace^2) = 0.5 * OneMinusS * PhiR(i) * DerivPhiT(j); % face 2 wrt t
            FaceModesDeriv(1,k+14*DofsPerFace^2) = 0.5 * OnePlusR * PhiS(i) * DerivPhiT(j); % face 3 wrt t
            FaceModesDeriv(1,k+15*DofsPerFace^2) = 0.5 * OnePlusS * PhiR(i) * DerivPhiT(j); % face 4 wrt t
            FaceModesDeriv(1,k+16*DofsPerFace^2) = 0.5 * OneMinusR * PhiS(i) * DerivPhiT(j); % face 5 wrt t
            FaceModesDeriv(1,k+17*DofsPerFace^2) = 0.5 * PhiR(i) * PhiS(j); % face 6 wrt t
            
            k = k+1;
        end
    end
    
end

