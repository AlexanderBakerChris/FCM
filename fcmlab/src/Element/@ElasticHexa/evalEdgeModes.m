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
 
% evaluate edge modes in direction r, s and t
%  This function evaluates the edge modes with respect to direction r, s
%  and t at local coordinate.

function EdgeModes = evalEdgeModes(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DofsPerEdge)
    
    % initializing a matrix to store all the edge modes over each edge
    EdgeModes = zeros(1,12*DofsPerEdge);
    
    k = 1;
    
    for i = 1:DofsPerEdge
        
        EdgeModes(1,k) = 0.25 * OneMinusS * OneMinusT * PhiR(1,i); % edge 1
        EdgeModes(1,DofsPerEdge+k) = 0.25 * OnePlusR * OneMinusT * PhiS(1,i); % edge 2
        EdgeModes(1,2*DofsPerEdge+k) = 0.25 * OnePlusS * OneMinusT * PhiR(1,i); % edge 3
        EdgeModes(1,3*DofsPerEdge+k) = 0.25 * OneMinusR * OneMinusT * PhiS(1,i); % edge 4
        
        EdgeModes(1,4*DofsPerEdge+k) = 0.25 * OneMinusR * OneMinusS * PhiT(1,i); % edge 5
        EdgeModes(1,5*DofsPerEdge+k) = 0.25 * OnePlusR * OneMinusS * PhiT(1,i); % edge 6
        EdgeModes(1,6*DofsPerEdge+k) = 0.25 * OnePlusR * OnePlusS * PhiT(1,i); % edge 7
        EdgeModes(1,7*DofsPerEdge+k) = 0.25 * OneMinusR * OnePlusS * PhiT(1,i); % edge 8
        
        EdgeModes(1,8*DofsPerEdge+k) = 0.25 * OneMinusS * OnePlusT * PhiR(1,i); % edge 9
        EdgeModes(1,9*DofsPerEdge+k) = 0.25 * OnePlusR * OnePlusT * PhiS(1,i); % edge 10
        EdgeModes(1,10*DofsPerEdge+k) = 0.25 * OnePlusS * OnePlusT * PhiR(1,i); % edge 11
        EdgeModes(1,11*DofsPerEdge+k) = 0.25 * OneMinusR * OnePlusT * PhiS(1,i); % edge 12
        
        k = k+1;
        
    end
     
end

