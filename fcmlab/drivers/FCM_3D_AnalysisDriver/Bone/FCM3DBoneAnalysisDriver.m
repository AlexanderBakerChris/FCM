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
 
%% 3D FCM - Driver file - Bone

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('FCM3DBoneAnalysisDriver.m','log3DFCMBone.out',1);

Logger.ConsoleLevel('debug');

%% Input parameters
% Numerical parameters
MeshOrigin = [-33.125 -72.5 0]; % offset values from the voxel file
NumberOfXDivisions = 3;
NumberOfYDivisions = 3;
NumberOfZDivisions = 5;
PolynomialDegree = 2;
NumberOfGaussPoints = PolynomialDegree+1; % number of Gauss points

PenaltyValue = 1E6;
RefinementSteps = 3; %integration depth
Alpha = 1E-10;

% Mesh Parameters in mm
Lx = 50;
Ly = 100;
Lz = 150;

% Mechanical parameters of a human bone
% Values consulted from Fundamental Biomechanics in Bone Tissue Engineering
% by X. Wang, Morgan & Claypool Publishers. 
% Available in google books, starting from Chapter 4, page 75.
E = 15.2E3; % N mm^-2 (MPa) for a femur in compression Table 4.3
PoissonsRatio = 0.4; % The real value is 0.58 Table 4.5
Density = 1500E-9; % average density in kg mm^-3 (source: wikipedia)

% Bone parameters
VoxelDataFile = 'BoneFF1_CTdata_cut.txt';
Bone = VoxelDomain(VoxelDataFile);

BinarySTLFile = 'sphere.stl';
LoadSurfaceFactory = STLBoundaryFactory(BinarySTLFile);

% 
%% Instanciation of the problem
Mat3DFCM(1) = Hooke3D(E,PoissonsRatio,Density,Alpha);
Mat3DFCM(2) = Hooke3D(E,PoissonsRatio,Density,1);

% Creation of the FEM system

DofDimension = 3;

MyElementFactory = ElementFactoryElasticHexaFCM(Mat3DFCM,Bone,...
    NumberOfGaussPoints,RefinementSteps);

MyMeshFactory = MeshFactory3DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
    DofDimension,MeshOrigin,Lx,Ly,Lz,MyElementFactory);

Analysis = QuasiStaticAnalysis(MyMeshFactory);

% % Load = Gravity3D(Density);
LoadBoundary = LoadSurfaceFactory.getBoundary();
pressure = -1; % [N/mm^2] ( should be about 1000N = 100Kg in the integral)
Traction = @(x,y,z) [0;0; pressure];
Load = WeakNeumannBoundaryCondition(Traction,GaussLegendre(NumberOfGaussPoints),LoadBoundary);

LoadCase = LoadCase();
LoadCase.addNeumannBoundaryCondition(Load);
Analysis.addLoadCases(LoadCase);

Support = StrongFaceDirichletBoundaryCondition(MeshOrigin,MeshOrigin+[Lx Ly 0],@(x,y,z)(0),[1 1 1],StrongPenaltyAlgorithm(PenaltyValue));

Analysis.addDirichletBoundaryCondition(Support);
 
Analysis.solve; 

%% Post Processing
indexOfPhysicalDomain = 2;
 
FeMesh = Analysis.getMesh();
 
% create the point processors 
loadCaseToVisualize = 1; 
displacementNorm = DisplacementNorm( loadCaseToVisualize ); 
vonMises = VonMisesStress( loadCaseToVisualize, indexOfPhysicalDomain );
 
% Surface Plots
gridSize = [ 1.25 2.5 3.75 ];
postProcessingFactory = VisualPostProcessingFactory3DFCMandSTL( FeMesh, Bone, indexOfPhysicalDomain, gridSize, LoadSurfaceFactory );
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );
postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );

postProcessor.visualizeResults( FeMesh );

% set color scaling for stresses
caxis([0 30]);
view(54,27);
xlabel('');
ylabel('');
zlabel('');
set(gcf, 'Position', [100 100 351 400])