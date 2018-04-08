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
 
%% 2D FCM - Driver file

%% Preliminarities
clear all;
close all;
% Set path for Logger
% Logger.setPathForLogger('EmbeddedRectanglePlaneStress.m','log2DFCM.out',0);

Logger.ConsoleLevel('debug');

%% Input parameters
% Numerical parameters
MeshOrigin = [0.0 0.0 0.0];
MeshLengthX = 4.0/3.0;
MeshLengthY = 4.0/3.0;
NumberOfXDivisions = 2;
NumberOfYDivisions = 2;
PolynomialDegree = 7;
NumberOfGaussPoints = PolynomialDegree+1;

% Mechanical parameters
YoungsModulus = 1.0;
PoissonsRatio = 0.3;
Density = 1.0;

% FCM Parameter

SpaceTreeDepth = 1;
Alpha = 0;
Beta = 0;

% Boundary Mesh
numberOfSegments = 3;

bx=@(x,y,z).2;
by=@(x,y,z).2;
Ux=@(x,y,z)x/5;
Uy=@(x,y,z)y/5;


% % Body Force
% bx  = @(x,y,z) ...
%     - ( ( 1 - PoissonsRatio ) * ( 35 * power( x, 4 ) * power( y, 6 ) + 6 * power( x, 2 ) * y ) * YoungsModulus ) ...
%     / ( 2 * ( 1 - PoissonsRatio * PoissonsRatio ) ) - ( 35 * PoissonsRatio * power( x, 4 ) * power( y, 6 ) * YoungsModulus ) / ( 1 - PoissonsRatio * PoissonsRatio ) ...
%     - ( 2 * power( y, 3 ) * YoungsModulus ) / ( 1 - PoissonsRatio * PoissonsRatio );
% by = @(x,y,z) ...
%     - ( ( 1 - PoissonsRatio ) * ( 20 * power( x, 3 ) * power( y, 7 ) + 6 * x * power( y, 2 ) ) * YoungsModulus ) ...
%     / ( 2 * ( 1 - PoissonsRatio * PoissonsRatio ) ) - ( 42 * power( x, 5 ) * power( y, 5 ) * YoungsModulus ) / ( 1 - PoissonsRatio * PoissonsRatio ) ...
%     - ( 6 * PoissonsRatio * x * power( y, 2 ) * YoungsModulus ) / ( 1 - PoissonsRatio * PoissonsRatio ) ;
% 
% % Boundary Conditions
% Ux = @(x,y,z) power( x, 2 ) * power( y, 3 ) ;
% Uy = @(x,y,z) power( x, 5 ) * power( y, 7 ) ;



%% Instanciation of the problem

% Creation of Materials
Materials(1) = HookePlaneStress( ...
    YoungsModulus, PoissonsRatio, ...
    Density, Alpha );
Materials(2) = HookePlaneStress( ...
    YoungsModulus, PoissonsRatio, ...
    Density, 1 );

% Creation of Domain Geoemtry
Center = [ 0.0 0.0 0.0 ];
Lengths = [ 1.0 1.0 ];
Rectangle = EmbeddedRectangle( Center, Lengths );

%BoundingBox4
vertex1 = Vertex([2.0/3.0 0.0 0.0]);
vertex2 = Vertex([4.0/3.0 0.0 0.0]);
vertex3 = Vertex([4.0/3.0 2.0/3.0 0.0]);
vertex4 = Vertex([2.0/3.0 2.0/3.0 0.0]);

line1 = Line(vertex1,vertex2);
line2 = Line(vertex2,vertex3);
line3 = Line(vertex3,vertex4);
line4 = Line(vertex4,vertex1);

BoundingBox4 = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);
BoundaryFactory = BoundaryRecoveryFactory( Rectangle, BoundingBox4, 0,0);
Boundary=[Line(Vertex([0.0 0.0 0.0]),Vertex([1.0/3.0 0.0 0.0])) Line(Vertex([1.0/3.0 0.0 0.0]),Vertex([2.0/3.0 0.0 0.0])) Line(Vertex([2.0/3.0 0.0 0.0]),Vertex([1.0 0.0 0.0])) ];
Boundary = [Boundary BoundaryFactory.getBoundaryAndNormalsOutWithVisual()];
clear BoundaryRecoveryFactory

%BoundingBox3
vertex1 = Vertex([2.0/3.0 2.0/3.0 0.0]);
vertex2 = Vertex([4.0/3.0 2.0/3.0 0.0]);
vertex3 = Vertex([4.0/3.0 1.0 0.0]);
vertex4 = Vertex([2.0/3.0 1.0 0.0]);

line1 = Line(vertex1,vertex2);
line2 = Line(vertex2,vertex3);
line3 = Line(vertex3,vertex4);
line4 = Line(vertex4,vertex1);

BoundingBox3 = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);
BoundaryFactory = BoundaryRecoveryFactory( Rectangle, BoundingBox3, 0,0);
Boundary = [Boundary BoundaryFactory.getBoundaryAndNormalsOutWithVisual()];
clear BoundaryRecoveryFactory

%BoundingBox2
vertex1 = Vertex([2.0/3.0 2.0/3.0 0.0]);
vertex2 = Vertex([1.0 2.0/3.0 0.0]);
vertex3 = Vertex([1.0 4.0/3.0 0.0]);
vertex4 = Vertex([2.0/3.0 4.0/3.0 0.0]);

line1 = Line(vertex1,vertex2);
line2 = Line(vertex2,vertex3);
line3 = Line(vertex3,vertex4);
line4 = Line(vertex4,vertex1);

BoundingBox2 = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);
BoundaryFactory = BoundaryRecoveryFactory( Rectangle, BoundingBox2, 0,0);
Boundary = [Boundary BoundaryFactory.getBoundaryAndNormalsOut()];
clear BoundaryRecoveryFactory

%BoundingBox1
vertex1 = Vertex([0.0 2.0/3.0 0.0]);
vertex2 = Vertex([2.0/3.0 2.0/3.0 0.0]);
vertex3 = Vertex([2.0/3.0 4.0/3.0 0.0]);
vertex4 = Vertex([0.0 4.0/3.0 0.0]);

line1 = Line(vertex1,vertex2);
line2 = Line(vertex2,vertex3);
line3 = Line(vertex3,vertex4);
line4 = Line(vertex4,vertex1);

BoundingBox1 = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);

BoundaryFactory = BoundaryRecoveryFactory( Rectangle, BoundingBox1, 0,0);

Boundary = [Boundary BoundaryFactory.getBoundaryAndNormalsOut()];
clear BoundaryRecoveryFactory


Boundary = [Boundary Line(Vertex([0.0 1.0 0.0]),Vertex([0.0 2.0/3.0 0.0])) Line(Vertex([0.0 2.0/3.0 0.0]),Vertex([0.0 1.0/3.0 0.0])) Line(Vertex([0.0 1.0/3.0 0.0]),Vertex([0.0 0.0 0.0]))];

% Creation of the FEM system
DofDimension = 2;

ElementFactory = ElementFactoryElasticQuadFCM(Materials,Rectangle,...
    NumberOfGaussPoints,SpaceTreeDepth);

MeshFactory = MeshFactory2DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,PolynomialDegree,TopologicalSorting,...
    DofDimension,MeshOrigin,MeshLengthX,MeshLengthY,ElementFactory);

% Create Analysis
Analysis = QuasiStaticAnalysis( MeshFactory );

% Loads
BodyForce = @(x,y,z) [ bx(x,y,z); by(x,y,z)];
loadCase = LoadCase();
loadCase.addBodyLoad( BodyForce );

Analysis.addLoadCases( loadCase );

% Boundary Conditions

% Selet constraining strategy
ConstrainingAlgorithm = ...
    WeakNitscheDirichlet2DAlgorithm( Beta );
BoundaryIntegrator = ...
    GaussLegendre( NumberOfGaussPoints );


% Create innter boundary condition in X

FixedDirections = [1 0];
ConditionX = ...
    WeakDirichletBoundaryCondition( ...
    Ux, FixedDirections, ...
    BoundaryIntegrator, Boundary, ...
    ConstrainingAlgorithm );

% Create innter boundary condition in Y
FixedDirections = [0 1];
ConditionY = ...
    WeakDirichletBoundaryCondition( ...
    Uy, FixedDirections, ...
    BoundaryIntegrator, Boundary, ...
    ConstrainingAlgorithm );

% Register condition at analysis
Analysis.addDirichletBoundaryCondition( ...
    ConditionX );
Analysis.addDirichletBoundaryCondition( ...
    ConditionY );

% Run analysis
Analysis.solve();

%% Post processing

analyticalSolutionCartesian = @(globalCoords) [Ux(globalCoords(1),globalCoords(2),globalCoords(3)); Uy(globalCoords(1),globalCoords(2),globalCoords(3))];
errorComponent = 1;

%% Visual Post Processing

% create the point processors
indexOfPhysicalDomain = 2;
loadCaseToVisualize = 1;

displacementNorm = DisplacementNorm( ...
    loadCaseToVisualize );
vonMises = VonMisesStress( ...
    loadCaseToVisualize, ...
    indexOfPhysicalDomain );
strainEnergy = StrainEnergy( ...
    loadCaseToVisualize, ...
    indexOfPhysicalDomain );
solutionError = SolutionError( ...
    loadCaseToVisualize, ...
    analyticalSolutionCartesian, ...
    errorComponent );
% l2Error = L2Error( ...
%     loadCaseToVisualize, ...
%     analyticalSolutionCartesian );

% Surface Plots
FeMesh = Analysis.getMesh();
gridSize = 0.05;
postProcessingFactory = ...
    VisualPostProcessingFactory2DFCMWarped( ...
    FeMesh,	Rectangle, ...
    indexOfPhysicalDomain, gridSize, 1, 1 );
% postProcessingFactory = ...
%     VisualPostProcessingFactory2DFCM( ...
%     FeMesh,	Rectangle, ...
%     indexOfPhysicalDomain, gridSize, ...
%     {BoundaryFactory} );
postProcessor = ...
    postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( ...
    displacementNorm );
postProcessor.registerPointProcessor( ...
    vonMises );
postProcessor.registerPointProcessor( ...
    solutionError );

postProcessor.visualizeResults( FeMesh );


%% Integration Post Processing

postProcessor = IntegrationPostProcessor( );

postProcessor.registerPointProcessor( strainEnergy );
% postProcessor.registerPointProcessor( l2Error );

integrals = postProcessor.integrate( FeMesh );

strainEnergy = ( ( 117403 * PoissonsRatio - 1378393 ) * YoungsModulus ) / ( 390 * ( 6930 * PoissonsRatio * PoissonsRatio - 6930 ) );

error = 1 - integrals/strainEnergy;

fprintf('Relative Error: %e %%\n', 100*error);

