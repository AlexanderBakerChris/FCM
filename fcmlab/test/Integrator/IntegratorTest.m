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
 
classdef IntegratorTest < TestCase
    
    properties
        size
        handle
        embeddedDomain
        Integrator
    end
    
    methods
        %% constructor
        function obj = IntegratorTest(name)
            obj = obj@TestCase(name);
        end
        
        %% setUp
        function setUp(obj)
            obj.size = 0.5;
            obj.handle = @(x,y,z) ~(abs(x) < obj.size && ...
                                    abs(y) < obj.size && ...
                                    abs(z) < obj.size );
            obj.embeddedDomain = FunctionHandleDomain(obj.handle);
        end
        
        %% tearDown
        function tearDown(obj)
        end
        
        %% integrateLineTest
        function integrateLineTest(obj)
            a = 0.3;
            b = 4.4;
            vertex1 = [a,0,0];
            vertex2 = [b,0,0];
            
            line = Line(vertex1,vertex2);
            
            integrationOrder = 3;
            
            integrator = Integrator(NoPartition,integrationOrder);

            constantFunction = @(Coords) 1;
            
            result = integrator.integrate(constantFunction,line);
            
            assertElementsAlmostEqual(result,(b-a),'absolute',1.0e-12);
        end
        
        %% integratePartitionedLineTest
        function integratePartitionedLineTest(obj)
            a = 0.0;
            b = 4.4;
            vertex1 = [a,0,0];
            vertex2 = [b,0,0];
            
            line = Line(vertex1,vertex2);
            
            integrationOrder = 3;
            
            treeDepth = 4;
            partitioner = BinaryTree(obj.embeddedDomain,treeDepth);
            
            integrator = Integrator(partitioner,integrationOrder);

            constantFunction = @(Coords) 1;
            
            result = integrator.integrate(constantFunction,line);
            
            assertElementsAlmostEqual(result,(b-a),'absolute',1.0e-12);
        end

        %% integrateLineWithAHoleTest
        function integrateLineWithAHoleTest(obj)
            a = -1.0;
            b = 1.0;
            vertex1 = [a,0,0];
            vertex2 = [b,0,0];
            
            line = Line(vertex1,vertex2);
            
            integrationOrder = 1;
            
            treeDepth = 2;
            partitioner = BinaryTree(obj.embeddedDomain,treeDepth);
            
            integrator = Integrator(partitioner,integrationOrder);

            constantFunction = @(Coords) obj.handle(Coords(1),Coords(2),Coords(3));
            
            result = integrator.integrate(constantFunction,line);
            
            assertElementsAlmostEqual(result,(b-a)-2*obj.size,'relative',1.0e-4);
        end

        %% integrateQuadTest
        function integrateQuadTest(obj)
            width = 1.23;
            height = 3.45;
            
            vertex1 = Vertex([0,0,0]);
            vertex2 = Vertex([width,0,0]);
            vertex3 = Vertex([width,height,0]);
            vertex4 = Vertex([0,height,0]);

            quad = Quad([vertex1, vertex2, vertex3, vertex4],[]);
            
            integrationOrder = 3;
            
            integrator = Integrator(NoPartition,integrationOrder);

            constantFunction = @(Coords) ones(size(Coords,1),1);
            
            result = integrator.integrate(constantFunction,quad);
            
            assertElementsAlmostEqual(result,width*height,'absolute',1.0e-12);
        end

        %% integratePartitionedQuadTest
        function integratePartitionedQuadTest(obj)
            width = 1.23;
            height = 3.45;
            
            vertex1 = Vertex([0,0,0]);
            vertex2 = Vertex([width,0,0]);
            vertex3 = Vertex([width,height,0]);
            vertex4 = Vertex([0,height,0]);

            quad = Quad([vertex1, vertex2, vertex3, vertex4],[]);
            
            integrationOrder = 3;
            
            treeDepth = 4;
            partitioner = QuadTree(obj.embeddedDomain,treeDepth);

            integrator = Integrator(partitioner,integrationOrder);

            constantFunction = @(Coords) ones(size(Coords,1),1);
            
            result = integrator.integrate(constantFunction,quad);
            
            assertElementsAlmostEqual(result,width*height,'absolute',1.0e-12);
        end
        
        %% integrateQuadWithAHoleTest
        function integrateQuadWithAWholeTest(obj)
            vertex1 = Vertex([-1,-1,0]);
            vertex2 = Vertex([1,-1,0]);
            vertex3 = Vertex([1,1,0]);
            vertex4 = Vertex([-1,1,0]);

            quad = Quad([vertex1, vertex2, vertex3, vertex4],[]);
            
            integrationOrder = 1;
            
            treeDepth = 2;
            partitioner = QuadTree(obj.embeddedDomain,treeDepth);

            integrator = Integrator(partitioner,integrationOrder);

            constantFunction = @(Coords) obj.handle(Coords(1),Coords(2),Coords(3));
            
            result = integrator.integrate(constantFunction,quad);
            
            assertElementsAlmostEqual(result,4.0-(2*obj.size)^2,'relative',1.0e-4);
        end
        
        %% integrateHexTest
        function integrateHexTest(obj)
            width = 1.23;
            height = 3.45;
            depth = 4.56;
            
            vertex1 = Vertex([0,0,0]);
            vertex2 = Vertex([width,0,0]);
            vertex3 = Vertex([width,height,0]);
            vertex4 = Vertex([0,height,0]);
            vertex5 = Vertex([0,0,depth]);
            vertex6 = Vertex([width,0,depth]);
            vertex7 = Vertex([width,height,depth]);
            vertex8 = Vertex([0,height,depth]);

            hex = Hexa([vertex1, vertex2, vertex3, vertex4, vertex5, ...
                vertex6, vertex7, vertex8],[],[]);
            
            integrationOrder = 3;
            
            integrator = Integrator(NoPartition,integrationOrder);

            constantFunction = @(Coords) 1;
            
            result = integrator.integrate(constantFunction,hex);
            
            assertElementsAlmostEqual(result,width*height*depth,'absolute',1.0e-12);
        end

        %% integratePartitionedHexTest
        function integratePartitionedHexTest(obj)
            width = 1.23;
            height = 3.45;
            depth = 4.56;
            
            vertex1 = Vertex([0,0,0]);
            vertex2 = Vertex([width,0,0]);
            vertex3 = Vertex([width,height,0]);
            vertex4 = Vertex([0,height,0]);
            vertex5 = Vertex([0,0,depth]);
            vertex6 = Vertex([width,0,depth]);
            vertex7 = Vertex([width,height,depth]);
            vertex8 = Vertex([0,height,depth]);

            hex = Hexa([vertex1, vertex2, vertex3, vertex4, vertex5, ...
                vertex6, vertex7, vertex8],[],[]);
            
            integrationOrder = 3;
            
            treeDepth = 3;
            partitioner = OctTree(obj.embeddedDomain,treeDepth);

            integrator = Integrator(partitioner,integrationOrder);

            constantFunction = @(Coords) 1;
            
            result = integrator.integrate(constantFunction,hex);
            
            assertElementsAlmostEqual(result,width*height*depth,'absolute',1.0e-12);
        end

        %% integrateHexWithAHoleTest
        function integrateHexWithAHoleTest(obj)
            vertices = Vertex.empty(8,0);
            vertices(1) = Vertex([-1,-1,-1]);
            vertices(2) = Vertex([ 1,-1,-1]);
            vertices(3) = Vertex([ 1, 1,-1]);
            vertices(4) = Vertex([-1, 1,-1]);
            vertices(5) = Vertex([-1,-1, 1]);
            vertices(6) = Vertex([ 1,-1, 1]);
            vertices(7) = Vertex([ 1, 1, 1]);
            vertices(8) = Vertex([-1, 1, 1]);

            hex = Hexa(vertices,[],[]);
            
            integrationOrder = 1;
            
            treeDepth = 2;
            partitioner = OctTree(obj.embeddedDomain,treeDepth);

            integrator = Integrator(partitioner,integrationOrder);

            constantFunction = @(Coords) obj.handle(Coords(1),Coords(2),Coords(3));
            
            result = integrator.integrate(constantFunction,hex);
            
            assertElementsAlmostEqual(result,8-(2*obj.size)^3,'absolute',1.0e-12);
        end

    end
    
end

