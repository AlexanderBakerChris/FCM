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
 
% Class for the rectangle
%   ACHTUNG! rectangle must be aligned with x and y axis
%   if not, use Quad
%   4 ------- 3
%   |         |
%   1 ------- 2

classdef Rectangle < AbsArea
    
    methods (Access = public)
        %% constructor
        function obj = Rectangle(Vertices,Lines)
            obj = obj@AbsArea(Vertices,Lines);
            obj.MyQuad = Quad(Vertices,Lines);
            
            if (~ obj.isRectangle)
                Logger.ThrowException('Error : the input does not correspond to a rectangle.');
            end
            
            g1 = obj.MyQuad.calcBaseVector1([0 0]);
            g2 = obj.MyQuad.calcBaseVector2([0 0]);
            
            obj.Jacobian = [g1; g2];
            obj.detJacobian = norm(cross(g1,g2));
            
        end
        
        Rectangle = isRectangle(obj);
        
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
            J = obj.Jacobian;
        end
        
        %% calculate det jacobian
        function detJ = calcDetJacobian(obj,LocalCoords)
            detJ = obj.detJacobian;
        end
        
        %% calculate normal vector
        function NormalVector = calcNormalVector(obj,LocalCoords)
            NormalVector = obj.MyQuad.calcNormalVector(LocalCoords);
        end
        
        %% map local coordinates to global coordinates
        function GlobalCoords = mapLocalToGlobal(obj,LocalCoords)
            GlobalCoords = obj.MyQuad.mapLocalToGlobal(LocalCoords);
        end
        
        LocalCoords = mapGlobalToLocal(obj,GlobalCoords);
        
    end
    
    properties (Access = private)
        MyQuad
        detJacobian
        Jacobian
    end
    
end

