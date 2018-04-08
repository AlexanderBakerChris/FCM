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
 
% Convert global coordinates of a point into indices i,j,k
% roundingFunctionHandle: @ceil will round up - 
%                            used for determining element index
%                         @round will round to the closest integer - 
%                            used for determining closest node to a point

function [i,j,k] = convertCoordinatesIntoIndices(obj,Coords,roundingFunctionHandle)

% Determine indices i,j,k
Coords = Coords - obj.MeshOrigin;
i = roundingFunctionHandle(Coords(1)*(obj.NumberOfXDivisions/obj.Lx)); 

if i > obj.NumberOfXDivisions
    i = obj.NumberOfXDivisions;
end

j = roundingFunctionHandle(Coords(2)*(obj.NumberOfYDivisions/obj.Ly));

if j > obj.NumberOfYDivisions
    j = obj.NumberOfYDivisions;
end

k = roundingFunctionHandle(Coords(3)*(obj.NumberOfZDivisions/obj.Lz));

if k > obj.NumberOfZDivisions
    k = obj.NumberOfZDivisions;
end

end
