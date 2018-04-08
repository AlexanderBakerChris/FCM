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
 
% Check that a point is a node of the mesh
function IsNode = checkPointIsNode(obj,Coords)
    
    IsNode = true;
    Coords = Coords - obj.MeshOrigin;
   
    % Out of range?
    if ( Coords(1) >obj.Lx || ...
         Coords(2) >obj.Ly || ...
         Coords(3) >obj.Lz )
        IsNode = false;
    end
    
    % Negative values in the input ?
    if ( Coords(1) <0 || ...
         Coords(2) <0 || ...
         Coords(3) <0 )
        IsNode = false;
    end
    
    % Is a real node?
    i = mod(Coords(1),(obj.Lx/obj.NumberOfXDivisions));
    j = mod(Coords(2),(obj.Ly/obj.NumberOfYDivisions)); 
    k = mod(Coords(3),(obj.Lz/obj.NumberOfZDivisions)); 
   
    tolerance = 1e-8; 
    if ( ( i > tolerance && (obj.Lx/obj.NumberOfXDivisions) - i > tolerance ) || ...
         ( j > tolerance && (obj.Ly/obj.NumberOfYDivisions) - j > tolerance ) || ...
         ( k > tolerance && (obj.Lz/obj.NumberOfZDivisions) - k > tolerance ) )
        IsNode = false;
    end
end
