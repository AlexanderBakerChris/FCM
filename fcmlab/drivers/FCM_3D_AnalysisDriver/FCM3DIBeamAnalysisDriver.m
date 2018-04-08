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
Logger.setPathForLogger('FCM3DIBeamAnalysisDriver.m','log3DFCMiBeam.out',0);

Logger.ConsoleLevel('debug');

%% Input parameters
% Numerical parameters
MeshOrigin = [-0.1 -0.1 -0.1];
NumberOfXDivisions = 2;
NumberOfYDivisions = 4;
NumberOfZDivisions = 2;
PolynomialDegree = 5;
NumberOfGaussPoints = PolynomialDegree+1; % number of Gauss points

PenaltyValue = 1E12;
RefinementSteps = 3; %integration depth
Alpha = 1E-10;

% Mechanical parameters
E = 200e9; % Aluminium
PoissonsRatio = 0.3;
Density = 15000;

% Mesh Parameters
Lx = 0.70;
Ly = 6.40;
Lz = 0.80;

% Geometry parameters
Width = 0.5;   % total width (x)
Length = 6.2;  % total length of beam (y)
Height = 0.6;  % total height (z)
Thick1 = 0.02;  % thickness of flanges
Thick2 = 0.02;  % thickness of the girder
Circles = [3.1 0.15;1.5 0.15;4.7 0.15] ; % matrix of circular holes along girder [y1 r1; y2 r2;...]
                               % with yi being the middle point coordinate along girder

iBeam = IBeam(Width,Length,Height,Thick1,Thick2,Circles);
iBeamBoundaryFactory = IBeamBoundaryFactory(Width,Height,Thick1,Thick2);

%% Instanciation of the problem
Mat3DFCM(1) = Hooke3D(E,PoissonsRatio,Density,Alpha);
Mat3DFCM(2) = Hooke3D(E,PoissonsRatio,Density,1);

% Creation of the FEM system
DofDimension = 3;

MyElementFactory = ElementFactoryElasticHexaFCM(Mat3DFCM,iBeam,...
    NumberOfGaussPoints,RefinementSteps);

MyMeshFactory = MeshFactory3DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
    DofDimension,MeshOrigin,Lx,Ly,Lz,MyElementFactory);

MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);

MyLoadCase = LoadCase();
MyLoadCase.addBodyLoad(@(x,y,z)[0;0;-100]);

MyAnalysis.addLoadCases(MyLoadCase);

Boundary = iBeamBoundaryFactory.getBoundary;

WeakDirichletAlgorithm = WeakNitscheDirichlet3DAlgorithm(PenaltyValue);
Support = WeakDirichletBoundaryCondition(@(x,y,z)0,[1 1 1],GaussLegendre(NumberOfGaussPoints*4),Boundary,WeakDirichletAlgorithm);

% Support = StrongFaceDirichletBoundaryCondition(MeshOrigin,MeshOrigin+[Lx 0 Lz],@(x,y,z)(0),[1 1 1],StrongPenaltyAlgorithm(PenaltyValue));

MyAnalysis.addDirichletBoundaryCondition(Support);

MyAnalysis.solve;


%% Post Processing
indexOfPhysicalDomain = 2;
 
FeMesh = MyAnalysis.getMesh();
 
% create the point processors 
loadCaseToVisualize = 1; 
displacementNorm = DisplacementNorm( loadCaseToVisualize ); 
vonMises = VonMisesStress( loadCaseToVisualize, indexOfPhysicalDomain );
 
% Surface Plots
gridSize = [ 0.01 0.04 0.01];
postProcessingFactory = VisualPostProcessingFactory3DFCM( FeMesh, iBeam, indexOfPhysicalDomain, gridSize );
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );
postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );

postProcessor.visualizeResults( FeMesh );
