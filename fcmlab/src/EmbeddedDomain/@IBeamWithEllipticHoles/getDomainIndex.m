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
 
% Domain Index of a Coordinate 
% This function defines the domain of the beam and gives back a 1 if a
% coordinate is outside the beam or a 2 if it is inside the beam

function domainIndex = getDomainIndex(obj,Coord)
    % Point inside box of width*height*length?
    if (max(Coord > [obj.Width obj.Length obj.Height])>0 || max(Coord < 0)>0)
        domainIndex = 1;
    % Point inside the flanges?
    elseif (Coord(3)<=obj.Thick1 || Coord(3)>=obj.Height-obj.Thick1)
        domainIndex = 2;
    % Point inside the girder?
    elseif (Coord(1)>=(obj.Width-obj.Thick2)/2 && Coord(1)<=(obj.Width+obj.Thick2)/2)
        domainIndex = 2;
        
        % Point inside a circle? (->outside of beam)
        for i = 1:obj.numberOfHoles
            
            center = [ i*obj.d + (i-1)*2*obj.a + obj.a, 0.5*obj.Height];
            
            x = Coord(2)-center(1);
            y = Coord(3)-center(2);
            r = x*x/(obj.a*obj.a) + y*y/(obj.b*obj.b);
            
            if( r <= 1  )
                domainIndex  = 1;
                break;
            end
        end
        
    else
        domainIndex = 1;
    end
 end
