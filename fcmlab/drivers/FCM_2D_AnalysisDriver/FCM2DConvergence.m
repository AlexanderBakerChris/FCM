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
 
%% Driver file to observe convergence of a FCM 2D problem

%% Preliminarities
clear all;
% Set path for Logger
Logger.setPathForLogger('FCM2DConvergence.m','log2DFCMconvergence.out',1);

Logger.ConsoleLevel('debug');

%% Input parameters
% Numerical parameters
MeshOrigin = [-1.1 -1.1 0];
NumberOfXDivisions = 4;
NumberOfYDivisions = 4;

PenaltyValue = 1E3;
Alpha = 1E-10;

% Mechanical parameters
E = 1;
PoissonsRatio = 0.0;
Density = 1;

% Material
Mat2DFCM(1) = HookePlaneStress(E,PoissonsRatio,Density,Alpha);
Mat2DFCM(2) = HookePlaneStress(E,PoissonsRatio,Density,1);

% Mesh Parameters
Lx = 2.2;
Ly = 2.2;

% Boundary Mesh
OuterRadius = 1.0;
InnerRadius = 0.25;
NumberOfSegments = 200;

Center = [0 0 0];
AnnularPlate = AnnularPlate(Center,OuterRadius, InnerRadius);
OuterBoundaryFactory = CircularBoundaryFactory(Center,OuterRadius,NumberOfSegments,true);
OuterBoundary = OuterBoundaryFactory.getBoundary();
InnerBoundaryFactory = CircularBoundaryFactory(Center,InnerRadius,NumberOfSegments,false);
InnerBoundary = InnerBoundaryFactory.getBoundary();

% PolynomialDegree from 1 to the following given value
upToPolynomialDegree = 3;

% First Case
RefinementSteps = 3; %integration depth
[Dofs3RecursiveRefinements, Error3RecursiveRefinements] = convergenceRecursiveRefinements(...
    NumberOfXDivisions,NumberOfYDivisions,upToPolynomialDegree,Mat2DFCM,MeshOrigin,Lx,Ly,RefinementSteps,AnnularPlate,OuterBoundary,InnerBoundary,PenaltyValue);

% % Second Case
% RefinementSteps = 5; %integration depth
% [Dofs5RecursiveRefinements, Error5RecursiveRefinements] = convergenceRecursiveRefinements(...
%     NumberOfXDivisions,NumberOfYDivisions,upToPolynomialDegree,Mat2DFCM,MeshOrigin,Lx,Ly,RefinementSteps,AnnularPlate,OuterBoundary,InnerBoundary,PenaltyValue);
% 
% % Third Case
% RefinementSteps = 9; %integration depth
% [Dofs9RecursiveRefinements, Error9RecursiveRefinements] = convergenceRecursiveRefinements(...
%     NumberOfXDivisions,NumberOfYDivisions,upToPolynomialDegree,Mat2DFCM,MeshOrigin,Lx,Ly,RefinementSteps,AnnularPlate,OuterBoundary,InnerBoundary,PenaltyValue);
% 
% % Fourth Case
% RefinementSteps = 10; %integration depth
% [Dofs10RecursiveRefinements, Error10RecursiveRefinements] = convergenceRecursiveRefinements(...
%     NumberOfXDivisions,NumberOfYDivisions,upToPolynomialDegree,Mat2DFCM,MeshOrigin,Lx,Ly,RefinementSteps,AnnularPlate,OuterBoundary,InnerBoundary,PenaltyValue);

% plot only first case
loglog(Dofs3RecursiveRefinements,Error3RecursiveRefinements,'-o');
xlabel('Degrees Of Freedom');
ylabel('Relative Error In Energy Norm [%]');
legend('3-recursive refinements');
title('Convergence Rate');

% % plot all cases
% loglog(Dofs3RecursiveRefinements,Error3RecursiveRefinements,'-o',...
%     Dofs5RecursiveRefinements,Error5RecursiveRefinements,'-s',...
%     Dofs9RecursiveRefinements,Error9RecursiveRefinements,'-d',...
%     Dofs10RecursiveRefinements,Error10RecursiveRefinements,'-x');
% xlabel('Degrees Of Freedom');
% ylabel('Relative Error In Energy Norm [%] ');
% legend('3-recursive refinements','5-recursive refinements','9-recursive refinements','10-recursive refinements');
% title('Convergence Rate');
