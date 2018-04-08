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
 
%% 1D p-FEM - Driver file 

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('pFEM1DAnalysisDriver.m','log1DpFEM.out',1);

%% Input parameters
% Numerical parameters
MeshOrigin = 0;
NumberOfXDivisions = 10;
PolynomialDegree = 6;
NumberGP = PolynomialDegree+1; % number of Gauss points
MyNumberOfPoints = 300; % number of points for output plots

% Mechanical parameters
E = 1;      % Young's modulus
A = 1;      % cross-sectional area
L = 1;      % length
Density = 1;

% Loads
F = 1;      % point load at the end of the bar
DistributedLoad = @(x,y,z)(- sin(8*x)); % distributed load

%% Instanciation of the problem
Mat1D = Hooke1D(A,E,Density,1);
Mat1D = [Mat1D Mat1D]; % to make it work with FCM

% Creation of the FEM system

MyElementFactory = ElementFactoryElasticBar(Mat1D,NumberGP);
            
MyMeshFactory = MeshFactory1DUniform(NumberOfXDivisions,...
                PolynomialDegree,PolynomialDegreeSorting(),1,...
                MeshOrigin,L,MyElementFactory);

MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);

% Adding  point load
PointLoad = NodalNeumannBoundaryCondition([L 0 0],F);
PointLoad2 = NodalNeumannBoundaryCondition([L 0 0],2*F);

% Adding line load

LoadCase1 = LoadCase();
LoadCase1.addNeumannBoundaryCondition(PointLoad);

LoadCase2 = LoadCase();
LoadCase2.addBodyLoad(DistributedLoad);

MyAnalysis.addLoadCases([LoadCase2 LoadCase1]);

% Adding Dirichlet boundary conditions
MyDirichletAlgorithm = StrongPenaltyAlgorithm(10E4);
PointSupport = StrongNodeDirichletBoundaryCondition([0 0 0],0,1,MyDirichletAlgorithm);

MyAnalysis.addDirichletBoundaryCondition(PointSupport);

% Resolution of the linear equation system
MyAnalysis.solve;



%% Postprocessing
loadCaseToVisualize = 1;
indexOfPhysicalDomain = 2;

startPoint = [ 0 0 0 ];
endPoint = [ 1 0.5 0 ];
numberOfSegments = 100;

postProcessingFactory = PlotOverLinePostProcessingFactory( startPoint, endPoint, numberOfSegments );
postProcessor = postProcessingFactory.creatVisualPostProcessor( );

postProcessor.registerPointProcessor( @SolutionVector, { loadCaseToVisualize } );
postProcessor.registerPointProcessor( @VonMisesStress, { loadCaseToVisualize, indexOfPhysicalDomain } );

postProcessor.visualizeResults( MyAnalysis.getMesh() );