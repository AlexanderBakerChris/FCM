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
 
classdef BoundaryRecoveryFactoryTest  < TestCase
    
    properties
        
        BoundaryRecoveryFactory
        Geometry
        BoundingBox
        RecoveredBoundary
        PartitionDepth
        SeedPoints
        BoundaryNormals
        
    end
    
    methods
        
        %% constructor
        function obj = BoundaryRecoveryFactoryTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            
            vertex1 = Vertex([0.0 0.0 0.0]);
            vertex2 = Vertex([1.0 0.0 0.0]);
            vertex3 = Vertex([1.0 1.0 0.0]);
            vertex4 = Vertex([0.0 1.0 0.0]);
            
            line1 = Line(vertex1,vertex2);
            line2 = Line(vertex2,vertex3);
            line3 = Line(vertex3,vertex4);
            line4 = Line(vertex4,vertex1);
            
            obj.BoundingBox = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);
            
            domainFunctionHandle = @(x,y,z) ...
                2 - ((x+y)<0.3125);
            
            obj.Geometry = FunctionHandleDomain(domainFunctionHandle);
            
            obj.PartitionDepth=3;
            obj.SeedPoints=0;
            obj.BoundaryRecoveryFactory=BoundaryRecoveryFactory(obj.Geometry,obj.BoundingBox,obj.PartitionDepth,obj.SeedPoints);
            
        end
        
        function tearDown(obj)
        end
        
        function testBoundaryRecovery(obj)            
            
            obj.RecoveredBoundary = obj.BoundaryRecoveryFactory.getBoundaryWithVisual();
            obj.BoundaryNormals=obj.BoundaryRecoveryFactory.getNormalsWithVisual();
            
            assertEqual(length(obj.RecoveredBoundary),5);
            
           assertEqual(length(obj.BoundaryNormals),10);
            
        end
    end
end