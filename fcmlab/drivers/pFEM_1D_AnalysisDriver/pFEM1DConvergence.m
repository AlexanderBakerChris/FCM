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
 
%% Driver file to observe convergence between p-Fem and h-Fem of a 1D problem
clear all;

% Set path for Logger
Logger.setPathForLogger('pFEM1DConvergence.m','log1Dconvergence.out',1);

% For the problem 2.2.1 given in the High Order FEM script:
AnalyticalSolution = 0.5*((cos(8)^2)/64 - (sin(8)*cos(8))/256 + 1/128 + sin(16)/2048);

% Numerical parameter
MeshOrigin = [0];

% Geometry
Area = 1; % cross sectional area
Length = 1;

% Material
E = 1; % young modulus
Density = 1;
Mat1D = Hooke1D(Area,E,Density,1);
Mat1D = [Mat1D Mat1D]; % to make it work with the pseudo domain

% Loads
DistributedLoad = @(x,y,z)(- sin(8*x)); % line load

loadCaseToVisualize = 1;
indexOfPhysicalDomain = 2;

%% p-FEM
NumberOfXDivisions = 5;
for PolynomialDegree = 1:8 % Increasing p refinement
    clear MyAnalysisFactory MyAnalysis MyPostProcessorStrainEnergy
    
    NumberGP = PolynomialDegree+1; % number of Gauss points
    
    % Analysis
    MyElementFactory = ElementFactoryElasticBar(Mat1D,NumberGP);
    MyMeshFactory = MeshFactory1DUniform(NumberOfXDivisions,...
        PolynomialDegree,PolynomialDegreeSorting(),1,...
        MeshOrigin,Length,MyElementFactory);
    
    MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);
    
    % Loads
    MyLoadCase = LoadCase();
    MyLoadCase.addBodyLoad(DistributedLoad);
    
    MyAnalysis.addLoadCases(MyLoadCase);
    
    % Boundary Conditions  
    MyDirichletAlgorithm = StrongPenaltyAlgorithm(10E4);
    PointSupport = StrongNodeDirichletBoundaryCondition([0 0 0],0,1,MyDirichletAlgorithm);
    
    MyAnalysis.addDirichletBoundaryCondition(PointSupport);
    
    % Solution of the analysis
    MyAnalysis.solve();
    
    % For p-FEM
    TotalStrainEnergy(PolynomialDegree) = MyAnalysis.getStrainEnergy;
    
end

ErrorOfPmethod=abs(TotalStrainEnergy-AnalyticalSolution)/AnalyticalSolution;

clear TotalStrainEnergy

%% h-FEM
PolynomialDegree = 1;
NumberGP = PolynomialDegree+1; % number of Gauss points

i=0;
for i=1:8
    clear MyAnalysisFactory MyAnalysis MyPostProcessorStrainEnergy
    
    NumberOfXDivisions = i*5;  
    
    % Analysis
    MyElementFactory = ElementFactoryElasticBar(Mat1D,NumberGP);
    MyMeshFactory = MeshFactory1DUniform(NumberOfXDivisions,...
        PolynomialDegree,PolynomialDegreeSorting(),1,...
        MeshOrigin,Length,MyElementFactory);
    
    MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);
    
    % Loads
    
    MyLoadCase = LoadCase();
    MyLoadCase.addBodyLoad(DistributedLoad);
    
    MyAnalysis.addLoadCases(MyLoadCase);
    
    
    % Boundary Conditions  
    MyDirichletAlgorithm = StrongPenaltyAlgorithm(10E4);
    PointSupport = StrongNodeDirichletBoundaryCondition([0 0 0],0,1,MyDirichletAlgorithm);
    
    MyAnalysis.addDirichletBoundaryCondition(PointSupport);
    
    % Solution of the analysis
    MyAnalysis.solve;
    
    % For h-FEM
    TotalStrainEnergy(i) = MyAnalysis.getStrainEnergy;

end

ErrorOfHmethod=abs(TotalStrainEnergy-AnalyticalSolution)/AnalyticalSolution;


%% Plot of convergence
loglog(5:5:40,ErrorOfPmethod,5:5:40,ErrorOfHmethod);
xlabel('Degrees Of Freedom');
ylabel('Relative Error In Strain Energy');
legend('p-version','h-version');
title('Convergence Rate');
axis([5 40 10E-16 1]);