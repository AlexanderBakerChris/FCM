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
 
% evaluate volume modes in direction r, s and t
%  This function evaluates the volume modes with respect to r, s and t
% direction at local coordinate.

function VolumeModesDeriv = evalVolumeModesDeriv(obj,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,InternalModes)
        
    % initializing a matrix to store all the face modes over each edge
    VolumeModesDeriv = zeros(1,3*InternalModes^3);
    
    m = 1; % m just helps to have the value in the correct place
    for i = 1:InternalModes
        for j = 1:InternalModes
            for k = 1:InternalModes
                VolumeModesDeriv(1,m) = DerivPhiR(i) * PhiS(j) * PhiT(k); %wrt r
                VolumeModesDeriv(1,m+InternalModes^3) = PhiR(i) * DerivPhiS(j) * PhiT(k); % wrt s
                VolumeModesDeriv(1,m+2*InternalModes^3) = PhiR(i) * PhiS(j) * DerivPhiT(k); % wrt t
                m = m+1;
            end
        end
    end
    
end

