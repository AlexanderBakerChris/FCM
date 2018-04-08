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
 
% testing of class ElasticBar

classdef ElasticBarTest < TestCase
    
    properties
        Elem
        Elem2
        Elem3
        Elem4
        Integrator
        Integrator2
        Integrator3
        LoadFunction
        LoadFunction2
    end
    
    methods
        
        %% constructor
        function obj = ElasticBarTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            Mat1D10 = Hooke1D(2,10,1,1);
            Mat1D1 = Hooke1D(1,1,1,1);
            obj.Integrator = Integrator(NoPartition(),2);
            obj.Integrator2 = Integrator(NoPartition(),5);
            obj.Integrator3 = Integrator(NoPartition(),10);
            Node1 = Node([0 0 0],1);
            Node1.getDof().setId(1);
            Node1.getDof().setValue(1,1);
            Node2 = Node([1 0 0],1);
            Node2.getDof().setId(4);
            Node2.getDof().setValue(2,1);
            Edge1 = Edge([Node1 Node2],1,1);
            Edge2 = Edge([Node1 Node2],3,1);
            Edge2Dof = Edge2.getDof();
            for i=1:2
                Edge2Dof(i).setId(i+1);
                Edge2Dof(i).setValue(i+2,1);
            end
            Edge3 = Edge([Node1 Node2],8,1);
            obj.LoadFunction = {@(x,y,z)x^2}; 
            obj.LoadFunction2 = {@(x,y,z)-sin(8*x)};
            NoDomain = PseudoDomain();
            obj.Elem = ElasticBar([Node1 Node2], Edge1, Mat1D10,obj.Integrator,...
                1,1,NoDomain);
            obj.Elem2 = ElasticBar([Node1 Node2], Edge2, Mat1D10,obj.Integrator2,...
                3,1,NoDomain);
            obj.Elem3 = ElasticBar([Node1 Node2], Edge3, Mat1D1,obj.Integrator3,...
                8,1,NoDomain);
            
            % following just to test the mapping
            Node3 = Node([5 0 0],1);
            Node4 = Node([7 0 0],1);
            Edge4 = Edge([Node3 Node4],1,1);
            obj.Elem4 = ElasticBar([Node3 Node4],Edge4,1,obj.Integrator,...
                1,1,NoDomain);
            
        end
        
        function tearDown(obj)
        end
        
        %% test Young's modulus
        function testYoungsModulus(obj)
            assertEqual(obj.Elem.getMaterial().getMaterialMatrix(), 20);
        end
        
        %% test calcuation of Jacobian
        function testJacobian(obj)
            assertEqual(obj.Elem.calcJacobian(0), [0.5 0 0]);
        end
        
        %% test location matrix
        function testLocationMatrix(obj)
            assertEqual(obj.Elem2.getLocationMatrix(), [1 4 2 3]);
        end
        

        %% test mapping from global to local coordinate system
        function testMapGlobalToLocalCoords(obj)
            assertEqual(obj.Elem.mapGlobalToLocal(0), -1);
            assertEqual(obj.Elem.mapGlobalToLocal(0.5), 0);
            assertEqual(obj.Elem.mapGlobalToLocal(1), 1);
            
            assertEqual(obj.Elem4.mapGlobalToLocal(5),-1);
            assertEqual(obj.Elem4.mapGlobalToLocal(6),0);
            assertEqual(obj.Elem4.mapGlobalToLocal(7),1);
        end
        
        %% test mapping from local to global coordinate system
        function testMapLocalToGlobalCoords(obj)
            assertEqual(obj.Elem.mapLocalToGlobal(-1), [0 0 0]);
            assertEqual(obj.Elem.mapLocalToGlobal(0), [0.5 0 0]);
            assertEqual(obj.Elem.mapLocalToGlobal(1), [1 0 0]);
            
            assertEqual(obj.Elem4.mapLocalToGlobal(-1),[5 0 0]);
            assertEqual(obj.Elem4.mapLocalToGlobal(0),[6 0 0]);
            assertEqual(obj.Elem4.mapLocalToGlobal(1),[7 0 0]);
        end
        
        %% test evaluation of shape functions
        function testGetShapeFunctionsVector(obj)
            assertElementsAlmostEqual(obj.Elem2.evalShapeFunct(0), [0.5 0.5 -sqrt(6)/4 0]);
            assertElementsAlmostEqual(obj.Elem2.evalShapeFunct(0.5), [0.25 0.75 -3*sqrt(6)/16 -3*sqrt(10)/32]);
        end
        
        %% test evaluation of shape function derivatives
        function testGetShapeFunctionsDerivativeVector(obj)
            assertElementsAlmostEqual(obj.Elem2.evalDerivOfShapeFunct(0),...
                [-0.5 0.5 0 -sqrt(10)/4]);
            assertElementsAlmostEqual(obj.Elem2.evalDerivOfShapeFunct(0.5),...
                [-0.5 0.5 sqrt(6)/4 -sqrt(10)/16]);
        end
        
        %% test evaluation of B
        function testGetB(obj)
            assertElementsAlmostEqual(obj.Elem2.getB(0.5),...
                [-0.5 0.5 sqrt(6)/4 -sqrt(10)/16]/0.5);
        end
        
        %% test calculation of element stiffness matrix
        function testElementStiffnessMatrix(obj)
            assertElementsAlmostEqual(obj.Elem.calcStiffnessMatrix(), [20 -20 ; -20 20]);
            assertElementsAlmostEqual(obj.Elem2.calcStiffnessMatrix(), [20 -20 0 0; -20 20 0 0; 0 0 40 0; 0 0 0 40]);
            K = 2*eye(9);
            K(1,1) = 1;
            K(1,2) = -1;
            K(2,1) = -1;
            K(2,2) = 1;   
            assertElementsAlmostEqual(obj.Elem3.calcStiffnessMatrix(), K);
        end
        
        %% test calculation of element load vector
        function testCalcElementBodyLoadVector(obj)
            assertElementsAlmostEqual(obj.Elem.calcBodyLoadVector(obj.LoadFunction), [1/12; 1/4]);
            assertElementsAlmostEqual(obj.Elem2.calcBodyLoadVector(obj.LoadFunction), [1/12; 1/4; -sqrt(6)/20; -sqrt(10)/60]);
            assertElementsAlmostEqual(obj.Elem3.calcBodyLoadVector(obj.LoadFunction2), ...
                [-0.1095 -0.0336 -0.0269 -0.0714 0.0811 0.0433 -0.023 -0.0073 0.0026]',...
                'absolute', 1e-4);
        end
        
        %% test solution vector
        function testGetDofVector(obj)
            obj.Elem2.assembleAndCacheDofVector(1);
            assertEqual(obj.Elem2.getDofVector(1),[1 2 3 4]');
        end
        
        function testElementMassMatrix(obj)
            M = obj.Elem3.calcMassMatrix();
            EntryVector = [ M(1,1) M(1,2) M(1,3) M(3,5)  M(9,9)];
            ResultVector = [0.3333 0.1667 -0.2041 -0.0218 0.0045];
            assertVectorsAlmostEqual(EntryVector,ResultVector,'absolute',1e-4);
            assertElementsAlmostEqual(M-M',zeros(9,9));
        end
        
    end
    
end

