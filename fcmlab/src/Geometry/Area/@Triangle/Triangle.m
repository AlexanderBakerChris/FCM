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
 
% Class for the triangles

classdef Triangle < AbsArea
    
    methods (Access = public)
        %% constructor
        function obj = Triangle(Vertices,Lines)
            obj = obj@AbsArea(Vertices,Lines);
            % Vertices and Lines are vectors of 3 entries each
            obj.Vertices = [Vertices(1) Vertices(2) Vertices(3) Vertices(3)]; % take vertex 3 twice
            obj.Lines = [Lines(1) Lines(2) Line(Vertices(3),Vertices(3)) Lines(3)]; % collapse line 3 of the quad and take line3 of the triangle for the quad
            obj.MyQuad = Quad(obj.Vertices,obj.Lines);
        end
        
        %% calculate base vector1
        function g1 = calcBaseVector1(obj,LocalCoords)
            g1 = obj.MyQuad.calcBaseVector1(LocalCoords);
        end
        
        %% calculate base vector2
        function g2 = calcBaseVector2(obj,LocalCoords)
            g2 = obj.MyQuad.calcBaseVector2(LocalCoords);
        end
        
        %% calculate jacobian
        function J = calcJacobian(obj,LocalCoords)
            J = obj.MyQuad.calcJacobian(LocalCoords);
        end
        
        %% calculate det jacobian
        function detJ = calcDetJacobian(obj,LocalCoords)
            detJ = obj.MyQuad.calcDetJacobian(LocalCoords);
        end
        
        %% calculate normal vector
        function NormalVector = calcNormalVector(obj,LocalCoords)
            NormalVector = obj.MyQuad.calcNormalVector(LocalCoords);
        end
        
        %% map local coordinates to global coordinates
        function GlobalCoords = mapLocalToGlobal(obj,LocalCoords)
            GlobalCoords = obj.MyQuad.mapLocalToGlobal(LocalCoords);
        end
        
        %% map global coordinates to local coordinates
        function LocalCoords = mapGlobalToLocal(obj,GlobalCoords)
            Logger.ThrowException('Not Implemented :(');
        end
        
    end
    
    properties (Access = private)
        MyQuad % a triangle is a special quad with 2 vertices at the same position
    end
    
end

