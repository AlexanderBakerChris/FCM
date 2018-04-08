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
 
% Testing the Mesh class
classdef MeshTest < TestCase
   
    properties
        MyMesh
    end
    
    methods
        %% Constructor
        function obj = MeshTest(name)
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
            
            % setting up element factory 1D bar
            NumberGP = PolynomialDegree+1;
            A = 1;
            Mat1D = Hooke1D(A,1,0,0);
            ElementFactory = ElementFactoryElasticBar(Mat1D,NumberGP);
                        
            MeshFactory = MeshFactory1DUniform(NumberOfXDivisions,PolynomialDegree,...
               NumberingScheme,DofDimension,MeshOrigin,Lx,ElementFactory);
            obj.MyMesh = Mesh(MeshFactory);
        end
        
        %% Tear Down
        function tearDown(obj)
        end
        
        %% Testing get number of Dofs
        function testNumberOfDofs(obj)
            assertEqual(obj.MyMesh.getNumberOfDofs, 7);
        end
        
        %% Testing get nodes
        function testGetNodes(obj)
           assertEqual(length(obj.MyMesh.getNodes), 3);
        end
        
        %% Testing get edges
        function testGetEdges(obj)
            assertEqual(length(obj.MyMesh.getEdges), 2);
        end
        
        %% Testing get elements
        function testGetElements(obj)
            assertEqual(length(obj.MyMesh.getElements),2);
            assertEqual(obj.MyMesh.getNumberOfElements,2);
        end
        
    end
    
end