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
 
classdef StlBoundaryMeshVisualizer < AbsMeshVisualizer
    
    %%
    methods( Access = public )
        
        function obj = StlBoundaryMeshVisualizer( boundaryMeshFactory, realVisualizer )
             obj = obj@AbsMeshVisualizer( realVisualizer );
             obj.boundaryMeshFactory = boundaryMeshFactory;
        end
    end
    
    %%
    methods( Access = protected )
        
        function handles =  visualizeMeshes( obj, handles )      
            
            boundaryMesh = obj.boundaryMeshFactory.getBoundary();
            
            for i = 1:length(handles)
                handles{i} = obj.plotBoundaryMesh( handles{i}, boundaryMesh );
            end            
        end
        
    end
    
    %%
    methods( Access = private )
        
        function handle = plotBoundaryMesh( obj, handle, boundaryMesh )
            
            set(0,'CurrentFigure',handle)
              
             xyz = [];
             tris = [];
            for i = 1:length( boundaryMesh )
                
                coords = boundaryMesh(i).getVerticesCoordinates(); 
                
                xyz = [ xyz; coords(1:3,:) ];
                
                vertexCounter = size(xyz,1);
                tris(end+1,:) = [ vertexCounter - 2, vertexCounter - 1, vertexCounter];
                
            end
            
            lightGrayValue = 0.95;
            darkGrayValue = 0.5;
            patch('Faces',tris,'Vertices',xyz, ...
                'FaceColor',[lightGrayValue lightGrayValue lightGrayValue],...
                'FaceLighting','phong',...
                'EdgeColor','none', 'linewidth', 0.25);
            
            axis tight;
            grid off;
        end
    end
    
    %%
    properties( Access = private )
        
        boundaryMeshFactory;
    end
    
end

