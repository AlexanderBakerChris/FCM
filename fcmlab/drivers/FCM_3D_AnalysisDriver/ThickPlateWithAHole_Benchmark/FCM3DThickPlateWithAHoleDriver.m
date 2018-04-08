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
 
%% 3D FCM - Driver file - I-beam

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('FCM3DThickPlateWithAHoleDriver.m','log3DFCMPlateWithAHole.out',0);

Logger.ConsoleLevel('debug');

%% Input parameters
% Numerical parameters
meshOrigin = [0.0 0.0 0.0];

numberOfXDivisions = 4;
numberOfYDivisions = 4;
numberOfZDivisions = 1;

ansatzOrder = 3;

integrationOrder = ansatzOrder+1; % number of Gauss points

refinementDepth = 4;
alpha = 1E-10;

% Mechanical parameters
E = 206900;
poissonsRatio = 0.29;
density = 1;

% Geometry parameters
width = 10;
height = 10;
thickness = 1;

holeCenter = [ width 0.0]; % Lower Right Corner
holeRadius = 1;
                               
% Mesh Parameters
Lx = width;
Ly = height;
Lz = thickness;
          
% Domain
plate = EmbeddedThickPlateWithAHole( meshOrigin, [ width height thickness ], holeCenter, holeRadius);

%% Instanciation of the problem
mat3DFCM(1) = Hooke3D(E,poissonsRatio,density,alpha);
mat3DFCM(2) = Hooke3D(E,poissonsRatio,density,1);

% Creation of the FEM system
dofDimension = 3;

myElementFactory = ElementFactoryElasticHexaFCM(mat3DFCM,plate,...
    integrationOrder,refinementDepth);

myMeshFactory = MeshFactory3DUniform(numberOfXDivisions,...
    numberOfYDivisions,numberOfZDivisions,ansatzOrder,PolynomialDegreeSorting(),...
    dofDimension,meshOrigin,Lx,Ly,Lz,myElementFactory);

myAnalysis = QuasiStaticAnalysis(myMeshFactory);

% Traction
myLoadCase = LoadCase();

tractionStartPoint = meshOrigin + [0.0 height 0.0];
tractionEndPoint = meshOrigin + [width height thickness];
tractionValue = @(x,y,z) [0; 100; 0;];

integrationScheme = GaussLegendre(integrationOrder);

traction = WeakFaceNeumannBoundaryCondition(tractionStartPoint, tractionEndPoint, integrationScheme, tractionValue );

myLoadCase.addNeumannBoundaryCondition( traction );

myAnalysis.addLoadCases(myLoadCase);

% Symmetry Boundary Conditions

% XY
startPoint = meshOrigin;
endPoint = meshOrigin + [ width height 0.0 ];
fixedDirection = [0 0 1];

boundaryConditionXY = StrongFaceDirichletBoundaryCondition(startPoint,endPoint,@(x,y,z)(0),fixedDirection ,StrongDirectConstrainingAlgorithm);

startPoint = meshOrigin + [width 0.0 0.0];
endPoint = startPoint + [ 0.0 height thickness ];
fixedDirection = [1 0 0];

boundaryConditionYZ = StrongFaceDirichletBoundaryCondition(startPoint,endPoint,@(x,y,z)(0),fixedDirection ,StrongDirectConstrainingAlgorithm);

startPoint = meshOrigin;
endPoint = meshOrigin + [ width 0.0 thickness ];
fixedDirection = [0 1 0];

boundaryConditionZX = StrongFaceDirichletBoundaryCondition(startPoint,endPoint,@(x,y,z)(0),fixedDirection ,StrongDirectConstrainingAlgorithm);

myAnalysis.addDirichletBoundaryCondition(boundaryConditionXY );
myAnalysis.addDirichletBoundaryCondition(boundaryConditionYZ );
myAnalysis.addDirichletBoundaryCondition(boundaryConditionZX );

[ ~, strainEnergy ] = myAnalysis.solve;

%% Post Processing
indexOfPhysicalDomain = 2;
 
FeMesh = myAnalysis.getMesh();
 
% create the point processors 
loadCaseToVisualize = 1; 
displacementNorm = DisplacementNorm( loadCaseToVisualize ); 
vonMises = VonMisesStress( loadCaseToVisualize, indexOfPhysicalDomain );
 
% Surface Plots
gridSize = [ 0.1 0.1 0.1];
postProcessingFactory = VisualPostProcessingFactory3DFCM( FeMesh, plate, indexOfPhysicalDomain, gridSize );
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );
postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );

postProcessor.visualizeResults( FeMesh );



% % integration Postprocessing
% 
% postProcessor = IntegrationPostProcessor( );
% 
% strainEnergy = StrainEnergy( ...
%     loadCaseToVisualize, ...
%     indexOfPhysicalDomain );
% 
% postProcessor.registerPointProcessor( strainEnergy );
% 
% integrals = postProcessor.integrate( FeMesh );
