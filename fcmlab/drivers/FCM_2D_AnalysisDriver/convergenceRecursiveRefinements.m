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
 
function [Dofs,Error] = convergenceRecursiveRefinements(NumberOfXDivisions,NumberOfYDivisions,...
        givenPolynomialDegree,Mat2DFCM,MeshOrigin,Lx,Ly,RefinementSteps,AnnularPlate,OuterBoundary,InnerBoundary,PenaltyValue)

    Logger.Log(['Case with ',num2str(RefinementSteps),' refinement steps'],'release');
    
    Dofs = zeros(1,givenPolynomialDegree);
    TotalStrainEnergy = zeros(1,givenPolynomialDegree);
    
    loadCaseToVisualize = 1;
    indexOfPhysicalDomain = 2;
    
for PolynomialDegree = 1:givenPolynomialDegree % refine polynomial degree
    
    clear MyAnalysisFactory MyAnalysis functions % Clear functions is due to the persistant counter in element id
    
    Logger.Log(['PolynomialDegree = ',num2str(PolynomialDegree)],'release');
    
    NumberGP = PolynomialDegree+1; % number of Gauss points
    
    % Creation of the FEM system
    DofDimension = 2;
    
    MyElementFactory = ElementFactoryElasticQuadFCM(Mat2DFCM,AnnularPlate,...
        NumberGP,RefinementSteps);
    
    MyMeshFactory = MeshFactory2DUniform(NumberOfXDivisions,...
        NumberOfYDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
        DofDimension,MeshOrigin,Lx,Ly,MyElementFactory);
    
    MyAnalysis = QuasiStaticAnalysis(MyMeshFactory);
    
    % dAlembertForceFunctionHandle
    % br = 1/(r*log(2))
    polarbx = @(r,theta)1/(r*log(2))*cos(theta); % the handleFunction needs to be in r and theta
    polarby = @(r,theta)1/(r*log(2))*sin(theta);
    bx = @(x,y) polarToCartesian(x,y,polarbx);
    by = @(x,y) polarToCartesian(x,y,polarby);
    
    % Loads
    BodyLoad = @(x,y,z)[bx(x,y); by(x,y)];
    
    MyLoadCase = LoadCase();
    MyLoadCase.addBodyLoad(BodyLoad);
    MyAnalysis.addLoadCases(MyLoadCase);
    
    % ur(r) = 0.25
    % utheta(r) = 0
    polarUx = @(r,theta)0.25*cos(theta);
    polarUy = @(r,theta)0.25*sin(theta);
    Ux = @(x,y) polarToCartesian(x,y,polarUx);
    Uy = @(x,y) polarToCartesian(x,y,polarUy);
    
    MyWeakDirichletAlgorithm = WeakNitscheDirichlet2DAlgorithm(PenaltyValue);
    
    Support = WeakDirichletBoundaryCondition(@(x,y,z)(0),[1 1],GaussLegendre(NumberGP),OuterBoundary,MyWeakDirichletAlgorithm);
    
    Disp1 = WeakDirichletBoundaryCondition(@(x,y,z)Ux(x,y),[1 0],GaussLegendre(NumberGP),InnerBoundary,MyWeakDirichletAlgorithm);
    Disp2 = WeakDirichletBoundaryCondition(@(x,y,z)Uy(x,y),[0 1],GaussLegendre(NumberGP),InnerBoundary,MyWeakDirichletAlgorithm);
   
    MyAnalysis.addDirichletBoundaryCondition(Support);
    MyAnalysis.addDirichletBoundaryCondition(Disp1);
    MyAnalysis.addDirichletBoundaryCondition(Disp2);
    
    MyAnalysis.solve();
    
    % For p-FEM
    TotalStrainEnergy(PolynomialDegree) = MyAnalysis.getStrainEnergy;
    
    Dofs(PolynomialDegree) = MyAnalysis.getMesh().getNumberOfDofs();
    
end

AnalyticalStrainEnergy = -pi/128*(8-15/log(2)^2);

Error = sqrt(abs(TotalStrainEnergy-AnalyticalStrainEnergy)/AnalyticalStrainEnergy)*100; % Relative error in energy norm [%]

end