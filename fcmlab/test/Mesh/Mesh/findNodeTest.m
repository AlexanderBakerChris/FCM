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
 
% testing of class NodeBoundaryCondition

classdef findNodeTest < TestCase
    
    properties        
        Mesh3D
        MyPosition1D
        MyPosition2D
        MyPosition3D
        MyPositionError
        nodesHandle
    end
    
    methods
        
        %% constructor
        function obj = findNodeTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            % Parameters
            NumberOfXDivisions = 3;
            NumberOfYDivisions = 4;
            NumberOfZDivisions = 5;
            PolynomialDegree = 3;
            NumberingScheme = TopologicalSorting();
            DofDimension = 2;
            NumberGP = PolynomialDegree+1;
            Mat3D = Hooke3D(1,0.3,2,0);
            MeshOrigin = [0 0 0];
            Lx = 6.2;
            Ly = 8.9;
            Lz = 2.3;
            
            % Creating ElementFactory 3D
            ElementFactory3D = ElementFactoryElasticHexa(Mat3D,NumberGP);
            % Creating Mesh
            MeshFactory3D = MeshFactory3DUniform(NumberOfXDivisions,...
                NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,NumberingScheme,...
                DofDimension,MeshOrigin,Lx,Ly,Lz,ElementFactory3D);
            obj.Mesh3D = Mesh(MeshFactory3D);
            
            % Setting Position
            obj.MyPosition1D = [1*Lx/NumberOfXDivisions,0,0];
            obj.MyPosition2D = [2*Lx/NumberOfXDivisions,3*Ly/NumberOfYDivisions,0];
            obj.MyPosition3D = [3*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,4*Lz/NumberOfZDivisions];
            obj.MyPositionError = [-1*Lx/NumberOfXDivisions,0*Ly/NumberOfYDivisions,0*Lz/NumberOfZDivisions];
            % Array of nodes
            obj.nodesHandle = obj.Mesh3D.getNodes;
        end
        
        function tearDown(obj)
        end
        
        %% test finding of a node in 1D
        function testFindNode1D(obj)
            MyNode1D = findNode(obj.Mesh3D,obj.MyPosition1D);
            assertEqual(MyNode1D,obj.nodesHandle(2));
        end
        
        %% test finding of a node in 2D
        function testFindNode2D(obj)
            MyNode2D = findNode(obj.Mesh3D,obj.MyPosition2D);
            assertEqual(MyNode2D,obj.nodesHandle(15));
        end
        
        %% test finding of a node in 3D
        function testFindNode3D(obj)
            MyNode3D = findNode(obj.Mesh3D,obj.MyPosition3D);
            assertEqual(MyNode3D,obj.nodesHandle(92)); % 92 = k + (j-1)*(Nx+1) + (i-1)*(Nx+1)*(Ny+1)
        end
        
        %% test finding node error
%         function testFindNodeError(obj)
%             MyNodeError = findNode(obj.Mesh3D,obj.MyPositionError);
%         end
                
    end
    
end