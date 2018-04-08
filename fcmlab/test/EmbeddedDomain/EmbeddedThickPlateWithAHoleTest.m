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
 
classdef EmbeddedThickPlateWithAHoleTest < TestCase
    
    properties  
        origin;
        lengths;
        holeCenter;
        holeRadius;
        EmbeddedDomain;
    end
    
    methods
        % constructor
        function obj = EmbeddedThickPlateWithAHoleTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.origin = [-1.6 3.4 7.2];
            width = 23;
            height = 17.4;
            thickness = 0.3;
            obj.lengths = [width height thickness];
            obj.holeCenter = [obj.origin(1) + 0.75 * width 
                              obj.origin(2) + 0.75 * height ];
            obj.holeRadius = 0.9;
            
            obj.EmbeddedDomain = EmbeddedThickPlateWithAHole(obj.origin,...
               obj.lengths, obj.holeCenter, obj.holeRadius);
        end
        
        function tearDown(obj)
        end
        
        function testGetDomainIndex(obj)
            delta = 0.0001;
            
%           Points outside the box           
            point = [obj.origin(1) - delta 
                     obj.origin(2) + 0.5 * obj.lengths(2)
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
            
            
            point = [obj.origin(1) + obj.lengths(1) + delta 
                     obj.origin(2) + 0.5 * obj.lengths(2) 
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
  
            point = [obj.origin(1) + 0.5 * obj.lengths(1) 
                     obj.origin(2) - delta  
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
            
            point = [obj.origin(1) + 0.5 * obj.lengths(1) 
                     obj.origin(2) + obj.lengths(2) + delta   
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
  

            point = [obj.origin(1) + 0.5* obj.lengths(1) 
                     obj.origin(2) + 0.5* obj.lengths(2) 
                     obj.origin(3) - delta];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);

            
            point = [obj.origin(1) + 0.5* obj.lengths(1) 
                     obj.origin(2) + 0.5* obj.lengths(2) 
                     obj.origin(3) + obj.lengths(3) + delta];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
            
%             Points inside the hole

            point = [obj.holeCenter(1) + delta
                     obj.holeCenter(2) 
                     obj.origin(3) + 0.5 * obj.lengths(3)];
                 
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
            
            point = [obj.holeCenter(1) 
                     obj.holeCenter(2) + delta
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
            
            point = [obj.holeCenter(1) + 0.5 * sqrt(2) * (obj.holeRadius - delta)
                     obj.holeCenter(2) + 0.5 * sqrt(2) * (obj.holeRadius - delta)
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 1);
                 
%             Points inside the plate

            point = [obj.holeCenter(1) + 0.5 * sqrt(2) * (obj.holeRadius + delta)
                     obj.holeCenter(2) + 0.5 * sqrt(2) * (obj.holeRadius + delta)
                     obj.origin(3) + 0.5 * obj.lengths(3)];
            
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 2);
            
            point = [obj.origin(1) + 0.25 * obj.lengths(1)
                     obj.origin(2) + 0.25 * obj.lengths(2)
                     obj.origin(3) + 0.25 * obj.lengths(3)];
                 
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 2);
            
            point = [obj.origin(1) + 0.50 * obj.lengths(1)
                     obj.origin(2) + 0.25 * obj.lengths(2)
                     obj.origin(3) + 0.85 * obj.lengths(3)];
                 
            assertEqual(obj.EmbeddedDomain.getDomainIndex( point ), 2);
            
        end
    end
    
end

