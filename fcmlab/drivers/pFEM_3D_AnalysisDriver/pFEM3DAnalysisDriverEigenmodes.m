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
Logger.setPathForLogger('pFEM3DAnalysisDriverEigenmodes.m','log3DpFEM.out',0);

%% Input parameters
% Numerical parameters
MeshOrigin = [0 0 0];
NumberOfXDivisions = 5;
NumberOfYDivisions = 2;
NumberOfZDivisions = 2;
PolynomialDegree = 2;
NumberOfGaussPoints = PolynomialDegree+1; % number of Gauss points

% Mechanical parameters
E = 2.0e11;
PoissonsRatio = 0.0;
Lx = 10;
Ly = 1;
Lz = 1;
Density = 7.85e3;

PenaltyValue = 1e20;

%% Instanciation of the problem
Material = Hooke3D(E,PoissonsRatio,Density,1);

% Creation of the FEM system
DofDimension = 3;

MyElementFactory = ElementFactoryElasticHexa(Material,NumberOfGaussPoints);

MyMeshFactory = MeshFactory3DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
    DofDimension,MeshOrigin,Lx,Ly,Lz,MyElementFactory);

MyAnalysis = EigenmodeAnalysis(MyMeshFactory,10);


% Dirichlet boundary conditions
% WeakDirichletAlgorithm = WeakNitscheDirichlet3DAlgorithm(PenaltyValue);
% Support = WeakFaceDirichletBoundaryCondition( [0 0 0], [0 Ly Lz], GaussLegendre(NumberOfGaussPoints), @(x,y,z) 0, [1 1 1], WeakDirichletAlgorithm );
% MyAnalysis.addDirichletBoundaryCondition(Support);


MyAlgorithm = StrongPenaltyAlgorithm(1E20);
Support = StrongFaceDirichletBoundaryCondition([0 0 0],[0 Ly Lz],@(x,y,z)(0),[1 1 1],MyAlgorithm);
MyAnalysis.addDirichletBoundaryCondition(Support);

%% Resolution 
MyAnalysis.solve;

% %% Post Processing
% indexOfPhysicalDomain = 1;
% 
% FeMesh = MyAnalysis.getMesh();
% 
% % create the point processors 
% loadCaseToVisualize = [1];
% 
% displacementNorm = DisplacementNorm( loadCaseToVisualize ); 
% vonMises = VonMisesStress( loadCaseToVisualize, indexOfPhysicalDomain );
% 
% % Surface Plots
% gridSizes = [ 0.4 0.2 0.2] ;
% warpScalingFactor = 15;
% 
% postProcessingFactory = VisualPostProcessingFactory3DWarped( FeMesh, gridSizes, loadCaseToVisualize, warpScalingFactor);
% postProcessor = postProcessingFactory.creatVisualPostProcessor( );
% 
% postProcessor.registerPointProcessor( displacementNorm );
% % postProcessor.registerPointProcessor( vonMises );
% 
% postProcessor.visualizeResults( FeMesh );
% 
% % Plot Over Line
% startPoint = [ 0 0 0 ];
% endPoint = [ 0 1 1 ];
% numberOfSegments = 100;
% 
% postProcessingFactory = PlotOverLinePostProcessingFactory( startPoint, endPoint, numberOfSegments );
% postProcessor = postProcessingFactory.creatVisualPostProcessor( );
% 
% postProcessor.registerPointProcessor( @SolutionVector, {loadCaseToVisualize});
% 
% postProcessor.visualizeResults( FeMesh );


%% Integration Post Processing

% strainEnergy = StrainEnergy( loadCaseToVisualize, indexOfPhysicalDomain );
% 
% integrationPostProcessor = IntegrationPostProcessor( );
% 
% integrationPostProcessor.registerPointProcessor( strainEnergy );
% integrationPostProcessor.registerPointProcessor( l2Error );
% 
% integrals = integrationPostProcessor.integrate( FeMesh );


