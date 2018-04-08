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
 
% Determines the value of the material ID at a specific global coordinate
% The search-domain consists of the voxel-mesh
% domainIndex = 1: void (alpha << 1)   
% domainIndex = 2: actual material domain (alpha=1)
% Corresponding materials need to be predefined

function domainIndex = getDomainIndex(obj,Coord)  
    Coord = (Coord-obj.VoxelOffset);
    DomainSize = size(obj.CTData).*obj.VoxelSpacing;
    if max(Coord<0)>0
        domainIndex = 1;
    elseif max(Coord>DomainSize)>0
        domainIndex = 1;
    else
        Index = ceil(Coord./obj.VoxelSpacing);
        for i=1:3
            if Index(i) == 0
                Index(i) = 1;
            end
        end
        if obj.CTData(Index(1),Index(2),Index(3))>0
            domainIndex = 2;
        else
            domainIndex = 1;
        end
    end
    
end
