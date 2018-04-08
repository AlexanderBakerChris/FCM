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
 
% evaluate nodal modes derivatives in direction r, s and t
%  This function evaluates the nodal modes derivatives with respect to 
%  direction r, s and t at local coordinate.

function NodalModesDeriv = evalNodalModesDeriv(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS)
    
    dN1dr = - 0.125*OneMinusS*OneMinusT;
    dN2dr = - dN1dr; % OneMinusS*OneMinusT
    dN3dr = 0.125*OnePlusS*OneMinusT;
    dN4dr = - dN3dr; % - OnePlusS*OneMinusT
    dN5dr = - 0.125*OneMinusS*OnePlusT;
    dN6dr = - dN5dr; % OneMinusS*OnePlusT
    dN7dr = 0.125*OnePlusS*OnePlusT;
    dN8dr = - dN7dr; % - OnePlusS*OnePlusT
    
    dN1ds = - 0.125*OneMinusR*OneMinusT;
    dN2ds = - 0.125*OnePlusR*OneMinusT;
    dN3ds = - dN2ds; % OnePlusR*OneMinusT;
    dN4ds = - dN1ds; % OneMinusR*OneMinusT
    dN5ds = - 0.125*OneMinusR*OnePlusT;
    dN6ds = - 0.125*OnePlusR*OnePlusT;
    dN7ds = - dN6ds; % OnePlusR*OnePlusT
    dN8ds = - dN5ds; % OneMinusR*OnePlusT
    
    dN1dt = - 0.125*OneMinusR*OneMinusS;
    dN2dt = - 0.125*OnePlusR*OneMinusS;
    dN3dt = - 0.125*OnePlusR*OnePlusS;
    dN4dt = - 0.125*OneMinusR*OnePlusS;
    dN5dt = - dN1dt; % OneMinusR*OneMinsS
    dN6dt = - dN2dt; % OnePlusR*OneMinusS
    dN7dt = - dN3dt; % OnePlusR*OnePlusS
    dN8dt = - dN4dt; % OneMinusR*OnePlusS
    
    NodalModesDeriv = [dN1dr, dN2dr, dN3dr, dN4dr, ...
                       dN5dr, dN6dr, dN7dr, dN8dr, ...
                       dN1ds, dN2ds, dN3ds, dN4ds, ...
                       dN5ds, dN6ds, dN7ds, dN8ds, ...
                       dN1dt, dN2dt, dN3dt, dN4dt, ...
                       dN5dt, dN6dt, dN7dt, dN8dt];
    
end