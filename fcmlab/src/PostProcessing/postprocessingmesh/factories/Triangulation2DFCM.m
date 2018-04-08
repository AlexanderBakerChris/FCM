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
 
classdef Triangulation2DFCM < AbsPostProcessingMeshFactory
    
    methods( Access = public )
        
        function obj = Triangulation2DFCM( domain, domainIndex, gridSize, varargin )
            obj.Domain = domain;
            obj.DomainIndex = domainIndex;
            obj.GridSize = gridSize;
            
            if( nargin == 4 )
                obj.BoundaryFactories = varargin{1};
            else
                obj.BoundaryFactories = {};
            end
        end
        
        %%
        function postProcessingMesh = createPostProcessingMesh( obj, FeMesh )
            
            resultCoords = obj.getResultCoords( FeMesh );
            
            triangles = obj.triangularize2D( resultCoords );
            
            numberOfPoints = size( resultCoords, 1 );
            
            resultPoints = ResultPoint.empty(numberOfPoints,0);
            
            for i = 1:numberOfPoints                
                resultPoints(i) = obj.convertToResultPoint( resultCoords(i,:), FeMesh );
            end
            
            postProcessingMesh = PostProcessingMesh( resultPoints, triangles );          
            
        end
        
    end
    
    methods( Access = private )
        
        
        %%
        function resultCoords = getResultCoords( obj, FeMesh )
   
            boundaryPoints = obj.getPointsOnBoundary( );
            
            internalPoints = obj.getInternalPoints( FeMesh );
            
            resultCoords = [ boundaryPoints; internalPoints ];
        end
        
        
        %%
        function boundaryPoints = getPointsOnBoundary( obj )
            
              boundaryPoints = [];
              for i = 1:length( obj.BoundaryFactories )
                    boundarySegments = obj.BoundaryFactories{i}.getBoundary;
                    for j = 1:length(boundarySegments)
                        vertices = boundarySegments(j).getVertices();
                        for k = 1:length(vertices)
                            boundaryPoints( end+1, : ) = vertices(k).getCoords();
                        end
                    end
              end
             
        end
        
        %%
        function internalPoints = getInternalPoints( obj, FeMesh )
            
            origin = FeMesh.getMeshOrigin();
            minX = origin(1);
            maxX = origin(1) + FeMesh.getLX();
            minY = origin(2);
            maxY = origin(2) + FeMesh.getLY();
            
            
            divisionX = ceil((maxX - minX) / obj.GridSize);
            divisionY = ceil((maxY - minY) / obj.GridSize);
                        
            x1D = linspace(minX,maxX,divisionX);
            y1D = linspace(minY,maxY,divisionY);
            
            internalPoints = [];            
            for i = 1:length(x1D)                
                for j = 1:length(y1D)
                    if (obj.Domain.getDomainIndex( [x1D(i), y1D(j) 0] )==obj.DomainIndex)
                        internalPoints(end+1,:) = [ x1D(i), y1D(j), 0 ];
                    end
                end
            end
           
        end
        
        %%
        function triangles = triangularize2D(obj, resultCoords )
            
            x = resultCoords(:,1);
            y = resultCoords(:,2);
            
            warning off
            
            allTriangles = delaunay(x,y)';
            triangles = obj.deleteIllElements( resultCoords, allTriangles );
            
            warning on
        end
        
        %%
        function internalTriangles = deleteIllElements(obj, resultCoords, allTriangles )
            
            internalTriangles = [];
            
            for i = 1:size( allTriangles, 2 )
                
                p1 = resultCoords( allTriangles(1,i), : );
                p2 = resultCoords( allTriangles(2,i), : );
                p3 = resultCoords( allTriangles(3,i), : );
                
                vec1 = p2 - p1;
                vec2 = p3 - p1;
                
                delteTriangle = 0;
                
                % check for angle
                angle = vec1 * vec2' / (norm(vec1)*norm(vec2));
                if abs(angle)>0.99999
                    delteTriangle = 1;
                end
                
                % delte triangles that are not in domain
                pc = (p1 + p2 + p3) / 3;
                if ~(obj.Domain.getDomainIndex(pc)==obj.DomainIndex)
                    delteTriangle = 1;
                end
                
                if( delteTriangle == 0 )
                    internalTriangles(end+1,:) = allTriangles( :, i);
                end
                
            end
            
        end
        
        
    end
    
    properties( Access = private )
        Domain;
        DomainIndex;
        GridSize;
        BoundaryFactories;
    end
    
end

