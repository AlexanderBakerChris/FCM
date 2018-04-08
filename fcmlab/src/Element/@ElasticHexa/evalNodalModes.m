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
 
% evaluate nodal modes in direction r, s and t
%  This function evaluates the nodal modes with respect to direction r, s
%  and t at local coordinate.

function NodalModes = evalNodalModes(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS)

    NodalModes(1,1) = 0.125 * OneMinusR * OneMinusS * OneMinusT;
    NodalModes(1,2) = 0.125 * OnePlusR * OneMinusS * OneMinusT;
    NodalModes(1,3) = 0.125 * OnePlusR * OnePlusS * OneMinusT;
    NodalModes(1,4) = 0.125 * OneMinusR * OnePlusS * OneMinusT;
    NodalModes(1,5) = 0.125 * OneMinusR * OneMinusS * OnePlusT;
    NodalModes(1,6) = 0.125 * OnePlusR * OneMinusS * OnePlusT;
    NodalModes(1,7) = 0.125 * OnePlusR * OnePlusS * OnePlusT;
    NodalModes(1,8) = 0.125 * OneMinusR * OnePlusS * OnePlusT;
    
end