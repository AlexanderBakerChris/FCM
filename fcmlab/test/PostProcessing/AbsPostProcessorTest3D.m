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
classdef AbsPostProcessorTest3D < TestCase
   
    properties
        FeMesh;
        ppLineMeshFactory;
        ppSurfaceMeshFactory;
        iBeam;
    end
    
    methods
        %% Constructor
        function obj = AbsPostProcessorTest3D(name)
            obj = obj@TestCase(name);        
        end
        
        %% Set Up
        function setUp(obj)
            MeshOrigin = [-0.1 -0.1 -0.1];
            NumberOfXDivisions = 2;
            NumberOfYDivisions = 2;
            NumberOfZDivisions = 2;
            PolynomialDegree = 1;
            
            RefinementSteps = 2; %integration depth
            
            % Mesh Parameters
            Lx = 0.70;
            Ly = 6.40;
            Lz = 0.80;
            
            Width = 0.5;   % total width (x)
            Length = 6.2;  % total length of beam (y)
            Height = 0.6;  % total height (z)
            Thick1 = 0.02;  % thickness of flanges
            Thick2 = 0.02;  % thickness of the girder
            Circles = [3.1 0.15;1.5 0.15;4.7 0.15] ; % matrix of circular holes along girder [y1 r1; y2 r2;...]
                                           % with yi being the middle point coordinate along girder

            obj.iBeam = IBeam(Width,Length,Height,Thick1,Thick2,Circles);

            
            Mat3DFCM(1) = Hooke3D(1,1,1,0);
            Mat3DFCM(2) = Hooke3D(1,1,1,1);
            DofDimension = 3;

            MyElementFactory = ElementFactoryElasticHexaFCM( Mat3DFCM, ...
                obj.iBeam,2,RefinementSteps );
            
            MyMeshFactory = MeshFactory3DUniform(NumberOfXDivisions,...
                NumberOfYDivisions,NumberOfZDivisions,PolynomialDegree,PolynomialDegreeSorting(),...
                DofDimension,MeshOrigin,Lx,Ly,Lz,MyElementFactory);
                
            obj.FeMesh = Mesh(MyMeshFactory);
            
            startPoint = [1,2,3]; 
            endPoint = [6,5,4];
            numberOfSegments = 3;
            
            obj.ppLineMeshFactory = StraightLine( startPoint, endPoint, numberOfSegments );
            obj.ppSurfaceMeshFactory = Triangulation3DFCM( obj.iBeam, 2, [ 0.025 0.5 0.025] );
            
        end
        
        %% Tear Down
        function tearDown(obj)
        end
        
       
       
        
    end
    
end