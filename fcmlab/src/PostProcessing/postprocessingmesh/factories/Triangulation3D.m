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
 
classdef Triangulation3D < AbsPostProcessingMeshFactory
    
    methods( Access = public )
        
        function obj = Triangulation3D( gridSizes )
            obj.GridSizes = gridSizes;
        end
        
        %%
        function postProcessingMesh = createPostProcessingMesh( obj, FeMesh )
            
            [globalCoordinates, triangles] = obj.getSurfaceMesh( FeMesh );
                        
            numberOfPoints = size( globalCoordinates, 1 );
            
            resultPoints = ResultPoint.empty(numberOfPoints,0);
            for i = 1:numberOfPoints
                resultPoints(i) = obj.convertToResultPoint( globalCoordinates(i,:), FeMesh );
            end
            
            postProcessingMesh = PostProcessingMesh( resultPoints, triangles );
            
        end
        
    end
    
    methods( Access = private )
        
        %%
        function [vertices, tris] = getSurfaceMesh( obj, FeMesh  )
            
            origin = FeMesh.getMeshOrigin();
            spacings = [ FeMesh.getLX(), FeMesh.getLY(), FeMesh.getLZ() ];
            endPoint = origin + spacings;
            
            sections = ceil( endPoint - origin)./obj.GridSizes;
            
            x1D = linspace( origin(1), endPoint(1), sections(1) );
            y1D = linspace( origin(2), endPoint(2), sections(2) );
            z1D = linspace( origin(3), endPoint(3), sections(3) );
            
            
            [vertices1, tris1] = obj.getXYMesh(FeMesh, x1D, y1D );
            [vertices2, tris2] = obj.getYZMesh(FeMesh, y1D, z1D );
            [vertices3, tris3] = obj.getXZMesh(FeMesh, x1D, z1D );
                        
            [vertices, tris] = obj.mergeMeshes( vertices1, tris1, vertices2, tris2 );
            [vertices, tris] = obj.mergeMeshes( vertices, tris, vertices3, tris3 );
            
%             trisurf(tris, vertices(:,1), vertices(:,2), vertices(:,3));
            
        end
        
        %%
        function [vertices, tris] = getXYMesh( obj, FeMesh, x1D, y1D  )
            
            
            [x,y,z] = meshgrid( x1D, y1D, 0 );
            xyzBottom = [x(:),y(:),z(:)];
            
            surfaceBottom = delaunay( xyzBottom(:,1), xyzBottom(:,2) );
            
            [x,y,z] = meshgrid( x1D, y1D, FeMesh.getLZ() );
            xyzTop = [x(:),y(:),z(:)];
            
            surfaceTop = delaunay( xyzTop(:,1), xyzTop(:,2) );
            
            [vertices, tris] = obj.mergeMeshes( xyzBottom, surfaceBottom, xyzTop, surfaceTop );
            
            %             trisurf(tris, vertices(:,1), vertices(:,2), vertices(:,3));
            
        end
        
        %%
        function [vertices, tris] = getYZMesh( obj, FeMesh, y1D, z1D  )
            
            
            [x,y,z] = meshgrid( 0, y1D, z1D );
            xyz1 = [x(:),y(:),z(:)];
            
            surfaceBottom = delaunay( xyz1(:,2), xyz1(:,3) );
            
            [x,y,z] = meshgrid( FeMesh.getLX(), y1D, z1D );
            xyz2 = [x(:),y(:),z(:)];
            
            surfaceTop = delaunay( xyz2(:,2), xyz2(:,3) );
            
            [vertices, tris] = obj.mergeMeshes( xyz1, surfaceBottom, xyz2, surfaceTop );
            
            %             trisurf(tris, vertices(:,1), vertices(:,2), vertices(:,3));
            
        end
        
         %%
        function [vertices, tris] = getXZMesh( obj, FeMesh, x1D, z1D  )
            
            
            [x,y,z] = meshgrid( x1D, 0, z1D );
            xyz1 = [x(:),y(:),z(:)];
            
            surfaceBottom = delaunay( xyz1(:,1), xyz1(:,3) );
            
            [x,y,z] = meshgrid( x1D, FeMesh.getLY(), z1D );
            xyz2 = [x(:),y(:),z(:)];
            
            surfaceTop = delaunay( xyz2(:,1), xyz2(:,3) );
            
            [vertices, tris] = obj.mergeMeshes( xyz1, surfaceBottom, xyz2, surfaceTop );
            
            %             trisurf(tris, vertices(:,1), vertices(:,2), vertices(:,3));
            
        end
        
        
        
        
        %%
        function [vertices, tris]  = mergeMeshes( obj, vertices1, surface1, vertices2, surface2 )
            
            vertices = [ vertices1; vertices2];
            
            numberOfVertices = size(vertices1, 1);
            
            triangles2 = surface2 + numberOfVertices;
            tris = [ surface1; triangles2 ];
        end
        
        
    end
    
    properties( Access = private )
        GridSizes;
    end
    
end

