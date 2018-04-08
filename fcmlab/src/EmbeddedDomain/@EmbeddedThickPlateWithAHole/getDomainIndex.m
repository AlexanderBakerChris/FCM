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
 
% domaiIndex = 1 : Outside
% domaiIndex = 2 : InsidePlate

function domainIndex = getDomainIndex(obj,Coord)

  tolerance = 1E-15;
  
%   Check if inside box
  if Coord(1) > obj.origin(1) - tolerance  &&  Coord(1) < obj.origin(1) + obj.lengths(1) + tolerance ...
          && Coord(2) > obj.origin(2) - tolerance && Coord(2) < obj.origin(2) + obj.lengths(2) + tolerance ...
          && Coord(3) > obj.origin(3) - tolerance && Coord(3) < obj.origin(3) + obj.lengths(3) + tolerance
      %  Check if inside hole
      if norm( [Coord(1) - obj.holeCenter(1) Coord(2) - obj.holeCenter(2)]) < obj.holeRadius
          domainIndex = 1;
      else
          domainIndex = 2;
      end          
  else
      domainIndex = 1;
  end
    
end
