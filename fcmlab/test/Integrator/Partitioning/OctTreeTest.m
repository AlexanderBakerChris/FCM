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
 
classdef OctTreeTest < TestCase
    
    properties
        Partitioner
        Hex
        domainFunctionHandle
    end
    
    methods
        % constructor
        function obj = OctTreeTest(name)
            obj = obj@TestCase(name);
        end
       
        function setUp(obj)
            obj.domainFunctionHandle = @(x,y,z) ...
                2 - (x>=0.0).*(x<=0.1).*(y>=0.0).*(y<=0.1).*(z>=0.0).*(z<=0.1);
            
            embeddedDomain = FunctionHandleDomain(obj.domainFunctionHandle);

            vertices = Vertex.empty(8,0);
            vertices(1) = Vertex([0.0,0.0,0.0]);
            vertices(2) = Vertex([1.0,0.0,0.0]);
            vertices(3) = Vertex([1.0,1.0,0.0]);
            vertices(4) = Vertex([0.0,1.0,0.0]);
            vertices(5) = Vertex([0.0,0.0,1.0]);
            vertices(6) = Vertex([1.0,0.0,1.0]);
            vertices(7) = Vertex([1.0,1.0,1.0]);
            vertices(8) = Vertex([0.0,1.0,1.0]);
        
            lines = [];
            quads = [];
            
            obj.Hex = Hexa(vertices,lines,quads);

            partitionDepth = 3;
            obj.Partitioner = OctTree(embeddedDomain, partitionDepth);
        end
        
        function tearDown(obj)
        end
        
        function testPartition(obj)

            subDomains = obj.Partitioner.partition(obj.Hex);
           
            assertEqual(length(subDomains),22);
        end
        
    end
    
end



