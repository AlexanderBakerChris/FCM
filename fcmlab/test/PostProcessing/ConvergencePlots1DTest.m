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
 
%% Test class for the comparative convergence plots

classdef ConvergencePlots1DTest < TestCase
    
    properties
        ConvergencePlots
    end
    
    methods
        
        %% constructor
        function obj = ConvergencePlots1DTest(name)
            obj = obj@TestCase(name);
        end
        
        %% Setup
        function setUp(obj)
            % Numerical parameters
            VectorNumberOfDivisions = 1:2;
            VectorPolynomialDegree = 1:3;
            NumberOfPoints = 10; % number of points for output plots
            % Mechanical parameters
            E = 1;      % Young's modulus
            A = 1;      % cross-sectional area
            Mat1D = Hooke1D(A,E,5,1);
            MeshOrigin = 0;
            L = 1;      % length
            % Loads
            F = 1;      % point load at the end of the bar
            fHandle = @(x,y,z)(x^2); % distributed load
            AnalyticalSolution = @(x)(x);
                % this is not the true analytical solution, but it's just
                % for the test
            obj.ConvergencePlots = ConvergencePlots1D(Mat1D,A,MeshOrigin,L,fHandle,F,...
                AnalyticalSolution,VectorNumberOfDivisions,VectorPolynomialDegree,...
                NumberOfPoints);
        end
        
        %% Teardown
        function tearDown(obj)
            close all;
        end
        
        %% testSetAxisValues
        % tests if the min and max of Y axis are correctyl calculated
        function testSetAxisValues(obj)
            [AxisYMin,AxisYMax] = obj.ConvergencePlots.setAxisValues();
            % Max and min value according to given analytical solution
            assertEqual(AxisYMin,-0.1);
            assertEqual(AxisYMax,1.1);
        end
        
        %% testComputeNumericalSolution
        % just tests if the function runs without any problem
        function testComputeNumericalSolution(obj)
            obj.ConvergencePlots.computeNumericalSolution(2,2);
        end
        %% testPlotHVersion
        % same
        function testPlotHVersion(obj)
            obj.ConvergencePlots.plotHVersion();
        end
        
        %% testPlotPVersion
        % same
        function testPlotPVersion(obj)
            obj.ConvergencePlots.plotPVersion();
        end
        
    end
end