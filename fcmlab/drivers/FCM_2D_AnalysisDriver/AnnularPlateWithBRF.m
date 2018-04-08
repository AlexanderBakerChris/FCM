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
% Set path for Logger
Logger.setPathForLogger('AnnularPlateCleanedUp.m','log2DFCM.out',0);

Logger.ConsoleLevel('debug');

%% Input parameters
% Numerical parameters
MeshOrigin = [-1.1 -1.1 0.0];
MeshLengthX = 2.2;
MeshLengthY = 2.2;
NumberOfXDivisions = 4;
NumberOfYDivisions = 4;
PolynomialDegree = 4;
NumberOfGaussPoints = PolynomialDegree+1;

% Mechanical parameters
YoungsModulus = 1.0;
PoissonsRatio = 0.0;
Density = 1.0;

% FCM Parameter
SpaceTreeDepth = 3;
Alpha = 1e-10;
Beta = 1e3;

% Boundary Mesh
Center = [ 0.0 0.0 0.0 ];
OuterRadius = 1.0;
InnerRadius = 0.25;
NumberOfSegments = 500;

% Body Force
bPolar = @(r,theta) [ 1/(r*log(2)) ; 0];

% Boundary Conditions
uxPolar = @(r,theta) 0.25*cos(theta);
uyPolar = @(r,theta) 0.25*sin(theta);


%% Instanciation of the problem

% Creation of Materials
Materials(1) = HookePlaneStress( ...
    YoungsModulus, PoissonsRatio, ...
    Density, Alpha );
Materials(2) = HookePlaneStress( ...
    YoungsModulus, PoissonsRatio, ...
    Density, 1 );

% Creation of Domain Geoemtry

vertex1 = Vertex([-1.1 -1.1 0.0]);
vertex2 = Vertex([1.1 -1.1 0.0]);
vertex3 = Vertex([1.1 1.1 0.0]);
vertex4 = Vertex([-1.1 1.1 0.0]);

line1 = Line(vertex1,vertex2);
line2 = Line(vertex2,vertex3);
line3 = Line(vertex3,vertex4);
line4 = Line(vertex4,vertex1);

BoundingBox = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);

PlateOuter = Plate( Center, OuterRadius);
PlateInner = Plate( Center, InnerRadius);
AnnularPlate = AnnularPlate( Center, OuterRadius, InnerRadius );

OuterBoundaryFactory = BoundaryRecoveryFactory(PlateOuter,BoundingBox,7);

InnerBoundaryFactory = BoundaryRecoveryFactory(PlateInner,BoundingBox,7);

% Creation of the FEM system
DofDimension = 2;

ElementFactory = ElementFactoryElasticQuadFCM(Materials,AnnularPlate,...
    NumberOfGaussPoints,SpaceTreeDepth);

MeshFactory = MeshFactory2DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,PolynomialDegree,PolynomialDegreeSorting,...
    DofDimension,MeshOrigin,MeshLengthX,MeshLengthY,ElementFactory);

% Create Analysis
Analysis = QuasiStaticAnalysis( MeshFactory );

% Loads
BodyForce = @(x,y,z) polarToCartesian2DVector( x, y, bPolar );

LoadCase = LoadCase();
LoadCase.addBodyLoad( BodyForce );

Analysis.addLoadCases( LoadCase );

% Boundary Conditions

% Select constraining strategy
ConstrainingAlgorithm = ...
    WeakNitscheDirichlet2DAlgorithm( Beta );
BoundaryIntegrator = ...
    GaussLegendre( NumberOfGaussPoints );

% Create outer boundary condition
Boundary = ...
    OuterBoundaryFactory.getBoundary();
zeroBoundary = @(x,y,z) 0;
FixedDirections = [1 1];
OuterCondition = ...
    WeakDirichletBoundaryCondition( ...
    zeroBoundary, FixedDirections, ...
    BoundaryIntegrator, Boundary, ...
    ConstrainingAlgorithm );

% Create innter boundary condition in X
Boundary = ...
    InnerBoundaryFactory.getBoundary();
Ux = @(x,y,z) polarToCartesian(x,y,uxPolar);
FixedDirections = [1 0];
InnerConditionX = ...
    WeakDirichletBoundaryCondition( ...
    Ux, FixedDirections, ...
    BoundaryIntegrator, Boundary, ...
    ConstrainingAlgorithm );

% Create innter boundary condition in Y
Uy = @(x,y,z) polarToCartesian(x,y,uyPolar);
FixedDirections = [0 1];
InnerConditionY = ...
    WeakDirichletBoundaryCondition( ...
    Uy, FixedDirections, ...
    BoundaryIntegrator, Boundary, ...
    ConstrainingAlgorithm );

% Register condition at analysis
Analysis.addDirichletBoundaryCondition( ...
    OuterCondition );
Analysis.addDirichletBoundaryCondition( ...
    InnerConditionX );
Analysis.addDirichletBoundaryCondition( ...
    InnerConditionY );

% Run analysis
Analysis.solve();

%% Post processing

analyticalSolutionPolar = @(r, theta) [ - 0.5*r*log(r)/log(2); 0];
analyticalSolutionCartesian = @(globalCoords) polarToCartesian2DVector( globalCoords(1), globalCoords(2), analyticalSolutionPolar );
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
l2Error = L2Error( ...
    loadCaseToVisualize, ...
    analyticalSolutionCartesian );

% Surface Plots
FeMesh = Analysis.getMesh();
gridSize = 0.05;
postProcessingFactory = ...
    VisualPostProcessingFactory2DFCM( ...
    FeMesh,	AnnularPlate, ...
    indexOfPhysicalDomain, gridSize, ...
    {OuterBoundaryFactory, ...
    InnerBoundaryFactory} );
postProcessor = ...
    postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( ...
    displacementNorm );
postProcessor.registerPointProcessor( ...
    vonMises );
postProcessor.registerPointProcessor( ...
    solutionError );

postProcessor.visualizeResults( FeMesh );

set(gca,'YTick',[]);
set(gca,'XTick',[]);
xlabel('');
ylabel('');
cb = colorbar('location', 'southoutside');

% Plot Over Line
startPoint = [ 0 0 0 ];
endPoint = [ 1 0.5 0 ];
numberOfSegments = 100;

postProcessingFactory = PlotOverLinePostProcessingFactory( startPoint, endPoint, numberOfSegments );
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( displacementNorm );
postProcessor.registerPointProcessor( vonMises );
postProcessor.registerPointProcessor( l2Error );

postProcessor.visualizeResults( FeMesh );

%% Integration Post Processing

postProcessor = IntegrationPostProcessor( );

postProcessor.registerPointProcessor( strainEnergy );
postProcessor.registerPointProcessor( l2Error );

integrals = postProcessor.integrate( FeMesh );
