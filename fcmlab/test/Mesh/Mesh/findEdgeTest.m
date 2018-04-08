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

classdef findEdgeTest < TestCase
    
    properties        
        Mesh3D
        LineStartX
        LineEndX
        LineStartY
        LineEndY
        LineStartZ
        LineEndZ 
        LineStartError
        LineEndError
    end
    
    methods
        
        %% constructor
        function obj = findEdgeTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            % Parameters
            NumberOfXDivisions = 2;
            NumberOfYDivisions = 3;
            NumberOfZDivisions = 4;
            PolynomialDegree = 3;
            NumberingScheme = TopologicalSorting();
            DofDimension = 2;
            NumberGP = PolynomialDegree+1;
            Mat3D = Hooke3D(1,0.3,0,0);
            MeshOrigin = [0 0 0];
            Lx = 6.2;
            Ly = 8.89;
            Lz = 0.6123;
            % Setting element factory
            ElementFactory = ElementFactoryElasticHexa(Mat3D,NumberGP);
            % Creating Mesh
            MeshFactory3D = MeshFactory3DUniform(NumberOfXDivisions,...
                NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,NumberingScheme,...
                DofDimension,MeshOrigin,Lx,Ly,Lz,ElementFactory);
            obj.Mesh3D = Mesh(MeshFactory3D);
            % Setting Positions
            obj.LineStartX = [0*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
            obj.LineEndX = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
            obj.LineStartY = [1*Lx/NumberOfXDivisions,0*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
            obj.LineEndY = [1*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
            obj.LineStartZ = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,1*Lz/NumberOfZDivisions];
            obj.LineEndZ = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,4*Lz/NumberOfZDivisions];
             % Exception test : not on an line
%             obj.LineStartError = [2*Lx/NumberOfXDivisions,1*Ly/NumberOfYDivisions,1*Lz/NumberOfZDivisions];
%             obj.LineEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
             % Exception test : not on a node
%             obj.LineStartError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,1.4*Lz/NumberOfZDivisions];
%             obj.LineEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
             % Exception test : orientation of line
%             obj.LineStartError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
%             obj.LineEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,1*Lz/NumberOfZDivisions];
             % Exception test : same input points
%             obj.LineStartError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,1*Lz/NumberOfZDivisions];
%             obj.LineEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,1*Lz/NumberOfZDivisions];
        end
        
        function tearDown(obj)
        end
        
        %% test finding edges in X direction
        function testFindEdgesXDirection(obj)
            MyEdges = findEdges(obj.Mesh3D,obj.LineStartX,obj.LineEndX);
            EdgesHandle = obj.Mesh3D.getEdges;
            EdgesTrue = EdgesHandle(21:22);
            assertEqual(MyEdges,EdgesTrue);
        end
        
        %% test finding edges in Y direction
        function testFindEdgesYDirection(obj)
            MyEdges = findEdges(obj.Mesh3D,obj.LineStartY,obj.LineEndY);
            EdgesHandle = obj.Mesh3D.getEdges;
            EdgesTrue = EdgesHandle(65:66);
            assertEqual(MyEdges,EdgesTrue);
        end
        
        %% test finding edges in Z direction
        function testFindEdgesZDirection(obj)
            MyEdges = findEdges(obj.Mesh3D,obj.LineStartZ,obj.LineEndZ);
            EdgesHandle = obj.Mesh3D.getEdges;
            EdgesTrue = EdgesHandle(119:121);
            assertEqual(MyEdges,EdgesTrue);
        end
        
        %% test finding edges Error
%         function testFindEdgesErrorDirection(obj)
%             MyEdges = findEdges(obj.Mesh3D,obj.LineStartError,obj.LineEndError);
%         end
               
    end
    
end