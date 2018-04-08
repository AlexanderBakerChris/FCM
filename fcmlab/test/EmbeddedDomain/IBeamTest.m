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
 

classdef IBeamTest < TestCase
    
    properties
        TestDomain
    end
    
    methods
        
        %% constructor
        function obj = IBeamTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.TestDomain = IBeam(20,200,30,5,5,[50,5; 100 3.5; 175 2.5]);
        end
        
        function tearDown(obj)
        end
        
        function testDomain(obj)
            % points with highest and lowest coordinates inside the getDomainIndex
            assertEqual(obj.TestDomain.getDomainIndex([0 0 0]),2);
            assertEqual(obj.TestDomain.getDomainIndex([20 200 5]),2);
            % point at boundary of girder
            assertEqual(obj.TestDomain.getDomainIndex([7 100 5]),2);
            % point inside the upper flange
            assertEqual(obj.TestDomain.getDomainIndex([14 50 30]),2);
            % point inside of the box, but outside the getDomainIndex
            assertEqual(obj.TestDomain.getDomainIndex([14 50 20]),1);
            % point at boundary of a circular hole
            assertEqual(obj.TestDomain.getDomainIndex([10 175 17.5]),2);
            % point inside a circular hole
            assertEqual(obj.TestDomain.getDomainIndex([8 98 16]),1);
        end

    end
    
end

