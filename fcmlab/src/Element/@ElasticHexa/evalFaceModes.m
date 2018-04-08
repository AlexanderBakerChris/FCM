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
 
% evaluate face modes in direction r, s and t
%  This function evaluates the face modes with respect to r, s and t
%  at local coordinate.

function FaceModes = evalFaceModes(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DofsPerFace)

    DofsPerFaceSquare = DofsPerFace^2;

    % initializing a matrix to store all the face modes over each edge
    FaceModes = zeros(1,6*DofsPerFaceSquare);
    
    k = 1; % k just helps to have the value in the correct place
    for i = 1:DofsPerFace
        for j = 1:DofsPerFace
            FaceModes(1,k) = 0.5 * OneMinusT * PhiR(i) * PhiS(j); % face 1
            FaceModes(1,k+DofsPerFaceSquare) = 0.5 * OneMinusS * PhiR(i) * PhiT(j); % face 2
            FaceModes(1,k+2*DofsPerFaceSquare) = 0.5 * OnePlusR * PhiS(i) * PhiT(j); % face 3
            FaceModes(1,k+3*DofsPerFaceSquare) = 0.5 * OnePlusS * PhiR(i) * PhiT(j); % face 4
            FaceModes(1,k+4*DofsPerFaceSquare) = 0.5 * OneMinusR * PhiS(i) * PhiT(j); % face 5
            FaceModes(1,k+5*DofsPerFaceSquare) = 0.5 * OnePlusT * PhiR(i) * PhiS(j); % face 6
            k = k+1;
        end
    end
     
end

