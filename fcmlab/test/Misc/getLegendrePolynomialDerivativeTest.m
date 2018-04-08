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
 
% testing getLegendrePolynomial function

classdef getLegendrePolynomialDerivativeTest < TestCase
    
    properties
        MyLegendrePolynomialDerivative
    end
    
    methods
        
        %% constructor
        function obj = getLegendrePolynomialDerivativeTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.MyLegendrePolynomialDerivative = zeros(1,21);
            for i = 1:21
                obj.MyLegendrePolynomialDerivative(i) = getLegendrePolynomialDerivative(1,i-1);
            end
        end
        
        function tearDown(obj)
        end
        
        function testGetLegendrePolynomialDerivative(obj)
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(1),0,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(2),1,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(3),3,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(4),6,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(5),10,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(6),15,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(7),21,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(8),28,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(9),36,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(10),45,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(11),55,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(12),66,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(13),78,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(14),91,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(15),105,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(16),120,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(17),136,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(18),153,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(19),171,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(20),190,'absolute',1e-3);
            assertElementsAlmostEqual(obj.MyLegendrePolynomialDerivative(21),210,'absolute',1e-3);
        end

    end
    
end

