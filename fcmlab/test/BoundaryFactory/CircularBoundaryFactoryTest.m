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
 
classdef CircularBoundaryFactoryTest < TestCase
    
    properties
        TestCircle
        CircleCenter
        CircleRadius
        CircleDivisions
        
        TestHole
        HoleCenter
        HoleRadius
        HoleDivisions
    end
    
    methods
        
        %% constructor
        function obj = CircularBoundaryFactoryTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.CircleCenter = [0 0];
            obj.CircleRadius = 5.8;
            obj.CircleDivisions = 400;
            obj.TestCircle = CircularBoundaryFactory(obj.CircleCenter,obj.CircleRadius,obj.CircleDivisions,true);
            
            obj.HoleCenter = [0.5 -0.83];
            obj.HoleRadius = 18;
            obj.HoleDivisions = 200;
            obj.TestHole = CircularBoundaryFactory(obj.HoleCenter,obj.HoleRadius,obj.HoleDivisions,false);
        end
        
        function tearDown(obj)
        end
        
        function testCircleBoundary(obj)
            
            CircleBoundary = obj.TestCircle.getBoundary;
            
            assertElementsAlmostEqual(CircleBoundary(1).getVertices.getCoords,...
                [obj.CircleCenter(1)+obj.CircleRadius obj.CircleCenter(2) 0],'absolute',1E-1);
            
            assertElementsAlmostEqual(CircleBoundary(obj.CircleDivisions/4).getVertices.getCoords,...
                [obj.CircleCenter(1) obj.CircleCenter(2)+obj.CircleRadius 0],'absolute',1E-1);
            
            assertElementsAlmostEqual(CircleBoundary(obj.CircleDivisions/2).getVertices.getCoords,...
                [obj.CircleCenter(1)-obj.CircleRadius obj.CircleCenter(2) 0],'absolute',1E-1);
            
            assertElementsAlmostEqual(CircleBoundary(obj.CircleDivisions*3/4).getVertices.getCoords,...
                [obj.CircleCenter(1) obj.CircleCenter(2)-obj.CircleRadius 0],'absolute',1E-1);
            
            assertElementsAlmostEqual(CircleBoundary(obj.CircleDivisions).getVertices.getCoords,...
                [obj.CircleCenter(1)+obj.CircleRadius obj.CircleCenter(2) 0],'absolute',1E-1);
            
        end
        
        function testHoleBoundary(obj)
            
            HoleBoundary = obj.TestHole.getBoundary;
            
            assertElementsAlmostEqual(HoleBoundary(1).getVertices.getCoords,...
                [obj.HoleCenter(1)+obj.HoleRadius obj.HoleCenter(2) 0],'absolute',1);
            
            assertElementsAlmostEqual(HoleBoundary(obj.HoleDivisions/4).getVertices.getCoords,...
                [obj.HoleCenter(1) obj.HoleCenter(2)-obj.HoleRadius 0],'absolute',1);
            
            assertElementsAlmostEqual(HoleBoundary(obj.HoleDivisions/2).getVertices.getCoords,...
                [obj.HoleCenter(1)-obj.HoleRadius obj.HoleCenter(2) 0],'absolute',1);
            
            assertElementsAlmostEqual(HoleBoundary(obj.HoleDivisions*3/4).getVertices.getCoords,...
                [obj.HoleCenter(1) obj.HoleCenter(2)+obj.HoleRadius 0],'absolute',1);
            
            assertElementsAlmostEqual(HoleBoundary(obj.HoleDivisions).getVertices.getCoords,...
                [obj.HoleCenter(1)+obj.HoleRadius obj.HoleCenter(2) 0],'absolute',1);
            
        end

    end
    
end