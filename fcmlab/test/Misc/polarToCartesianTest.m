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
 
% testing polarToCartesian function

classdef polarToCartesianTest < TestCase
    
    properties
        bx
        by
        ux
        uy
    end
    
    methods
        
        %% constructor
        function obj = polarToCartesianTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.bx = @(x,y) polarToCartesian(x,y,@(r,theta)1/(r*log(2))*cos(theta));
            obj.by = @(x,y) polarToCartesian(x,y,@(r,theta)1/(r*log(2))*sin(theta));
            obj.ux = @(x,y) polarToCartesian(x,y,@(r,theta)0.25*cos(theta));
            obj.uy = @(x,y) polarToCartesian(x,y,@(r,theta)0.25*sin(theta));
        end
        
        function tearDown(obj)
        end
        
        function testBX(obj)
            assertElementsAlmostEqual(obj.bx(1,1),0.7213,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(2,1),0.5771,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(3,1),0.4328,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,2),0.2885,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,3),0.1443,'absolute',1e-3);
        end
        
        function testBY(obj)
            assertElementsAlmostEqual(obj.by(1,1),0.7213,'absolute',1e-3);
            assertElementsAlmostEqual(obj.by(2,1),0.2885,'absolute',1e-3);
            assertElementsAlmostEqual(obj.by(3,1),0.1443,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,2),0.2885,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,3),0.1443,'absolute',1e-3);
        end
        
        function testUX(obj)
            assertElementsAlmostEqual(obj.ux(1,1),0.1768,'absolute',1e-3);
            assertElementsAlmostEqual(obj.ux(2,1),0.2236,'absolute',1e-3);
            assertElementsAlmostEqual(obj.ux(3,1),0.2372,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,2),0.2885,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,3),0.1443,'absolute',1e-3);
        end
        
        function testUY(obj)
            assertElementsAlmostEqual(obj.uy(1,1),0.1768,'absolute',1e-3);
            assertElementsAlmostEqual(obj.uy(2,1),0.1118,'absolute',1e-3);
            assertElementsAlmostEqual(obj.uy(3,1),0.0791,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,2),0.2885,'absolute',1e-3);
            assertElementsAlmostEqual(obj.bx(1,3),0.1443,'absolute',1e-3);
        end

    end
    
end

