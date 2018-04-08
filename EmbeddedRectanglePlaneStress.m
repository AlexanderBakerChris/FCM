%=======================================================================%
%                     ______________  _____          __                 %
%                    / ____/ ____/  |/  / /   ____ _/ /_                %
%                   / /_  / /   / /|_/ / /   / __ `/ __ \               %
%                  / __/ / /___/ /  / / /___/ /_/ / /_/ /               %
%                 /_/    \____/_/  /_/_____/\__,_/_.___/                %
%                                                                       %
%                                                                       %
% Copyright (c) 2012, 2013                                              %
% Chair for Computation in Engineering, Technical University Muenchen   %
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
% we ask the authors to cite the introductory article "xxxxx" published %
% in yyyyy:                                                             %
%                                                                       %
% N. Zander, T. Bog, M. Elhaddad, R. Espinoza, H. Hu, A. F. Joly,       %
% C. Wu, P. Zerbe, S. Kollmannsberger, D. Schillinger, M. Ruess,        %
% A. Duester, E. Rank. FCMLab: A Finite Cell Research Toolbox for	    %
% MATLAB, AGREATJOURNAL, xxxx, 2013                                     %
%                                                                       %
%=======================================================================%


%% Preliminarities
clear all;
close all;

% Set path for Logger
Logger.setPathForLogger('EmbeddedRectanglePlaneStress.m','EmbeddedRectanglePlaneStress.log',0);
Logger.ConsoleLevel('debug');

%% Embedded Domain Setup
Origin = [ 0.0 0.0 0.0 ];
Lengths = [ 1.0 1.0 ];

% Create the domain
Rectangle = EmbeddedRectangle( Origin, Lengths );

%% Material Setup
YoungsModulus = 1.0;
PoissonsRatio = 0.3;
Density = 1.0;
Alpha = 0;

% Material for the void (background) domain
Materials(1) = HookePlaneStress( YoungsModulus, PoissonsRatio, ...
    Density, Alpha );

% Material for the actual domain
Materials(2) = HookePlaneStress( YoungsModulus, PoissonsRatio, ...
    Density, 1 );

%% Mesh Setup

% Step 1: decide on element type
PolynomialDegree = 7;
NumberOfGaussPoints = PolynomialDegree+1;
SpaceTreeDepth = 1;

ElementFactory = ElementFactoryElasticQuadFCM( Materials, Rectangle, ...
    NumberOfGaussPoints, SpaceTreeDepth );

% Step 2: create the mesh
MeshOrigin = [0.0 0.0 0.0];
MeshLengthX = 4.0/3.0;
MeshLengthY = 4.0/3.0;
NumberOfXDivisions = 2;
NumberOfYDivisions = 2;
DofDimension = 2;

MeshFactory = MeshFactory2DUniform( NumberOfXDivisions, ...
    NumberOfYDivisions, PolynomialDegree, TopologicalSorting, ...
    DofDimension, MeshOrigin, MeshLengthX, MeshLengthY, ElementFactory );

%% Analysis Setup

% Decide on anlysis type
Analysis = QuasiStaticAnalysis( MeshFactory );

%% Apply Body Load

% Analytical description of body force
bx  = @(x,y,z) ...
    - ( ( 1 - PoissonsRatio ) * ( 35 * power( x, 4 ) * power( y, 6 ) + ...
        6 * power( x, 2 ) * y ) * YoungsModulus ) / ...
       ( 2 * ( 1 - PoissonsRatio * PoissonsRatio ) ) - ...
      ( 35 * PoissonsRatio * power( x, 4 ) * power( y, 6 ) * YoungsModulus ) / ...
      ( 1 - PoissonsRatio * PoissonsRatio ) ...
    - ( 2 * power( y, 3 ) * YoungsModulus ) / ( 1 - PoissonsRatio * PoissonsRatio );
by = @(x,y,z) ...
    - ( ( 1 - PoissonsRatio ) * ( 20 * power( x, 3 ) * power( y, 7 ) + ...
        6 * x * power( y, 2 ) ) * YoungsModulus ) / ...
      ( 2 * ( 1 - PoissonsRatio * PoissonsRatio ) ) - ...
      ( 42 * power( x, 5 ) * power( y, 5 ) * YoungsModulus ) / ...
      ( 1 - PoissonsRatio * PoissonsRatio ) ...
    - ( 6 * PoissonsRatio * x * power( y, 2 ) * YoungsModulus ) / ...
      ( 1 - PoissonsRatio * PoissonsRatio );

% Transform to vector function
BodyForce = @(x,y,z) [ bx(x,y,z); by(x,y,z)];

% Create new load case 
LoadCase = LoadCase();
LoadCase.addBodyLoad( BodyForce );

% Register load case at analysis
Analysis.addLoadCases( LoadCase );

%% Apply weak Dirichlet boundary conditions

% Select integration scheme
IntegrationScheme = GaussLegendre( NumberOfGaussPoints );

% Get geometrical description of boundary
NumberOfBoundarySegments = 3;
BoundaryFactory = RectangleBoundaryFactory( Origin, Lengths, NumberOfBoundarySegments );
Boundary = BoundaryFactory.getBoundary();

% Selet constraining strategy
Beta = 0;
ConstrainingAlgorithm = WeakNitscheDirichlet2DAlgorithm( Beta );

% Give analytical description of boundary values
ux = @(x,y,z) power( x, 2 ) * power( y, 3 );
uy = @(x,y,z) power( x, 5 ) * power( y, 7 );

% Create boundary condition in X
ConstrainedDirections = [1 0];
BoundaryConditionX = WeakDirichletBoundaryCondition( ux, ConstrainedDirections, ...
    IntegrationScheme, Boundary, ConstrainingAlgorithm );

% Create boundary condition in Y
ConstrainedDirections = [0 1];
BoundaryConditionY = WeakDirichletBoundaryCondition( uy, ConstrainedDirections, ...
    IntegrationScheme, Boundary, ConstrainingAlgorithm );

% Register conditions at analysis
Analysis.addDirichletBoundaryCondition( BoundaryConditionX );
Analysis.addDirichletBoundaryCondition( BoundaryConditionY );

%% Run the analysis

Analysis.solve();


%% Post processing

% Create result point processors
IndexOfPhysicalDomain = 2;
LoadCaseToVisualize = 1;

% Displacement
DisplacementNorm = DisplacementNorm( LoadCaseToVisualize );

% Stress
VonMises = VonMisesStress( LoadCaseToVisualize, IndexOfPhysicalDomain );

% Energy
StrainEnergy = StrainEnergy( LoadCaseToVisualize, IndexOfPhysicalDomain );

% Error
AnalyticalSolutionCartesian = @(globalCoords) ...
    [ ux( globalCoords(1), globalCoords(2), globalCoords(3) ); ...
      uy( globalCoords(1), globalCoords(2), globalCoords(3) ) ];
L2Error = L2Error( LoadCaseToVisualize, AnalyticalSolutionCartesian );

%% Perform Visual Post Processing
PostProcessingGridSize = 0.05;
SolutionNumbersToWarp = 1;
WarpScalingFactor = 1;

FeMesh = Analysis.getMesh();

% Decide on post processor type
PostProcessingFactory = VisualPostProcessingFactory2DFCMWarped( ...
    FeMesh, Rectangle, IndexOfPhysicalDomain, PostProcessingGridSize, ...
    SolutionNumbersToWarp, WarpScalingFactor );

PostProcessor = PostProcessingFactory.creatVisualPostProcessor( );

% Register result point processors
PostProcessor.registerPointProcessor( DisplacementNorm );
PostProcessor.registerPointProcessor( VonMises );
PostProcessor.registerPointProcessor( L2Error );

% Visualize results
PostProcessor.visualizeResults( FeMesh );

%% Perform Integration Post Processing

% Decide on post processor type
PostProcessor = IntegrationPostProcessor( );

% Register result point processors
PostProcessor.registerPointProcessor( StrainEnergy );

% Integrate the results over the domain
NumercialStrainEnergy = PostProcessor.integrate( FeMesh );

% Compare to analytical solution
AnalyticalStrainEnergy = ...
    ( ( 117403 * PoissonsRatio - 1378393 ) * YoungsModulus ) / ...
      ( 390 * ( 6930 * PoissonsRatio * PoissonsRatio - 6930 ) );

Error = 100*sqrt( abs( 1 - NumercialStrainEnergy / AnalyticalStrainEnergy ));

Logger.Log(['Relative Error: ', num2str( Error, '%e\n' ) ],'release');
