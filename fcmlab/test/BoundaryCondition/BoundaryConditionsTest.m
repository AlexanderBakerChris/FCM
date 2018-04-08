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
 
%% testing of gravity3D
classdef BoundaryConditionsTest < TestCase
    
    properties        
        MyMesh
        MyStrongNodeDirichletBC
        MyStrongEdgeDirichletBC
        MyStrongFaceDirichletBC
        MyNodalNeumannBC
        MyWeakEdgeDirichletBC
        MyWeakEdgeNeumannBC
        MyWeakFaceDirichletBC
        MyWeakFaceNeumannBC
        MyWeakDirichletBC
        PenaltyValue
    end
    
    methods
        %% constructor
        function obj = BoundaryConditionsTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            % general setup
            NumberOfXDivisions = 1;
            NumberOfYDivisions = 1;
            NumberOfZDivisions = 1;
            PolynomialDegree = 1;
            NumberGP = PolynomialDegree+1;
            DofDimension = 3;
            MeshOrigin = [0 0 0];
            Lx = 1;
            Ly = 1;
            Lz = 1;

            E = 4E6;
            PoissonsRatio = 0.0;
            Density = 1;
            Mat3D = Hooke3D(E,PoissonsRatio,Density,1);
            ElementFactory = ElementFactoryElasticHexa(Mat3D,NumberGP);
            
            MeshFactory = MeshFactory3DUniform(NumberOfXDivisions,...
                NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,PolynomialDegreeSorting(),DofDimension,...
                MeshOrigin,Lx,Ly,Lz,ElementFactory);
            
            obj.MyMesh = Mesh(MeshFactory);
            
            % StrongDirichletBoundaryConditions
            PrescribedValue = 1;
            Direction = [0 0 1];
            obj.PenaltyValue = 100;
            StrongDirichletAlgorithm = StrongPenaltyAlgorithm(obj.PenaltyValue);
            
            % StrongNodeDirichletBoundaryCondition
            Position = [0 0 0];
            obj.MyStrongNodeDirichletBC = StrongNodeDirichletBoundaryCondition(Position,PrescribedValue,Direction,StrongDirichletAlgorithm);
            
            PrescribedFunction = @(x,y,z)(0);
            
            % StrongEdgeDirichletBoundaryCondition
            LineStart = [0 0 0];
            LineEnd = [Lx 0 0];
            obj.MyStrongEdgeDirichletBC = StrongEdgeDirichletBoundaryCondition(LineStart,LineEnd,PrescribedFunction,Direction,StrongDirichletAlgorithm);

            % StrongFaceDirichletBoundaryCondition
            FaceStart = [0 0 0];
            FaceEnd = [Lx Ly 0];
            obj.MyStrongFaceDirichletBC = StrongFaceDirichletBoundaryCondition(FaceStart,FaceEnd,PrescribedFunction,Direction,StrongDirichletAlgorithm);

            % NodalNeumannBoundaryCondition
            LoadVector = [0 0 1];
            obj.MyNodalNeumannBC = NodalNeumannBoundaryCondition(Position,LoadVector);
            
            % WeakEdgeDirichletBoundaryCondition
            integrationScheme = GaussLegendre(NumberGP);
            WeakDirichletAlgorithm = WeakPenaltyAlgorithm(obj.PenaltyValue);
            obj.MyWeakEdgeDirichletBC = WeakEdgeDirichletBoundaryCondition(LineStart,LineEnd,integrationScheme,PrescribedFunction,Direction,WeakDirichletAlgorithm);
            
            % WeakEdgeNeumannBoundaryCondition
            LoadFunction = @(x,y,z)([1;0;0]);
            obj.MyWeakEdgeNeumannBC = WeakEdgeNeumannBoundaryCondition(LineStart,LineEnd,integrationScheme,LoadFunction);

            % WeakFaceDirichletBoundaryCondition
            obj.MyWeakFaceDirichletBC = WeakFaceDirichletBoundaryCondition(FaceStart,FaceEnd,integrationScheme,PrescribedFunction,Direction,WeakDirichletAlgorithm);
            
            % WeakFaceNeumannBoundaryCondition
            obj.MyWeakFaceNeumannBC = WeakFaceNeumannBoundaryCondition(FaceStart,FaceEnd,integrationScheme,LoadFunction);
            
            % WeakDirichletBC
            % Geometry parameters for an iBeam
            Width = 0.5;   % total width (x)
            Length = 6.2;  % total length of beam (y)
            Height = 0.6;  % total height (z)
            Thick1 = 0.02;  % thickness of flanges
            Thick2 = 0.02;  % thickness of the girder
            Circles = [3.1 0.15;1.5 0.15;4.7 0.15] ; % matrix of circular holes along girder [y1 r1; y2 r2;...]
                                                     % with yi being the middle point coordinate along girder
            
            
            MyBoundaryFactory = IBeamBoundaryFactory(Width,Height,Thick1,Thick2);
            
            MyBoundary = MyBoundaryFactory.getBoundary;
            NitschePenaltyValue = 1; %set to 1 in order to have a more sensitive result when asserting the results for the Nitsches Algorithm
            MyAlgorithm = WeakNitscheDirichlet3DAlgorithm(NitschePenaltyValue);
            integrationScheme = GaussLegendre(NumberGP*4);
            obj.MyWeakDirichletBC = WeakDirichletBoundaryCondition(@(x,y,z)0,[1 1 1],integrationScheme,MyBoundary,MyAlgorithm);
        end
        
        function tearDown(obj)
        end
        
        %% test StrongNodeDirichletBoundaryCondition
        function testStrongNodeDirichletBoundaryCondition(obj)
            K = zeros(24,24);
            Kexpected = K;
            Kexpected(17,17) = obj.PenaltyValue;
            
            F = zeros(24,1);
            Fexpected = F;
            Fexpected(17,1) = obj.PenaltyValue;

            [K, F] = obj.MyStrongNodeDirichletBC.modifyLinearSystem(obj.MyMesh,K,F);
            
            assertElementsAlmostEqual(K,Kexpected,'absolute',1e-3);
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
        end
        
        %% test StrongEdgeDirichletBoundaryCondition
        function testStrongEdgeDirichletBoundaryCondition(obj)
            K = zeros(24,24);
            Kexpected = K;
            Kexpected(17,17) = obj.PenaltyValue;
            Kexpected(18,18) = obj.PenaltyValue;
            
            F = zeros(24,1);
            Fexpected = F;

            [K, F] = obj.MyStrongEdgeDirichletBC.modifyLinearSystem(obj.MyMesh,K,F);
            
            assertElementsAlmostEqual(K,Kexpected,'absolute',1e-3);
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
        end
        
        %% test StrongFaceDirichletBoundaryCondition
        function testStrongFaceDirichletBoundaryCondition(obj)
            K = zeros(24,24);
            Kexpected = K;
            Kexpected(17,17) = obj.PenaltyValue;
            Kexpected(18,18) = obj.PenaltyValue;
            Kexpected(19,19) = obj.PenaltyValue;
            Kexpected(20,20) = obj.PenaltyValue;
            
            F = zeros(24,1);
            Fexpected = F;

            [K, F] = obj.MyStrongFaceDirichletBC.modifyLinearSystem(obj.MyMesh,K,F);
            
            assertElementsAlmostEqual(K,Kexpected,'absolute',1e-3);
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
        end
        
        %% test NodalNeumannBoundaryCondition
        function testNodalNeumannBoundaryCondition(obj)            
            F = zeros(24,1);
            Fexpected = F;
            Fexpected(17,1) = 1;

            F = obj.MyNodalNeumannBC.augmentLoadVector(obj.MyMesh,F);
             
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
        end
        
        %% test WeakEdgeDirichletBoundaryCondition
        function testWeakEdgeDirichletBoundaryCondition(obj)            
            K = zeros(24,24);
            Kexpected = K;
            Kexpected(17,17) = 33.333;
            Kexpected(17,18) = 16.667;
            Kexpected(18,17) = 16.667;
            Kexpected(18,18) = 33.333;
            
            F = zeros(24,1);
            Fexpected = F;

            [K, F] = obj.MyWeakEdgeDirichletBC.modifyLinearSystem(obj.MyMesh,K,F);
            
            assertElementsAlmostEqual([K F],[Kexpected Fexpected],'relative',1E-3);
        end
        
        % test WeakEdgeNeumannBoundaryCondition
        function testWeakEdgeNeumannBoundaryCondition(obj)
            F = zeros(24,1);
            Fexpected = F;
            Fexpected(1,1) = 0.5;
            Fexpected(2,1) = 0.5;
            
            F = obj.MyWeakEdgeNeumannBC.augmentLoadVector(obj.MyMesh,F);
            
            assertEqual(F,Fexpected);
        end
        
        % test WeakFaceDirichletBoundaryCondition
        function testWeakFaceDirichletBoundaryCondition(obj)
            K = zeros(24,24);
            Kexpected = K;
            Kexpected(17,17) = 11.111;
            Kexpected(18,18) = 11.111;
            Kexpected(19,19) = 11.111;
            Kexpected(20,20) = 11.111;
            Kexpected(17,18) = 5.556;
            Kexpected(17,19) = 5.556;
            Kexpected(17,20) = 2.778;
            Kexpected(18,17) = 5.556;
            Kexpected(18,19) = 2.778;
            Kexpected(18,20) = 5.556;
            Kexpected(19,17) = 5.556;
            Kexpected(19,18) = 2.778;
            Kexpected(19,20) = 5.556;
            Kexpected(20,17) = 2.778;
            Kexpected(20,18) = 5.556;
            Kexpected(20,19) = 5.556;
            
            F = zeros(24,1);
            Fexpected = F;

            [K, F] = obj.MyWeakFaceDirichletBC.modifyLinearSystem(obj.MyMesh,K,F);
            
            assertElementsAlmostEqual(K,Kexpected,'absolute',1e-3);
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
        end
        
        %% test WeakFaceNeumannBoundaryCondition
        function testWeakFaceNeumannBoundaryCondition(obj)
            F = zeros(24,1);
            Fexpected = F;
            Fexpected(1,1) = 0.25;
            Fexpected(2,1) = 0.25;
            Fexpected(3,1) = 0.25;
            Fexpected(4,1) = 0.25;
            
            F = obj.MyWeakFaceNeumannBC.augmentLoadVector(obj.MyMesh,F);
            
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
        end
        
        %% test WeakDirichletBoundaryCondition
        function testWeakDirichletBoundaryCondition(obj)
            K = zeros(24,24);

            Kexpected = ...
                [-50308,-15212,0,0,14374,4346.4,0,0,0,0,0,0,0,0,0,0,-45795,19900,0,0,-12119,5253.7,0,0;
                 -15212,-6627.7,0,0,4346.4,1893.6,0,0,0,0,0,0,0,0,0,0,-14627,5994.9,0,0,-3899.5,1611.2,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19900,5994.9,0,0,5253.7,1611.2,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5994.9,2636.7,0,0,1611.2,677.11,0,0;
                 14374,4346.4,0,0,21560,6519.6,0,0,0,0,0,0,0,0,0,0,-12119,5253.7,0,0,-12702,5526.5,0,0;
                 4346.4,1893.6,0,0,6519.6,2840.4,0,0,0,0,0,0,0,0,0,0,-3899.5,1611.2,0,0,-4040.2,1648.6,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5253.7,1611.2,0,0,5526.5,1648.6,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1611.2,677.11,0,0,1648.6,743.12,0,0;
                 0,0,0,0,0,0,0,0,-79600,-23980,39800,11990,-21015,-6444.9,10507,3222.4,-25895,-8631.7,0,0,-6865,-2288.3,0,0;
                 0,0,0,0,0,0,0,0,-23980,-10547,11990,5273.5,-6444.9,-2708.4,3222.4,1354.2,25895,8631.7,0,0,6865,2288.3,0,0;
                 0,0,0,0,0,0,0,0,39800,11990,0,0,10507,3222.4,0,0,0,0,0,0,0,0,0,0;
                 0,0,0,0,0,0,0,0,11990,5273.5,0,0,3222.4,1354.2,0,0,0,0,0,0,0,0,0,0;
                 0,0,0,0,0,0,0,0,-21015,-6444.9,10507,3222.4,-22106,-6594.2,11053,3297.1,-6865,-2288.3,0,0,-7175,-2391.7,0,0;
                 0,0,0,0,0,0,0,0,-6444.9,-2708.4,3222.4,1354.2,-6594.2,-2972.5,3297.1,1486.2,6865,2288.3,0,0,7175,2391.7,0,0;
                 0,0,0,0,0,0,0,0,10507,3222.4,0,0,11053,3297.1,0,0,0,0,0,0,0,0,0,0;
                 0,0,0,0,0,0,0,0,3222.4,1354.2,0,0,3297.1,1486.2,0,0,0,0,0,0,0,0,0,0;
                 -45795,-14627,19900,5994.9,-12119,-3899.5,5253.7,1611.2,-25895,25895,0,0,-6865,6865,0,0,0.0099501,0.0029975,0,0,0.0026269,0.00080561,0,0;
                 19900,5994.9,5994.9,2636.7,5253.7,1611.2,1611.2,677.11,-8631.7,8631.7,0,0,-2288.3,2288.3,0,0,0.0029975,0.0013184,0,0,0.00080561,0.00033855,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
                 -12119,-3899.5,5253.7,1611.2,-12702,-4040.2,5526.5,1648.6,-6865,6865,0,0,-7175,7175,0,0,0.0026269,0.00080561,0,0,0.0027632,0.00082428,0,0;
                 5253.7,1611.2,1611.2,677.11,5526.5,1648.6,1648.6,743.12,-2288.3,2288.3,0,0,-2391.7,2391.7,0,0,0.00080561,0.00033855,0,0,0.00082428,0.00037156,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;];
            
            
            
            
            F = zeros(24,1);
            Fexpected = F;
            
            
            [K, F] = obj.MyWeakDirichletBC.modifyLinearSystem(obj.MyMesh,K,F);
            
            assertElementsAlmostEqual(K,Kexpected,'absolute',5e-1);
            assertElementsAlmostEqual(F,Fexpected,'absolute',1e-10);
            
        end
        
    end
    
end

