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
classdef AbsPostProcessorTest2D < TestCase
   
    properties
        FeMesh;
        Domain;
        ppMeshFactory;
    end
    
    methods
        %% Constructor
        function obj = AbsPostProcessorTest2D(name)
            obj = obj@TestCase(name);        
        end
        
        %% Set Up
        function setUp(obj)
            
            Materials(1) = ...
                HookePlaneStress( ...
                1,0, ...
                1,0.1);
            Materials(2) = ...
                HookePlaneStress( ...
                1,0,...
                1,1);
            
            OuterRadius = 1.0;
            InnerRadius = 0.25;
            NumberOfSegments = 8;
            
            Center = [0 0 0];
            obj.Domain = AnnularPlate( ...
                Center,...
                OuterRadius, ...
                InnerRadius);
            
            DofDimension = 2;
            MeshOrigin = [-1.1 -1.1 0.0];
            MeshLengthX = 2.2;
            MeshLengthY = 2.2;
            
            MyElementFactory = ...
                ElementFactoryElasticQuadFCM(Materials, obj.Domain, 2,2);
            
            MyMeshFactory = MeshFactory2DUniform(2,...
                2,1,PolynomialDegreeSorting,...
                DofDimension,MeshOrigin,MeshLengthX,MeshLengthY,MyElementFactory);
            
            obj.FeMesh = Mesh(MyMeshFactory);
            
            obj.ppMeshFactory =  Triangulation2DFCM( obj.Domain, 2, 0.5 );
            
        end
        
        %% Tear Down
        function tearDown(obj)
        end
        
       
       
        
    end
    
end