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
 
% testing of class ElasticQuad

classdef ElasticQuadTest < TestCase
    
    properties
        Elem
        Elem2
        Integrator
        PolynomialOrder
        DofDimension
        EdgeLineCoordTest
    end
    
    methods
        
        %% constructor
        function obj = ElasticQuadTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            % test with an element of polynomial degree of 2
            % width in x = 2, height in y = 3
            % E = 5, Poisson's ratio = 0.2
            Mat2D(1) = HookePlaneStress(5,0.2,1,1e-20);
            Mat2D(2) = HookePlaneStress(5,0.2,1,1); 
            obj.Integrator = Integrator(QuadTree(TestCircularDomain,5),4);
            obj.PolynomialOrder = 2;
            obj.DofDimension = 2;
            
            Node1 = Node([3 5 0],7);
            Node2 = Node([5 5 0],8);
            Node3 = Node([5 8 0],9);
            Node4 = Node([3 8 0],10);
            
            Edge1 = Edge([Node1 Node2],2,2);
            Edge2 = Edge([Node2 Node3],2,2);
            Edge3 = Edge([Node3 Node4],2,2);
            Edge4 = Edge([Node4 Node1],2,2);
            
            Face1 = Face([Node1 Node2 Node3 Node4], [Edge1 Edge2 Edge3 Edge4],2,2);

            obj.Elem = ElasticQuad([Node1 Node2 Node3 Node4], [Edge1 Edge2 Edge3 Edge4],...
                Face1, Mat2D(2),obj.Integrator,obj.PolynomialOrder,obj.DofDimension,PseudoDomain());  
            
            % needed for the test of the line mapping
            CenterNode = Node([4 6.5 0],2);
            obj.EdgeLineCoordTest = Edge([Node1 CenterNode],1,3);
            
            % element for domain integration in FCM
            obj.Elem2 = ElasticQuad([Node1 Node2 Node3 Node4], [Edge1 Edge2 Edge3 Edge4],...
                Face1, Mat2D,obj.Integrator,obj.PolynomialOrder,obj.DofDimension,TestCircularDomain());
        end
        
        function tearDown(obj)
        end
        
        %% test calcuation of Jacobian
        function testJacobian(obj)
            assertEqual(obj.Elem.calcJacobian([0 0 0]), [1 0 0; 0 1.5 0]);
        end   

        %% test mapping from global to local coordinate system
        function testMapGlobalToLocalCoords(obj)
            assertVectorsAlmostEqual(obj.Elem.mapGlobalToLocal([4 6.5]), [0 0 ]);
            assertVectorsAlmostEqual(obj.Elem.mapGlobalToLocal([3.5 7]), [-0.5 1/3 ]);
        end
        
        %% test mapping from local to global coordinate system
        function testMapLocalToGlobalCoords(obj)
            assertVectorsAlmostEqual(obj.Elem.mapLocalToGlobal([0 0]), [4 6.5 0]);
            assertVectorsAlmostEqual(obj.Elem.mapLocalToGlobal([-0.5 1/3]), [3.5 7 0]);
        end
        
        %% test evaluation of shape functions
        function testGetShapeFunctionsVector(obj)
            NTest1 = obj.Elem.evalShapeFunct([0 0]);
            
            assertElementsAlmostEqual([NTest1 NTest1], [0.25 0.25 0.25 0.25 ...
                -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 3/8 0.25 0.25 0.25 0.25 ...
                -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 3/8]);
            
            NTest2 = obj.Elem.evalShapeFunct([0.5 0.25]);
            
            assertElementsAlmostEqual([NTest2 NTest2], [3/32 9/32 15/32 5/32 ...
                -9*sqrt(6)/128 -45*sqrt(6)/256 -15*sqrt(6)/128 -15*sqrt(6)/256 9*15/512 3/32 9/32 15/32 5/32 ...
                -9*sqrt(6)/128 -45*sqrt(6)/256 -15*sqrt(6)/128 -15*sqrt(6)/256 9*15/512]);
        end
        
        function testGetShapeFunctionsMatrix(obj)
            assertElementsAlmostEqual(obj.Elem.getShapeFunctionsMatrix([0 0]), [0.25 0.25 0.25 0.25 -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 3/8 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0.25 0.25 0.25 0.25 -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 -sqrt(6)/8 3/8]);
            assertElementsAlmostEqual(obj.Elem.getShapeFunctionsMatrix([0.5 0.25]), [3/32 9/32 15/32 5/32 -9*sqrt(6)/128 -45*sqrt(6)/256 -15*sqrt(6)/128 -15*sqrt(6)/256 9*15/512 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 3/32 9/32 15/32 5/32 -9*sqrt(6)/128 -45*sqrt(6)/256 -15*sqrt(6)/128 -15*sqrt(6)/256 9*15/512]);
        end
        
        %% test evaluation of shape function derivatives
        function testGetShapeFunctionsDerivativeVector(obj)
            dN1 = obj.Elem.evalDerivOfShapeFunct([0 0]);
            
            assertElementsAlmostEqual(dN1,...
                [-0.25 0.25 0.25 -0.25 0 -sqrt(6)/8 0 sqrt(6)/8 0, ...
                 -0.25 -0.25 0.25 0.25 sqrt(6)/8 0 -sqrt(6)/8 0 0]);
            
            dN2 = obj.Elem.evalDerivOfShapeFunct([0.5 0.25]);
            
            assertElementsAlmostEqual(dN2,...
                [-3/16 3/16 5/16 -5/16 3*sqrt(6)/32 -15*sqrt(6)/128 5*sqrt(6)/32 15*sqrt(6)/128 -45/128 ...
                 -1/8 -3/8 3/8 1/8 3*sqrt(6)/32 3*sqrt(6)/32 -3*sqrt(6)/32 sqrt(6)/32 -9/64]);
        end
        
        %% test evaluation of B
        function testGetB(obj)
            u = [-3/16 3/16 5/16 -5/16 3*sqrt(6)/32 -15*sqrt(6)/128 5*sqrt(6)/32 15*sqrt(6)/128 -45/128]; 
            v = [-1/8 -3/8 3/8 1/8 3*sqrt(6)/32 3*sqrt(6)/32 -3*sqrt(6)/32 sqrt(6)/32 -9/64]/1.5;
            assertElementsAlmostEqual(obj.Elem.getB([0.5 0.25]), [u zeros(1,9); zeros(1,9) v; v u]);
        end
        
        
        %% test calculation of element stiffness matrix
        function testElementStiffnessMatrix(obj)
            K = obj.Elem.calcStiffnessMatrix();
            EntryVector = [K(1,1) K(2,4) K(5,12) K(7,15) K(10,10) K(15,16)];
            ResultVector = [53/18 -53/36 sqrt(6)/4 1/2 19/9 0.0]/0.96;
            assertVectorsAlmostEqual(EntryVector,ResultVector) 
            assertElementsAlmostEqual(K-K',zeros(2*(obj.PolynomialOrder+1)^2,2*(obj.PolynomialOrder+1)^2));
        end
        
        %% test calculation of element load vector
        function testCalcElementBodyLoadVector(obj)
             FaceLoad = {@(x,y,z) [0; 9.81]};
             assertElementsAlmostEqual(obj.Elem.calcBodyLoadVector(FaceLoad),...
                 [0 0 0 0 0 0 0 0 0 3/2*9.81 3/2*9.81 3/2*9.81 3/2*9.81 ...
                 -2/9*sqrt(6)*9.81*(3/2)^2 -2/9*sqrt(6)*9.81*(3/2)^2 -2/9*sqrt(6)*9.81*(3/2)^2 ...
                 -2/9*sqrt(6)*9.81*(3/2)^2 4/9*9.81*(3/2)^2]');
        end
        
        function testElementMassMatrix(obj)
            M = obj.Elem.calcMassMatrix();
            EntryVector = [ M(1,1) M(1,2) M(6,5) M(4,10) M(18,15) M(18,18)];
            ResultVector = [0.6667 0.3333 0.2500 0.000 -0.2449 0.2400];
            assertVectorsAlmostEqual(EntryVector,ResultVector,'absolute',1e-4);
        end
        
        function testDoDomainIntegration(obj)
            RefArea = pi*0.8^2/4;
            function Value = fhandle(Coord) 
                Mat = obj.Elem2.getMaterialAtPoint(Coord);
                Value = Mat.getScalingFactor();
            end
            Area = obj.Elem2.doDomainIntegration(@fhandle);
            assertElementsAlmostEqual(RefArea,Area,'absolute',1e-3);
        end

    end
    
end

