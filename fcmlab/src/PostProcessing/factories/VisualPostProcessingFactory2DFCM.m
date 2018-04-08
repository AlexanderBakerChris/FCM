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
 
classdef VisualPostProcessingFactory2DFCM < AbsVisualPostProcessingFactory
    
 methods( Access = public )
        
        function obj = VisualPostProcessingFactory2DFCM( FeMesh, domain, domainIndex, gridSize, varargin )
            obj.FeMesh = FeMesh;
            obj.domain = domain;
            obj.domainIndex = domainIndex;
            obj.gridSize = gridSize;
            if( nargin == 5 )
                obj.BoundaryFactories = varargin{1};
            else
                obj.BoundaryFactories = {};
            end
        end
    end
    
    methods
        
        function visualizer = createVisualizer( obj )
            
            % nest the visualizer
            surfaceVisualizer = SurfacePlot();
            integraionMeshVisualizer = IntegrationMeshVisualizer( obj.FeMesh, surfaceVisualizer );
            visualizer = FeMeshVisualizer( obj.FeMesh, integraionMeshVisualizer );
            
        end
        
        function postProcessingMeshFactory = createPostProcessingMeshFactory( obj )
            
            % create post processing mesh factory
            if ( isempty( obj.BoundaryFactories ) )
                postProcessingMeshFactory =  Triangulation2DFCM( obj.domain, obj.domainIndex, obj.gridSize );
            else
                postProcessingMeshFactory =  Triangulation2DFCM( obj.domain, obj.domainIndex, obj.gridSize, obj.BoundaryFactories );
            end
            
         end
        
    end
    
    properties( Access = private )
        FeMesh;
        domain;
        domainIndex;
        gridSize;
        BoundaryFactories;
    end
    
    
end

