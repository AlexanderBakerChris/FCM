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
 
classdef IBeamBoundaryFactoryTest < TestCase
    
    properties
        TestIBeam
        Width
        Height
        Thick1
        Thick2
    end
    
    methods
        
        %% constructor
        function obj = IBeamBoundaryFactoryTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.Width = 3;
            obj.Height = 2.53;
            obj.Thick1 = 0.25;
            obj.Thick2 = 0.3;
            obj.TestIBeam = IBeamBoundaryFactory(obj.Width,obj.Height,obj.Thick1,obj.Thick2);
        end
        
        function tearDown(obj)
        end
        
        function testIBeamBoundary(obj)
            
            IBeamBoundary = obj.TestIBeam.getBoundary;
            
            assertEqual(IBeamBoundary(1).getVertices.getCoords,...
                [0 0 0]);
            
            assertEqual(IBeamBoundary(2).getVertices.getCoords,...
                [(obj.Width-obj.Thick2)/2 0 obj.Thick1]);
            
            assertEqual(IBeamBoundary(3).getVertices.getCoords,...
                [0 0 obj.Height-obj.Thick1]);
            
        end

    end
    
end