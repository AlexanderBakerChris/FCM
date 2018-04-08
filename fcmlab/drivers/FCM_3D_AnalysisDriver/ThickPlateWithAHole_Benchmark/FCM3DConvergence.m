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
Logger.setPathForLogger('FCM3DConvergence.m','log3DFCMconvergence.out',1);

Logger.ConsoleLevel('debug');

%% Input parameters
referenceStrainEnergy = 2.474811071E+00;

% Numerical parameters
meshOrigin = [0.0 0.0 0.0];

numberOfXDivisions = 2;
numberOfYDivisions = 2;
numberOfZDivisions = 1;

alpha = 1E-10;

% Mechanical parameters
E = 206900;
poissonsRatio = 0.29;
density = 1;

% Geometry parameters
width = 10;
height = 10;
thickness = 1;

holeCenter = [ width 0.0]; % Lower Right Corner
holeRadius = 1;
                               
% Mesh Parameters
Lx = width;
Ly = height;
Lz = thickness;
          
% Domain
plate = EmbeddedThickPlateWithAHole( meshOrigin, [ width height thickness ], holeCenter, holeRadius);

mat3DFCM(1) = Hooke3D(E,poissonsRatio,density,alpha);
mat3DFCM(2) = Hooke3D(E,poissonsRatio,density,1);


% boundary conditions

% Symmetry Boundary Conditions

startPoint = meshOrigin;
endPoint = meshOrigin + [ width height 0.0 ];
fixedDirection = [0 0 1];

boundaryConditionXY = StrongFaceDirichletBoundaryCondition(startPoint,endPoint,@(x,y,z)(0),fixedDirection ,StrongDirectConstrainingAlgorithm);

startPoint = meshOrigin + [width 0.0 0.0];
endPoint = startPoint + [ 0.0 height thickness ];
fixedDirection = [1 0 0];

boundaryConditionYZ = StrongFaceDirichletBoundaryCondition(startPoint,endPoint,@(x,y,z)(0),fixedDirection ,StrongDirectConstrainingAlgorithm);

startPoint = meshOrigin;
endPoint = meshOrigin + [ width 0.0 thickness ];
fixedDirection = [0 1 0];

boundaryConditionZX = StrongFaceDirichletBoundaryCondition(startPoint,endPoint,@(x,y,z)(0),fixedDirection ,StrongDirectConstrainingAlgorithm);

strongBoundaryConditions = {boundaryConditionXY, boundaryConditionYZ,boundaryConditionZX};

%% Instanciation
% 
% % % First Case
% outFileName = ['trial'];
% integrationRefinementDepths = [1 2];
% ansatzOrderStart = 2;
% ansatzOrderEnd = 4;
% [numberOfDofsDepth2, errorDepth2] = pRefinementConvergence(...
%     ansatzOrderStart, ansatzOrderEnd,...
%     numberOfXDivisions,numberOfYDivisions, numberOfZDivisions, ...
%     meshOrigin,Lx,Ly,Lz,...
%     mat3DFCM, integrationRefinementDepths,plate,...
%     strongBoundaryConditions,...
%     outFileName );

outFileName = ['trial'];
integrationRefinementDepths = [1 2];
ansatzOrder = 1;
minimumRefinementLevel = 0;
maximumRefinementLevel = 2;
[numberOfDofs, energyDepth2] = hRefinementConvergence(...
    minimumRefinementLevel, maximumRefinementLevel,...
    ansatzOrder, ...
    numberOfXDivisions,numberOfYDivisions, numberOfZDivisions, ...
    meshOrigin,Lx,Ly,Lz,...
    mat3DFCM, integrationRefinementDepths,plate,...
    strongBoundaryConditions,...
    outFileName);
% 


% relativeErrorInStrainEnergy = sqrt(abs(energyDepth2-referenceStrainEnergy)/referenceStrainEnergy)*100; % Relative error in energy norm [%]

% % plot only first case
% loglog(numberOfDofs,errorDepth2,'-o');
% xlabel('Degrees Of Freedom');
% ylabel('Relative Error In Energy Norm [%]');
% legend('2-recursive refinements');
% title('Convergence Rate');
