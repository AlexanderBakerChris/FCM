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
 
%% 3D p-FEM - Driver file 

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('pFEM3DAnalysisDriver.m','log3DpFEM.out',1);

%% Input parameters
% Numerical parameters
MeshOrigin = [0 0 0];
NumberOfXDivisions = 1;
NumberOfYDivisions = 3;
NumberOfZDivisions = 2;
PolynomialDegree = 4;
NumberOfGaussPoints = PolynomialDegree + 1; % number of Gauss points

% Mechanical parameters
E = 1.0;
PoissonsRatio = 0.3;
Lx = 1;
Ly = 2;
Lz = 3;
Density = 1.0;

%% Instanciation of the problem
Material = Hooke3D(E,PoissonsRatio,Density,1);

% Creation of the FEM system
DofDimension = 3;

MyElementFactory = ElementFactoryElasticHexa(Material,NumberOfGaussPoints);

MyMeshFactory = MeshFactory3DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
    DofDimension,MeshOrigin,Lx,Ly,Lz,MyElementFactory);

MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);

% % Loads
% Load = WeakEdgeNeumannBoundaryCondition([0,Ly/2,Lz],[Lx,Ly/2,Lz],GaussLegendre(NumberOfGaussPoints),@(x,y,z)[0;0;(+100*x/Lx)]);
LoadCase1 = LoadCase();
% LoadCase1.addNeumannBoundaryCondition(Load);
% 
% Load = WeakFaceNeumannBoundaryCondition([Lx,0,0],[Lx,Ly,Lz],GaussLegendre(NumberOfGaussPoints),@(x,y,z)[0;0;-500]);
% % Load = WeakFaceNeumannBoundaryCondition([0,0,Lz],[Lx,Ly,Lz],GaussLegendre(NumberGP),@(x,y,z)[0;0;-500]);
% LoadCase2 = LoadCase();
% LoadCase2.addNeumannBoundaryCondition(Load);
% 
% LoadCase3 = LoadCase();
% LoadCase3.addNeumannBoundaryCondition(Load);
% 
% 
% % Load = Gravity(10);
% LoadCase4 = LoadCase();
% LoadCase4.addBodyLoad(@(x,y,z)[0;0;-100]);
% LoadCase4.addBodyLoad(@(x,y,z)[0;0;-300]);
% 
% % Choice of load
MyAnalysis.addLoadCases(LoadCase1);

% Dirichlet boundary conditions
startPoint = MeshOrigin;

integrationScheme = GaussLegendre(NumberOfGaussPoints);
beta= 1E9;

Support1 = WeakFaceDirichletBoundaryCondition(startPoint,[Lx Ly 0.0],integrationScheme,@(x,y,z)(0),[0 0 1],WeakPenaltyAlgorithm(beta));
Support2 = WeakFaceDirichletBoundaryCondition(startPoint,[0.0 Ly Lz],integrationScheme,@(x,y,z)(0),[1 0 0],WeakPenaltyAlgorithm(beta));
Support3 = WeakFaceDirichletBoundaryCondition(startPoint,[Lx 0.0 Lz],integrationScheme,@(x,y,z)(0),[0 1 0],WeakPenaltyAlgorithm(beta));

MyAnalysis.addDirichletBoundaryCondition(Support1);
MyAnalysis.addDirichletBoundaryCondition(Support2);
MyAnalysis.addDirichletBoundaryCondition(Support3);



Support1 = WeakFaceDirichletBoundaryCondition([0.0 0.0 Lz],[Lx Ly Lz],integrationScheme,@(x,y,z)(3.0),[0 0 1],WeakPenaltyAlgorithm(beta));
Support2 = WeakFaceDirichletBoundaryCondition([Lx 0.0 0.0],[Lx Ly Lz],integrationScheme,@(x,y,z)(1.0),[1 0 0],WeakPenaltyAlgorithm(beta));
Support3 = WeakFaceDirichletBoundaryCondition([0.0 Ly 0.0],[Lx Ly Lz],integrationScheme,@(x,y,z)(2.0),[0 1 0],WeakPenaltyAlgorithm(beta));

MyAnalysis.addDirichletBoundaryCondition(Support1);
MyAnalysis.addDirichletBoundaryCondition(Support2);
MyAnalysis.addDirichletBoundaryCondition(Support3);


%% Resolution 
[solution, strainEnergy] = MyAnalysis.solve;

sparse(solution)
num2str(strainEnergy,'%.9E')
%% Post Processing
% indexOfPhysicalDomain = 1;
% 
% FeMesh = MyAnalysis.getMesh();
% 
% % create the point processors 
% loadCaseToVisualize = [ 1 ];
% 
% % Surface Plots
% gridSizes = [ 1 0.25 0.25] ;
% warpScalingFactor = 5;
% 
% postProcessingFactory = VisualPostProcessingFactory3DWarped( FeMesh, gridSizes, loadCaseToVisualize, warpScalingFactor);
% postProcessor = postProcessingFactory.creatVisualPostProcessor( );
% 
% postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );
% postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );
% 
% postProcessor.visualizeResults( FeMesh );
