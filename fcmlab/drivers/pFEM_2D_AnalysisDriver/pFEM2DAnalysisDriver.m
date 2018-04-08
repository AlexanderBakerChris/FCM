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
 
% 2D p-FEM - Driver file 

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('pFEM2DAnalysisDriver.m','log2DpFEM.out',1);


%% Input parameters
% Numerical parameters
MeshOrigin = [0.0 0.0 0.0];
NumberOfXDivisions = 40;
NumberOfYDivisions = 5;
PolynomialDegree = 2;
NumberOfGaussPoints = PolynomialDegree+1; % number of Gauss points

PenaltyValue = 10E10;

% Mechanical parameters
E = 4.0E6;
PoissonsRatio = 0.0;
MeshLengthX = 10.0;
MeshLengthY = 1.0;
Density = 1.0;

%% Instanciation of the problem
Material = HookePlaneStress(E,PoissonsRatio,Density,1.0);

% Creation of the FEM system
DofDimension = 2;

MyElementFactory = ElementFactoryElasticQuad(Material,NumberOfGaussPoints);

MyMeshFactory = MeshFactory2DUniform(NumberOfXDivisions,...
    NumberOfYDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
    DofDimension,MeshOrigin,MeshLengthX,MeshLengthY,MyElementFactory);

MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);

% Loads
Load = WeakEdgeNeumannBoundaryCondition([0.0,MeshLengthY,0.0],[MeshLengthX,MeshLengthY,0.0],GaussLegendre(NumberOfGaussPoints),@(x,y,z)[0.0;-(100.0*x/MeshLengthX)]);
LoadCase = LoadCase();
LoadCase.addNeumannBoundaryCondition(Load);

MyAnalysis.addLoadCases(LoadCase);

% Dirichlet BC
% Restrict movement in x-direction along the edge
SupportEdge = StrongEdgeDirichletBoundaryCondition([0.0 0.0 0.0],[0.0 MeshLengthY 0.0],@(x,y,z)(0.0),[1 0],StrongPenaltyAlgorithm(PenaltyValue));
% Restrict movement in y-direction at the bottom node of this edge
SupportNode = StrongNodeDirichletBoundaryCondition([0.0 0.0 0.0],0.0,[0 1],StrongPenaltyAlgorithm(PenaltyValue));


MyAnalysis.addDirichletBoundaryCondition(SupportEdge);
MyAnalysis.addDirichletBoundaryCondition(SupportNode);

MyAnalysis.solve;

Domain = PseudoDomain();

%% Post Processing
indexOfPhysicalDomain = 1;

FeMesh = MyAnalysis.getMesh();

% create the point processors 
loadCaseToVisualize = [ 1 ];

% Surface Plots
gridSizes = [ 1 0.25] ;
warpScalingFactor = 5;

postProcessingFactory = VisualPostProcessingFactory2DWarped( FeMesh, gridSizes, loadCaseToVisualize, warpScalingFactor);
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @DisplacementNorm, { loadCaseToVisualize } );
postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );

postProcessor.visualizeResults( FeMesh );
