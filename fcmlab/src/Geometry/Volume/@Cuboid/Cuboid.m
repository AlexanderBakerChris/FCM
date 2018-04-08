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
 
%Handle class for cuboid (uses functions of Hexa)

classdef  Cuboid < AbsVolume
    
    methods (Access = public)
        %% constructor
        function obj = Cuboid(Vertices,Lines,Quads)
            obj = obj@AbsVolume(Vertices,Lines,Quads);
            
            lengths(1) = obj.Vertices(2).getX() - obj.Vertices(1).getX();
            lengths(2) = obj.Vertices(3).getY() - obj.Vertices(2).getY();
            lengths(3) = obj.Vertices(5).getZ() - obj.Vertices(1).getZ();
            
            obj.jacobian = 0.5 * diag( lengths );
            
            obj.center = obj.Vertices(1).getCoords() + 0.5 * lengths;
            
            obj.inverseJacobian = inv(obj.jacobian);
            
            obj.detJacobian = det(obj.jacobian);
        end
        
        %% calculate base vector1
        function g1 = calcBaseVector1(obj,LocalCoords)
            g1 = obj.jacobian(1,:);
        end
        
        %% calculate base vector2
        function g2 = calcBaseVector2(obj,LocalCoords)
            g2 = obj.jacobian(2,:);
        end
        
        %% calculate base vector3
        function g3 = calcBaseVector3(obj,LocalCoords)
            g3 = obj.jacobian(3,:);
        end
        
        %% calculate jacobian
        function J = calcJacobian(obj,LocalCoords)
            J = obj.jacobian;
        end
        
        %% calculate det jacobian
        function detJ = calcDetJacobian(obj,LocalCoords)
            detJ = obj.detJacobian;
        end
        
        %% calculate centroid
        function centroid = calcCentroid(obj)
            for i = 1:length(obj.Vertices)
                Coords(i,:) = obj.Vertices(i).getCoords;
            end
            centroid = mean(Coords);
        end
        
        %% map local coordinates to global coordinates
        function globalCoords = mapLocalToGlobal(obj,LocalCoords)
             globalCoords =  LocalCoords * obj.jacobian + obj.center;
        end
        
        %% Map global coordinates to local coordinates
        function localCoords = mapGlobalToLocal(obj,GlobalCoords)
            localCoords = (GlobalCoords - obj.center) * obj.inverseJacobian; 
        end
        
    end
    
    properties (Access = private)
        myHexa
        jacobian
        inverseJacobian
        detJacobian
        center % at (r, s, t) = (0, 0, 0)
    end
    
end

