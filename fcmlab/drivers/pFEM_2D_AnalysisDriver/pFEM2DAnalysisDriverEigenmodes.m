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
 
%% 2D p-FEM - Driver file 

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('pFEM2DAnalysisDriverEigenmodes.m','log2DpFEMeigenmodes.out',1);

Logger.ConsoleLevel('release');

%% Input parameters
% Numerical parameters
MeshOrigin = [0 0];
NumberOfXDivisions = 10;
NumberOfYDivisions = 2;
PolynomialDegree = 5;
NumberOfGaussPoints = PolynomialDegree+1;

% Mechanical parameters
E = 4E6;
PoissonsRatio = 0.0;
Lx = 10;
Ly = 1;
Density = 1;

PenaltyValue = 10E10;
%% Instanciation of the problem
Material = HookePlaneStress(E,PoissonsRatio,Density,1);

% Creation of the FEM system
DofDimension = 2;

MyElementFactory = ElementFactoryElasticQuad(Material,NumberOfGaussPoints);

MyMeshFactory = MeshFactory2DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
    DofDimension,MeshOrigin,Lx,Ly,MyElementFactory);

numberOfEigenmodesToCompute = 100;
MyAnalysis = EigenmodeAnalysis(MyMeshFactory,numberOfEigenmodesToCompute);

Support = StrongEdgeDirichletBoundaryCondition([0 0 0],[0 Ly 0],@(x,y,z)(0),[1 1],StrongPenaltyAlgorithm(10E10));

MyAnalysis.addDirichletBoundaryCondition(Support);

MyAnalysis.solve();

Domain = PseudoDomain();

%% Post Processing
%% Post Processing
indexOfPhysicalDomain = 1;

FeMesh = MyAnalysis.getMesh();

% create the point processors 
loadCaseToVisualize = [ 1 2 ];

% Surface Plots
gridSizes = [ 1 0.25] ;
warpScalingFactor = 5;

postProcessingFactory = VisualPostProcessingFactory2DWarped( FeMesh, gridSizes, loadCaseToVisualize, warpScalingFactor);
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );
postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );

postProcessor.visualizeResults( FeMesh );
