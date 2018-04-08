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
 
% testing of class ElasticHexa

classdef ElasticHexaTest < TestCase
    
    properties
        Elem
        Integrator
        PolynomialDegree
        DofDimension
        EdgeLineCoordTest
        EdgeLineCoordTest2
    end
    
    methods
        
        %% constructor
        function obj = ElasticHexaTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            % test with an element of polynomial degree of 2
            % width in x = 2, depth in y = 3, height in z = 9
            % E = 5, Poisson's ratio = 0.2
            Mat3D = Hooke3D(5,0.2,1,1);       
            obj.Integrator = Integrator(NoPartition,3);
            obj.PolynomialDegree = 2;
            obj.DofDimension = 3;
            Node1 = Node([3 5 0],3);
            Node2 = Node([5 5 0],3);
            Node3 = Node([5 8 0],3);
            Node4 = Node([3 8 0],3);
            Node5 = Node([3 5 9],3);
            Node6 = Node([5 5 9],3);
            Node7 = Node([5 8 9],3);
            Node8 = Node([3 8 9],3);
            Edge1 = Edge([Node1 Node2],2,3);
            Edge2 = Edge([Node2 Node3],2,3);
            Edge3 = Edge([Node4 Node3],2,3);
            Edge4 = Edge([Node1 Node4],2,3);
            Edge5 = Edge([Node1 Node5],2,3);
            Edge6 = Edge([Node2 Node6],2,3);
            Edge7 = Edge([Node3 Node7],2,3);
            Edge8 = Edge([Node4 Node8],2,3);
            Edge9 = Edge([Node5 Node6],2,3);
            Edge10 = Edge([Node6 Node7],2,3);
            Edge11 = Edge([Node8 Node7],2,3);
            Edge12 = Edge([Node5 Node8],2,3);
            Face1 = Face([Node1 Node2 Node3 Node4], [Edge1 Edge2 Edge3 Edge4],2,3);
            Face2 = Face([Node1 Node2 Node6 Node5], [Edge1 Edge5 Edge6 Edge9],2,3);
            Face3 = Face([Node2 Node3 Node7 Node6], [Edge2 Edge6 Edge7 Edge10],2,3);
            Face4 = Face([Node3 Node4 Node8 Node7], [Edge3 Edge7 Edge8 Edge11],2,3);
            Face5 = Face([Node1 Node4 Node8 Node5], [Edge4 Edge5 Edge8 Edge12],2,3);
            Face6 = Face([Node5 Node6 Node7 Node8], [Edge9 Edge10 Edge11 Edge12],2,3);
            
            solid1 = Solid([Node1 Node2 Node3 Node4 Node5 Node6 Node7 Node8], ...
                [Edge1 Edge2 Edge3 Edge4 Edge5 Edge6 Edge7 Edge8 Edge9 Edge10 Edge11 Edge12],...
                [Face1 Face2 Face3 Face4 Face5 Face6],2,3);
            obj.Elem = ElasticHexa([Node1 Node2 Node3 Node4 Node5 Node6 Node7 Node8], ...
                [Edge1 Edge2 Edge3 Edge4 Edge5 Edge6 Edge7 Edge8 Edge9 Edge10 Edge11 Edge12],...
                [Face1 Face2 Face3 Face4 Face5 Face6], solid1, Mat3D,obj.Integrator, ...
                obj.PolynomialDegree,obj.DofDimension,PseudoDomain());  
            % needed for the test of the line mapping
            CenterNode = Node([4 6.5 4.5],2);
            obj.EdgeLineCoordTest = Edge([Node1 CenterNode],1,3);
            obj.EdgeLineCoordTest2 = Edge([Node2 Node3],1,3);
        end
        
        function tearDown(obj)
        end

        %% test calcuation of Jacobian
        function testJacobian(obj)
            assertEqual(obj.Elem.calcJacobian([0 0 0]), [1 0 0; 0 1.5 0; 0 0 4.5]);
        end   

        %% test mapping from global to local coordinate system
        function testMapGlobalToLocalCoords(obj)
            assertVectorsAlmostEqual(obj.Elem.mapGlobalToLocal([4.2 5.75 8.1]), [0.2 -0.5 0.8]);
        end
        
        %% test mapping from local to global coordinate system
        function testMapLocalToGlobalCoords(obj)
            assertVectorsAlmostEqual(obj.Elem.mapLocalToGlobal([0.2 -0.5 0.8]), [4.2 5.75 8.1]);
        end
        
        %% test evaluation of shape functions
        function testGetShapeFunctionsVector(obj)
            N = obj.Elem.evalShapeFunct([0.2 -0.5 0.8]);
            assertElementsAlmostEqual([N N N], ...
                [0.03 0.045 0.015 0.01 0.27 0.405 0.135 0.09 -0.0441 -0.0276 -0.0147 -0.0184 -0.0661 ...
                -0.0992 -0.0331 -0.022 -0.3968 -0.248 -0.1323 -0.1653 0.027 0.0972 0.0607 0.0324 ...
                0.0405 0.243 -0.0595 ...
                0.03 0.045 0.015 0.01 0.27 0.405 0.135 0.09 -0.0441 -0.0276 -0.0147 -0.0184 -0.0661 ...
                -0.0992 -0.0331 -0.022 -0.3968 -0.248 -0.1323 -0.1653 0.027 0.0972 0.0607 0.0324 ...
                0.0405 0.243 -0.0595 ...
                0.03 0.045 0.015 0.01 0.27 0.405 0.135 0.09 -0.0441 -0.0276 -0.0147 -0.0184 -0.0661 ...
                -0.0992 -0.0331 -0.022 -0.3968 -0.248 -0.1323 -0.1653 0.027 0.0972 0.0607 0.0324 ...
                0.0405 0.243 -0.0595], 'absolute', 1e-4);
        end
        
        %% test evaluation of shape function derivatives
        function testGetShapeFunctionsDerivativeVector(obj)
            ShapeFunctionsDerivativeVectorTest = [-0.0375 0.0375 0.0125 -0.0125 -0.3375 0.3375 0.1125 -0.1125 0.0184 -0.023 0.0061...
                0.023 0.0827 -0.0827 -0.0276 0.0276 0.1653 -0.2067 0.0551 0.2067 -0.0113 -0.0405 ...
                0.0506 -0.0135 -0.0506 -0.1013 0.0248, ...
                -0.02 -0.03 0.03 0.02 -0.18 -0.27 0.27 0.18 0.0294 -0.0367 -0.0294 -0.0245 0.0441 ...
                0.0661 -0.0661 -0.0441 0.2645 -0.3307 -0.2645 -0.2205 0.036 -0.0648 0.081 0.0648 0.054 ...
                0.324 -0.0794,...
                -0.15 -0.225 -0.075 -0.05 0.15 0.225 0.075 0.05 0.22045 0.13778 0.07348 0.09186 0.29394 ...
                0.44091 0.14697 0.09798 -0.22045 -0.13778 -0.07348 -0.09186 -0.135 -0.432 -0.27 -0.144 -0.18 0.135 ...
                0.26454];
            DerivShapeFunction = obj.Elem.evalDerivOfShapeFunct([0.2 -0.5 0.8]);
            
            for i=1:3*27
                assertElementsAlmostEqual(DerivShapeFunction(1,i),ShapeFunctionsDerivativeVectorTest(1,i),'absolute', 1e-3);
            end
        end
        
        
        %% test evaluation of B
        function testGetB(obj)
            u = [-0.0375 0.0375 0.0125 -0.0125 -0.3375 0.3375 0.1125 -0.1125 0.0184 -0.023 0.0061...
                0.023 0.0827 -0.0827 -0.0276 0.0276 0.1653 -0.2067 0.0551 0.2067 -0.0113 -0.0405 ...
                0.0506 -0.0135 -0.0506 -0.1013 0.0248];
            v = [-0.02 -0.03 0.03 0.02 -0.18 -0.27 0.27 0.18 0.0294 -0.0367 -0.0294 -0.0245 0.0441 ...
                0.0661 -0.0661 -0.0441 0.2645 -0.3307 -0.2645 -0.2205 0.036 -0.0648 0.081 0.0648 0.054 ...
                0.324 -0.0794]/1.5;
            w = [-0.15 -0.225 -0.075 -0.05 0.15 0.225 0.075 0.05 0.22045 0.13778 0.07348 0.09186 0.29394 ...
                0.44091 0.14697 0.09798 -0.22045 -0.13778 -0.07348 -0.09186 -0.135 -0.432 -0.27 -0.144 -0.18 0.135 ...
                0.26454]/4.5;
            z = zeros(1,27);
            assertElementsAlmostEqual(obj.Elem.getB([0.2 -0.5 0.8]),[u z z; z v z; z z w; v u z; z w v; w z u],'absolute', 1e-3);
        end
              
        
         %% test calculation of element stiffness matrix
        function testElementStiffnessMatrix(obj)
            K = obj.Elem.calcStiffnessMatrix();

            EntryVector = [K(1,5) K(3,30) K(16,80) K(40,50) K(50,80) K(81,81)];
            ResultVector = [1525/324 125/48 125*sqrt(6)/864 1115*sqrt(6)/2592 0 383/108];

            assertVectorsAlmostEqual(EntryVector,ResultVector);
            % check for symmetry of K
            assertElementsAlmostEqual(K-K',zeros(3*(obj.PolynomialDegree+1)^3,3*(obj.PolynomialDegree+1)^3));
            % check for first six eigenvalues being zero -> rigid body modes
            Eigenvalues = sort(eig(K));
            for i=1:6
                assertElementsAlmostEqual(Eigenvalues(i),0);
            end
        end
        
        function testCalcElementBodyLoadVector(obj)
            TestVector = zeros(81,1);
            TestVector(55:81) = 9.81*27/4;
            TestVector(55:62) = TestVector(55:62)*1;
            TestVector(63:74) = TestVector(63:74)*(-sqrt(6)/3);
            TestVector(75:80) = TestVector(75:80)*2/3;
            TestVector(81) = TestVector(81)*(-6^1.5/27);
            VolLoad = {@(x,y,z) [0; 0; 9.81]};
            assertVectorsAlmostEqual(obj.Elem.calcBodyLoadVector(VolLoad),TestVector);
            
        end
        
        function testElementMassMatrix(obj)
            M = obj.Elem.calcMassMatrix();
            EntryVector = [ M(1,1) M(1,2) M(1,3) M(2,9) M(7,16) M(81,81)];
            ResultVector = [2.0000 1.0000 0.5000 -1.2247 -0.6124 0.4320];
            assertVectorsAlmostEqual(EntryVector,ResultVector,'absolute',1e-4);
            assertElementsAlmostEqual(M-M',zeros(3*(obj.PolynomialDegree+1)^3,3*(obj.PolynomialDegree+1)^3));
        end

    end
    
end

