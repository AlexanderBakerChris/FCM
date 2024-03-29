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
 
% Abstract class for volumes
%   (hexa, cuboid)
classdef AbsVolume < AbsGeometry
    
    methods (Access = public)
        %% constructor
        function obj = AbsVolume(Vertices,Lines,Quads)
            obj.Lines = Lines;
            obj.Vertices = Vertices;
            obj.Quads = Quads;
        end
        
        %% get Vertices
        function Vertices = getVertices(obj)
            Vertices = obj.Vertices;
        end
        
        %% get Lines
        function Lines = getLines(obj)
            Lines = obj.Lines;
        end
        
        %% get Quads
        function Quads = getQuads(obj)
            Quads = obj.Quads;
        end
        
        %% get Vertices coordinates
        function verticesCoordinates = getVerticesCoordinates(obj)
            verticesCoordinates =  vertcat(obj.Vertices.Coords);
        end
        
    end
    
    methods (Abstract, Access = public)
        g1 = calcBaseVector1(obj,LocalCoords);
        g2 = calcBaseVector2(obj,LocalCoords);
        g3 = calcBaseVector3(obj,LocalCoords);
        Centroid = calcCentroid(obj);
    end
    
    properties (Access = protected)
        Quads
        Lines
        Vertices
    end
    
end