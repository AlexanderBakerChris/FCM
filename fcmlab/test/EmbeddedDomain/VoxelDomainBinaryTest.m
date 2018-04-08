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
 
% testing of class VoxelDomainSTLBoundaryTest

classdef VoxelDomainBinaryTest < TestCase
    
    properties
        TestDomain;
        origin;
        sideLengths;
    end
    
    methods
        
        %% constructor
        function obj = VoxelDomainBinaryTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
%             numberOfVoxelsPerDimension = [270,100,400]; 
%             
%             obj.origin = [-13.9 11.2 -6];
%             obj.sideLengths = [9.75 3.21 29.1] - obj.origin;
%             
%             obj.TestDomain = VoxelDomainBinary('blade_mesh270x100x400_mesh_char.raw', numberOfVoxelsPerDimension, obj.sideLengths, obj.origin);
        end
        
        function tearDown(obj)
        end
        
        function testDomain(obj)
%             assertEqual(obj.TestDomain.getDomainIndex(obj.origin),1);
%             assertEqual(obj.TestDomain.getDomainIndex(obj.origin + obj.sideLengths),1);
% %             assertEqual(obj.TestDomain.getDomainIndex(obj.origin + [0.5 .66 0.5].*obj.sideLengths),2);
            
        end

    end
    
end

