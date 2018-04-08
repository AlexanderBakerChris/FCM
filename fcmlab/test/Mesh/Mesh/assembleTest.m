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
 
% Testing of assemble function
classdef assembleTest < TestCase
   
    properties
        MyMesh
        LoadCase1
    end
    
    methods
        %% Constructor
        function obj = assembleTest(name)
            obj = obj@TestCase(name);        
        end
        
        %% Set Up
        function setUp(obj)
            NumberOfXDivisions = 2;
            PolynomialDegree = 3;
            NumberingScheme = PolynomialDegreeSorting();
            DofDimension = 1;
            MeshOrigin = 0;
            Lx = 1;
            
            % setting up Load Case for assembling the load vector
            fDistributed = @(x,y,z)(- sin(8*x)); % distributed load
            obj.LoadCase1 = LoadCase();
            obj.LoadCase1.addBodyLoad(fDistributed);
            
            % setting up element factory 1D bar
            NumberGP = PolynomialDegree+1;
            A = 1;
            Mat1D = Hooke1D(A,1,0,1);
            ElementFactory = ElementFactoryElasticBar(Mat1D,NumberGP);
                        
            MeshFactory = MeshFactory1DUniform(NumberOfXDivisions,PolynomialDegree,...
               NumberingScheme,DofDimension,MeshOrigin,Lx,ElementFactory);
            obj.MyMesh = Mesh(MeshFactory);
        end
        
        %% Tear Down
        function tearDown(obj)
        end
        
        %% Testing stiffness matrix assemble
        function testStiffnessMatrix(obj)
            K = obj.MyMesh.assembleStiffnessMatrix();
            Ktrue = zeros(7,7);
            Ktrue(1,1) = 2;
            Ktrue(1,2) = -2;
            Ktrue(2,1) = -2;
            Ktrue(2,2) = 4;
            Ktrue(3,3) = 2;
            Ktrue(2,3) = -2;
            Ktrue(3,2) = -2;
            for i = 4:7;
                Ktrue(i,i) = 4;
            end
            assertElementsAlmostEqual(K, Ktrue);
        end
        
        %% Testing load vector assemble
        function testLoadVector(obj)
            F = obj.MyMesh.assembleLoadVector(obj.LoadCase1);
            Ftrue = [-0.1487 0.0783 -0.0728 0.1211 -0.0372 -0.0329 0.0758];
            assertElementsAlmostEqual(F, Ftrue.','absolute',1.0e-04);
        end
         
    end
    
end