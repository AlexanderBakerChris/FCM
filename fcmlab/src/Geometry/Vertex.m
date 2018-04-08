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
 
% handle class for the points
%  This class sets the X, Y and Z coordinate

classdef Vertex < AbsGeometry
    
    methods (Access = public)
         %% constructor
        function obj = Vertex(Coords)
            obj.Coords = Coords;  
           
            if size(Coords,1) ~= 1
                Logger.ThrowException('Error in Vertex Coordinates ... Should be a row vector');
            end
        end
        
         %% get x
        function X = getX(obj)
            X = obj.Coords(1);
        end
        %% get y
        function Y = getY(obj)
            Y = obj.Coords(2);
        end
        %% get z
        function Z = getZ(obj)
            Z = obj.Coords(3);
        end
        %% get coordinate
        function Coords = getCoords(obj)
            Coords = obj.Coords;
        end
        
        %% set coordinates
        function Coords = setCoords(obj, Coords)
            obj.Coords = Coords;
        end
        
        %% get vertices
        function Vertices = getVertices(obj)
            Vertices = obj;        
        end

		%% calculate centroid
        function Centroid = calcCentroid(obj)
            Centroid = obj.getCoords();
        end
		
        %% calculate jacobian
        function J = calcJacobian(obj,LocalCoord)
            J = 1;
        end
        
        %% calculate det jacobian
        function detJ = calcDetJacobian(obj,LocalCoord)
            detJ = 1;
        end
        
        %% map local coordinates to global coordinates
        function GlobalCoords = mapLocalToGlobal(obj,LocalCoords)
            GlobalCoords = obj.getCoords;
        end
        
        %% map global coordinates to local coordinates
        function LocalCoords = mapGlobalToLocal(obj,GlobalCoords)
            LocalCoords = 0;
        end
        
    end
    
    properties (Access = public)
        Coords
    end
    
end

