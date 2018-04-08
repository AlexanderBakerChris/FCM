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
 
% evaluate edge modes derivatives in direction r, s and t
%  This function evaluates the edge modes derivatives with respect to 
%  direction r, s and t at local coordinate.

function EdgeModesDeriv = evalEdgeModesDeriv(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsPerEdge)
    
    % initializing a matrix to store all the edge modes over each edge
    EdgeModesDeriv = zeros(1,36*DofsPerEdge);
    
    k = 1;
    
    for i = 1:DofsPerEdge
        
        % wrt r
        EdgeModesDeriv(1,k) = 0.25 * OneMinusS * OneMinusT * DerivPhiR(1,i); % edge 1 wrt r
        EdgeModesDeriv(1,DofsPerEdge+k) = 0.25 * OneMinusT * PhiS(1,i); % edge 2 wrt r
        EdgeModesDeriv(1,2*DofsPerEdge+k) = 0.25 * OnePlusS * OneMinusT * DerivPhiR(1,i); % edge 3 wrt r
        EdgeModesDeriv(1,3*DofsPerEdge+k) = - 0.25 * OneMinusT * PhiS(1,i); % edge 4 wrt r
        
        EdgeModesDeriv(1,4*DofsPerEdge+k) = - 0.25 * OneMinusS * PhiT(1,i); % edge 5 wrt r
        EdgeModesDeriv(1,5*DofsPerEdge+k) = 0.25 * OneMinusS * PhiT(1,i); % edge 6 wrt r
        EdgeModesDeriv(1,6*DofsPerEdge+k) = 0.25 * OnePlusS * PhiT(1,i); % edge 7 wrt r
        EdgeModesDeriv(1,7*DofsPerEdge+k) = - 0.25 * OnePlusS * PhiT(1,i); % edge 8 wrt r
        
        EdgeModesDeriv(1,8*DofsPerEdge+k) = 0.25 * OneMinusS * OnePlusT * DerivPhiR(1,i); % edge 9 wrt r
        EdgeModesDeriv(1,9*DofsPerEdge+k) = 0.25 * OnePlusT * PhiS(1,i); % edge 10 wrt r
        EdgeModesDeriv(1,10*DofsPerEdge+k) = 0.25 * OnePlusS * OnePlusT * DerivPhiR(1,i); % edge 11 wrt r
        EdgeModesDeriv(1,11*DofsPerEdge+k) = - 0.25 * OnePlusT * PhiS(1,i); % edge 12 wrt r
        
        % wrt s
        EdgeModesDeriv(1,12*DofsPerEdge+k) = - 0.25 * OneMinusT * PhiR(1,i); % edge 1 wrt s
        EdgeModesDeriv(1,13*DofsPerEdge+k) = 0.25 * OnePlusR * OneMinusT * DerivPhiS(1,i); % edge 2 wrt s
        EdgeModesDeriv(1,14*DofsPerEdge+k) = 0.25 * OneMinusT * PhiR(1,i); % edge 3 wrt s
        EdgeModesDeriv(1,15*DofsPerEdge+k) = 0.25 * OneMinusR * OneMinusT * DerivPhiS(1,i); % edge 4 wrt s
        
        EdgeModesDeriv(1,16*DofsPerEdge+k) = - 0.25 * OneMinusR * PhiT(1,i); % edge 5 wrt s
        EdgeModesDeriv(1,17*DofsPerEdge+k) = - 0.25 * OnePlusR * PhiT(1,i); % edge 6 wrt s
        EdgeModesDeriv(1,18*DofsPerEdge+k) = 0.25 * OnePlusR * PhiT(1,i); % edge 7 wrt s
        EdgeModesDeriv(1,19*DofsPerEdge+k) = 0.25 * OneMinusR * PhiT(1,i); % edge 8 wrt s
        
        EdgeModesDeriv(1,20*DofsPerEdge+k) = - 0.25 * OnePlusT * PhiR(1,i); % edge 9 wrt s
        EdgeModesDeriv(1,21*DofsPerEdge+k) = 0.25 * OnePlusR * OnePlusT * DerivPhiS(1,i); % edge 10 wrt s
        EdgeModesDeriv(1,22*DofsPerEdge+k) = 0.25 * OnePlusT * PhiR(1,i); % edge 11 wrt s
        EdgeModesDeriv(1,23*DofsPerEdge+k) = 0.25 * OneMinusR * OnePlusT * DerivPhiS(1,i); % edge 12 wrt s
        
        % wrt t
        EdgeModesDeriv(1,24*DofsPerEdge+k) = - 0.25 * OneMinusS * PhiR(1,i); % edge 1 wrt t
        EdgeModesDeriv(1,25*DofsPerEdge+k) = - 0.25 * OnePlusR * PhiS(1,i); % edge 2 wrt t
        EdgeModesDeriv(1,26*DofsPerEdge+k) = - 0.25 * OnePlusS * PhiR(1,i); % edge 3 wrt t
        EdgeModesDeriv(1,27*DofsPerEdge+k) = - 0.25 * OneMinusR * PhiS(1,i); % edge 4 wrt t
        
        EdgeModesDeriv(1,28*DofsPerEdge+k) = 0.25 * OneMinusR * OneMinusS * DerivPhiT(1,i); % edge 5 wrt t
        EdgeModesDeriv(1,29*DofsPerEdge+k) = 0.25 * OnePlusR * OneMinusS * DerivPhiT(1,i); % edge 6 wrt t
        EdgeModesDeriv(1,30*DofsPerEdge+k) = 0.25 * OnePlusR * OnePlusS * DerivPhiT(1,i); % edge 7 wrt t
        EdgeModesDeriv(1,31*DofsPerEdge+k) = 0.25 * OneMinusR * OnePlusS * DerivPhiT(1,i); % edge 8 wrt t
        
        EdgeModesDeriv(1,32*DofsPerEdge+k) = 0.25 * OneMinusS * PhiR(1,i); % edge 9 wrt t
        EdgeModesDeriv(1,33*DofsPerEdge+k) = 0.25 * OnePlusR * PhiS(1,i); % edge 10 wrt t
        EdgeModesDeriv(1,34*DofsPerEdge+k) = 0.25 * OnePlusS * PhiR(1,i); % edge 11 wrt t
        EdgeModesDeriv(1,35*DofsPerEdge+k) = 0.25 * OneMinusR * PhiS(1,i); % edge 12 wrt t
        
        k = k+1;
        
    end
     
end

