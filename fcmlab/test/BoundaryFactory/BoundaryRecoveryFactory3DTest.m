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

classdef BoundaryRecoveryFactory3DTest  < TestCase
    
    properties
        
        BoundaryRecoveryFactory3D
        Geometry
        BoundingBox
        RecoveredBoundary
        Normals
        PartitionDepth
        
    end
    
    methods
        
        %% constructor
        function obj = BoundaryRecoveryFactory3DTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            
            
            xmin=0.0;
            xmax=1.0;
            ymin=0.0;
            ymax=1.0;
            zmin=0.0;
            zmax=1.0;
            
            
            obj.BoundingBox = [xmin, xmax, ymin, ymax, zmin, zmax];
            
             domainFunctionHandle = @(x,y,z) ...
                2 -   ((x-.5)^2+(y-.5)^2+(z-.5)^2<=0.1);
            
            
            obj.Geometry = FunctionHandleDomain(domainFunctionHandle);
            
            
            obj.PartitionDepth=10;
            
            obj.BoundaryRecoveryFactory3D=BoundaryRecoveryFactory3D(obj.Geometry,obj.BoundingBox,obj.PartitionDepth);
            
        end
                
        function testBoundaryRecovery(obj)
            obj.Normals=obj.BoundaryRecoveryFactory3D.getNormals();
        end
    end
end