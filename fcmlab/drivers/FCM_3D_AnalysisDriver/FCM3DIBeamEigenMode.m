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
shifting = 0.125;

MeshOrigin = [-shifting 0.0 -shifting];
NumberOfXDivisions = 5;
NumberOfYDivisions = 5;
NumberOfZDivisions = 5;
PolynomialDegree = 3;
NumberOfGaussPoints = PolynomialDegree+1; % number of Gauss points

PenaltyValue = 1E20;
RefinementSteps = 1; %integration depth
Alpha = eps;

% Mechanical parameters
E = 2e11; % N m^-2 
PoissonsRatio = 0.0; % The real value is 0.58 Table 4.5
Density = 7850; % Kg/m3

% Mesh Parameters
% Lx = 1.2;
% Ly = 12.0;
% Lz = 1.2;
Lx = 1+2*shifting;
Ly = 10.0;
Lz = 1+2*shifting;

% Geometry parameters
Width = 1;   % total width (x)
Length = 10;  % total length of beam (y)
Height = 1;  % total height (z)
Thick1 = 0.25;  % thickness of flanges
Thick2 = 0.25;  % thickness of the girder
% Circles = [3.1 0.15;1.5 0.15;4.7 0.15] ; % matrix of circular holes along girder [y1 r1; y2 r2;...]
numberOfHoles = 0;
relativeSpacing = 1;

iBeam = IBeamWithEllipticHoles(Width,Length,Height,Thick1,Thick2, numberOfHoles, relativeSpacing);

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

MyAnalysis = EigenmodeAnalysis(MyMeshFactory,10);

Boundary = iBeamBoundaryFactory.getBoundary;

% WeakDirichletAlgorithm = WeakNitscheDirichlet3DAlgorithm(PenaltyValue);
% Support = WeakDirichletBoundaryCondition(@(x,y,z)0,[1 1 1],GaussLegendre(NumberOfGaussPoints + 1),Boundary,WeakDirichletAlgorithm);

Support = StrongFaceDirichletBoundaryCondition(MeshOrigin,MeshOrigin+[Lx 0 Lz],@(x,y,z)(0),[1 1 1],StrongPenaltyAlgorithm(PenaltyValue));

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
gridSize = [ 1/32 1.0 1/32];
WarpScalingFactor = 10;
% postProcessingFactory = VisualPostProcessingFactory3DFCMWarped( ...
%     FeMesh, iBeam, indexOfPhysicalDomain, gridSize, ...
%     loadCaseToVisualize, WarpScalingFactor, iBeamBoundaryFactory );

postProcessingFactory = VisualPostProcessingFactory3DFCM( ...
    FeMesh, iBeam, indexOfPhysicalDomain, gridSize );
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );


postProcessor.visualizeResults( FeMesh );


shading interp;
light;
lighting phong;

view([135 24]);
colorbar off;
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'ZTick',[]);
xlabel('');
ylabel('');
zlabel('');
axis tight;
grid on;
box off;
axis off;

