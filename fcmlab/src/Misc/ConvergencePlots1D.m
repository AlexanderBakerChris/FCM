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
 
% Class for convergence plots
%   compares numerical solutions of h and p refinements with analytical
%   solution (for the displacement)
classdef ConvergencePlots1D
        
    methods (Access = public)
        %% constructor
        function obj = ConvergencePlots1D(Material,A,MeshOrigin,L,DistributedLoad,EndLoad,...
                ExactSolution,VectorNumberOfDivisions,VectorPolynomialDegree,...
                NumberOfPoints)
            obj.Material  = Material;
            obj.A = A; obj.MeshOrigin = MeshOrigin; obj.L = L;
            obj.f = DistributedLoad; % function @(x)(...)
            obj.F = EndLoad;
            obj.VectorNumberOfDivisions = VectorNumberOfDivisions;
            obj.SizeH = size(VectorNumberOfDivisions,2);
            obj.VectorPolynomialDegree = VectorPolynomialDegree;
            obj.SizeP = size(VectorPolynomialDegree,2);
            obj.ExactSolution = ExactSolution; % function
            Resolution = L/(NumberOfPoints-1);
            obj.x = 0:Resolution:L;
        end
        %% plotHVersion
        function plotHVersion(obj)
             figure;
             screenSize = get(0, 'ScreenSize');
             set(gcf, 'Position', [0 0.06*screenSize(4) screenSize(3) screenSize(4)*0.8 ] ); % position and size
             NumberOfLines = floor(obj.SizeH/4-0.1)+1; % Number of lines for subplot, when there's 4 columns
             [AxisYMin,AxisYMax] = obj.setAxisValues();
             for i=1:obj.SizeH
                 NumberOfXDivisions = obj.VectorNumberOfDivisions(i);
                 obj.NumericalSolution = obj.computeNumericalSolution(NumberOfXDivisions,1);
                 subplot(NumberOfLines,4,i);
                 hgraph = plot(obj.x,obj.ExactSolution(obj.x),'-r',obj.x,obj.NumericalSolution,'-k');
                 axis([obj.x(1) obj.x(end) AxisYMin AxisYMax]);
                 xlabel('x');
                 title(['h=1/',int2str(NumberOfXDivisions)]);
             end
        end
        %% plotPVersion
        function plotPVersion(obj)
             figure;
             screenSize = get(0, 'ScreenSize');
             set(gcf, 'Position', [0 0.06*screenSize(4) screenSize(3) screenSize(4)*0.8 ] ); % position and size
             NumberOfLines = floor(obj.SizeP/4-0.1)+1; % Number of lines for subplot, when there's 4 columns
             [AxisYMin,AxisYMax] = obj.setAxisValues();
             for i=1:obj.SizeP
                 PolynomialDegree = obj.VectorPolynomialDegree(i);
                 obj.NumericalSolution = obj.computeNumericalSolution(1,PolynomialDegree);
                 subplot(NumberOfLines,4,i);
                 pgraph = plot(obj.x,obj.ExactSolution(obj.x),'-r',obj.x,obj.NumericalSolution,'-k');
                 axis([obj.x(1) obj.x(end) AxisYMin AxisYMax]);
                 xlabel('x');
                 title(['p=',int2str(PolynomialDegree)]);
             end
        end
        %% computeNumericalSolution
        function NumericalSolution = computeNumericalSolution(obj,NumberOfXDivisions,PolynomialDegree)
%             NumberGP = PolynomialDegree+1; % number of Gauss points
            NumberGP = 21; % number of Gauss points
            
            % Analysis
            Mat1D = [obj.Material obj.Material]; % to make it work with FCM
            
            % Creation of the FEM system
            MyElementFactory = ElementFactoryElasticBar(Mat1D,NumberGP);
            
            MyMeshFactory = MeshFactory1DUniform(NumberOfXDivisions,...
                PolynomialDegree,PolynomialDegreeSorting(),1,...
                obj.MeshOrigin,obj.L,MyElementFactory);
            
            MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);
            
            % Adding  point load
            PointLoad = NodalNeumannBoundaryCondition([obj.L 0 0],obj.F);
            
            % Adding line load
            
            loadCase = LoadCase();
            loadCase.addNeumannBoundaryCondition(PointLoad);
            loadCase.addBodyLoad(obj.f);
            
            MyAnalysis.addLoadCases([loadCase]);
            
            % Adding Dirichlet boundary conditions
            MyDirichletAlgorithm = StrongDirectConstrainingAlgorithm;
            PointSupport = StrongNodeDirichletBoundaryCondition([0 0 0],0,1,MyDirichletAlgorithm);
            
            MyAnalysis.addDirichletBoundaryCondition(PointSupport);
            
            % Resolution of the linear equation system
            MyAnalysis.solve;
            
            MyPostProcessorDisplacement = PostProcessor1DforDisplacement(MyMeshFactory.getLX(),size(obj.x,2));
            MyPostProcessorDisplacement.doPostprocessForComparisonHP(MyAnalysis.getMesh);
            NumericalSolution = MyPostProcessorDisplacement.getSolution(); % but PostProcessorSolution also gives the x values (see PostProcessord1D)
            NumericalSolution = NumericalSolution(2,:);
        end
        
        %% setAxisValues
        function [AxisYMin,AxisYMax] = setAxisValues(obj)
            AxisYMax = max(obj.ExactSolution(obj.x));
            AxisYMin = min(obj.ExactSolution(obj.x));
            AxisYDelta = AxisYMax - AxisYMin;
            AxisYMax = AxisYMax + AxisYDelta*0.1;
            AxisYMin = AxisYMin - AxisYDelta*0.1;
        end
    end
    
    properties (Access = private)
        Material
        A
        MeshOrigin
        L
        f
        F
        x
        ExactSolution % function of x
        NumericalSolution % values
        VectorNumberOfDivisions % h version
        SizeH
        VectorPolynomialDegree % p version
        SizeP
        ErrorH % matrix with number of DOFs and error values
    end
    
end