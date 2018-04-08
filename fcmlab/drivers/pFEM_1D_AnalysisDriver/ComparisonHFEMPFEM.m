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
 
%% Plots comparing h and p convergence

%% Preliminarities
clear all; close all;
% Set path for Logger
Logger.setPathForLogger('ComparisonHFEMPFEM.m','log1Dconvergence.out',0);

%% Input parameters
% Numerical parameters
MyVectorNumberOfDivisions = 1:8;
MyVectorPolynomialDegree = 1:8;
MyNumberOfPoints = 300; % number of points for output plots
MeshOrigin = 0;

% Mechanical parameters
E = 1.0;      % Young's modulus
Density = 1.0;
A = 1.0;      % cross-sectional area
L = 1.0;      % length

Mat1D = Hooke1D(A,E,Density,1);

% Loads
F = 0.0;      % point load at the end of the bar
fHandle = @(x,y,z)(- sin(8*x)); % distributed load
AnalyticalSolution = @(x)(-1/(64*E*A)*sin(8*x)+(F+1/8*cos(8*L))*x);

%% Convergence plots
MyConvergencePlots = ConvergencePlots1D(Mat1D,A,MeshOrigin,L,fHandle,F,...
    AnalyticalSolution,MyVectorNumberOfDivisions,MyVectorPolynomialDegree,...
    MyNumberOfPoints);
MyConvergencePlots.plotHVersion();
MyConvergencePlots.plotPVersion();