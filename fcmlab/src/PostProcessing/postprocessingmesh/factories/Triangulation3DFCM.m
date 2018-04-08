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
 
classdef Triangulation3DFCM < AbsPostProcessingMeshFactory
    
    methods( Access = public )
        
        function obj = Triangulation3DFCM( domain, domainIndex, gridSizes )
            obj.Domain = domain;
            obj.DomainIndex = domainIndex;
            obj.GridSizes = gridSizes;
        end
        
        %%
        function postProcessingMesh = createPostProcessingMesh( obj, FeMesh )
            
            [x,y,z] = obj.getSeedPoints( FeMesh );           
            
            domainIndices = zeros( size(x) );
            
            for i = 1:size(domainIndices,1)
                for j = 1:size(domainIndices,2)
                    for k = 1:size(domainIndices,3)
                        
                        domainIndices(i,j,k) = obj.Domain.getDomainIndex( [x(i,j,k) y(i,j,k) z(i,j,k) ] );
                    end
                end
            end
            
            surface = isosurface( x, y, z, domainIndices, obj.DomainIndex - eps );
            
            globalCoordinates = surface.vertices;
            triangles = surface.faces;
            
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
        function [x,y,z] = getSeedPoints( obj, FeMesh )
            
            origin = FeMesh.getMeshOrigin()-obj.GridSizes;
            spacings = [ FeMesh.getLX(), FeMesh.getLY(), FeMesh.getLZ() ];
            endPoint = origin + spacings + 2*obj.GridSizes;
            
            [x,y,z] = meshgrid( origin(1):obj.GridSizes(1):endPoint(1), ...
                                origin(2):obj.GridSizes(2):endPoint(2), ...
                                origin(3):obj.GridSizes(3):endPoint(3) );
        end
        
        
    end
    
    properties( Access = private )
        Domain;
        DomainIndex;
        GridSizes;
    end
    
end

