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
 
%% map global coordinates to local coordinates
function LocalCoords = mapGlobalToLocal(obj,GlobalCoords)

Tolerance = 10E-12;
X1 = obj.Vertices(1).getX;
X2 = obj.Vertices(2).getX;

Y1 = obj.Vertices(1).getY;
Y2 = obj.Vertices(2).getY;

Z1 = obj.Vertices(1).getZ;
Z2 = obj.Vertices(2).getZ;

if ~(abs(X1 - X2)<Tolerance)
    LocalCoords =(2*GlobalCoords(1)-X1-X2)/(X2-X1);
elseif ~(abs(Y1 - Y2)<Tolerance)
    LocalCoords =(2*GlobalCoords(2)-Y1-Y2)/(Y2-Y1);
else
    LocalCoords =(2*GlobalCoords(3)-Z1-Z2)/(Z2-Z1);
end

%Check other 2 coords - throw an error if different
% Also, this workds only if x1 and x2 are not equal (Line not
% in zy plane)

end