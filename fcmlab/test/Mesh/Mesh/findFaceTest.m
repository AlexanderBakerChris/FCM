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

classdef findFaceTest < TestCase
    
    properties        
        Mesh3D
        PointStartXY
        PointEndXY
        PointStartYZ
        PointEndYZ
        PointStartZX
        PointEndZX
        PointStartError
        PointEndError
    end
    
    methods
        
        %% constructor
        function obj = findFaceTest(name)
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
            Mat3D = Hooke3D(1,0.3,2,1);
            MeshOrigin = [0 0 0];
            Lx = 6.2;
            Ly = 8.89;
            Lz = 0.6123;

            % Creating ElementFactory 3D
            ElementFactory3D = ElementFactoryElasticHexa(Mat3D,NumberGP);
            % Creating Mesh
            MeshFactory3D = MeshFactory3DUniform(NumberOfXDivisions,...
                NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,NumberingScheme,...
                DofDimension,MeshOrigin,Lx,Ly,Lz,ElementFactory3D);
            obj.Mesh3D = Mesh(MeshFactory3D);
            
            % Setting Positions
            obj.PointStartXY = [1*Lx/NumberOfXDivisions,1*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
            obj.PointEndXY = [2*Lx/NumberOfXDivisions,3*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
            obj.PointStartYZ = [1*Lx/NumberOfXDivisions,1*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
            obj.PointEndYZ = [1*Lx/NumberOfXDivisions,3*Ly/NumberOfYDivisions,4*Lz/NumberOfZDivisions];
            obj.PointStartZX = [0*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
            obj.PointEndZX = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
%              % Exception test : not a good input rectangle
%             obj.PointStartError = [0*Lx/NumberOfXDivisions,0*Ly/NumberOfYDivisions,0*Lz/NumberOfZDivisions];
%             obj.PointEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
%              % Exception test : points on an x, y or z line
%             obj.PointStartError = [2*Lx/NumberOfXDivisions,0*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
%             obj.PointEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
%              % Exception test : start = end
%             obj.PointStartError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
%             obj.PointEndError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
             % Exception test : coordinates of start > coordinates of end
%             obj.PointStartError = [2*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,2*Lz/NumberOfZDivisions];
%             obj.PointEndError = [1*Lx/NumberOfXDivisions,2*Ly/NumberOfYDivisions,3*Lz/NumberOfZDivisions];
        end
        
        function tearDown(obj)
        end
        
        %% test finding faces in XY direction
        function testFindFacesXy(obj)
            MyFaces = findFaces(obj.Mesh3D,obj.PointStartXY,obj.PointEndXY);
            FacesHandle = obj.Mesh3D.getFaces;
            FacesTrue = FacesHandle([16 18]);
            assertEqual(MyFaces,FacesTrue);
        end
        
        %% test finding faces in YZ direction
        function testFindFacesYz(obj)
            MyFaces = findFaces(obj.Mesh3D,obj.PointStartYZ,obj.PointEndYZ);
            FacesHandle = obj.Mesh3D.getFaces;
            FacesTrue = FacesHandle([50 51 53 54]);
            assertEqual(MyFaces,FacesTrue);
        end
        
        %% test finding faces in ZX direction
        function testFindFacesZx(obj)
            MyFaces = findFaces(obj.Mesh3D,obj.PointStartZX,obj.PointEndZX);
            FacesHandle = obj.Mesh3D.getFaces;
            FacesTrue = FacesHandle([85 89]);
            assertEqual(MyFaces,FacesTrue);
        end
        
        %% test finding faces Error
%         function testFindFacesErrorDirection(obj)
%             MyFaces = findFaces(obj.Mesh3D,obj.PointStartError,obj.PointEndError);
%         end
               
    end
    
end