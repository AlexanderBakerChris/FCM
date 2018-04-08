%=======================================================================%
%                     ______________  _____          __                 %
%                    / ____/ ____/  |/  / /   ____ _/ /_                %
%                   / /_  / /   / /|_/ / /   / __ `/ __ \               %
%                  / __/ / /___/ /  / / /___/ /_/ / /_/ /               %
%                 /_/    \____/_/  /_/_____/\__,_/_.___/                %
%                                                                       %
%                                                                       %
% Copyright (c) 2012, 2013                                              %
% Chair for Computation in Engineering, Technical University Muenchen   %
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
% we ask the authors to cite the introductory article "xxxxx" published %
% in yyyyy:                                                             %
%                                                                       %
% N. Zander, T. Bog, M. Elhaddad, R. Espinoza, H. Hu, A. F. Joly,       %
% C. Wu, P. Zerbe, S. Kollmannsberger, D. Schillinger, M. Ruess,        %
% A. Duester, E. Rank. FCMLab: A Finite Cell Research Toolbox for	    %
% MATLAB, AGREATJOURNAL, xxxx, 2013                                     %
%                                                                       %
%=======================================================================%


%% Preliminarities
clear all;
close all;

% Set path for Logger
Logger.setPathForLogger('ExampleDriver.m','ExampleDriver.log',0);
Logger.ConsoleLevel('debug');

%% Embedded Domain Setup

%% Material Setup


%% Mesh Setup

% Step 1: decide on element type

% Step 2: create the mesh

%% Analysis Setup

% Decide on anlysis type

%% Apply Body Load

% Analytical description of body force

% Transform to vector function

% Create new load case 

% Register load case at analysis

%% Apply weak Dirichlet boundary conditions

% Select integration scheme

% Get geometrical description of boundary

% Selet constraining strategy

% Give analytical description of boundary values

% Create boundary condition in X

% Create boundary condition in Y

% Register conditions at analysis

%% Run the analysis

Analysis.solve();


%% Post processing

% Create result point processors


%% Perform Visual Post Processing

% Decide on post processor type

% Register result point processors

% Visualize results

%% Perform Integration Post Processing

% Decide on post processor type

% Register result point processors

% Integrate the results over the domain

% Compare to analytical solution
