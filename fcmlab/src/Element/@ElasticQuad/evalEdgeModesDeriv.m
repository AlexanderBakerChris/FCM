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
 
% evaluate edge modes derivatives in direction r and s
%  This function evaluates the edge modes derivatives with respect to 
%  direction r and s at local coordinate.

function EdgeModesDeriv = evalEdgeModesDeriv(obj,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,DerivPhiR,DerivPhiS,DofsPerEdge)
    
    % initializing a vector to store all the edge modes over each edge
    EdgeModesDeriv = zeros(1,8*DofsPerEdge);
    
    EdgeModesDeriv(1,1:DofsPerEdge) = 0.5*OneMinusS*DerivPhiR(1,:); % edge 1 wrt r
    EdgeModesDeriv(1,DofsPerEdge+1:2*DofsPerEdge) = 0.5*PhiS(1,:); % edge 2 wrt r
    EdgeModesDeriv(1,2*DofsPerEdge+1:3*DofsPerEdge) = 0.5*OnePlusS*DerivPhiR(1,:); % edge 3 wrt r
    EdgeModesDeriv(1,3*DofsPerEdge+1:4*DofsPerEdge) = -0.5*PhiS(1,:);  % edge 4 wrt r
    
    EdgeModesDeriv(1,4*DofsPerEdge+1:5*DofsPerEdge) = -0.5*PhiR(1,:); % edge 1 wrt s
    EdgeModesDeriv(1,5*DofsPerEdge+1:6*DofsPerEdge) = 0.5*OnePlusR*DerivPhiS(1,:); % edge 2 wrt s
    EdgeModesDeriv(1,6*DofsPerEdge+1:7*DofsPerEdge) = 0.5*PhiR(1,:); % edge 3 wrt s
    EdgeModesDeriv(1,7*DofsPerEdge+1:8*DofsPerEdge) = 0.5*OneMinusR*DerivPhiS(1,:); % edge 4 wrt s
 
end