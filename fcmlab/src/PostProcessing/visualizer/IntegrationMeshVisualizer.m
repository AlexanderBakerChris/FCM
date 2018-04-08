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
 
classdef IntegrationMeshVisualizer < AbsMeshVisualizer
    
    %%
    methods( Access = public )
        
        function obj = IntegrationMeshVisualizer( feMesh, realVisualizer )
             obj = obj@AbsMeshVisualizer( realVisualizer );
             obj.feMesh = feMesh;
        end
    end
    
    %%
    methods( Access = protected )
        
        function handles =  visualizeMeshes( obj, handles )      
            
            integrationCells = obj.feMesh.getIntegrationCells();
            
            for i = 1:length(handles)
                handles{i} = obj.plotIntegrationMesh( handles{i}, integrationCells );
            end            
        end
        
    end
    
    %%
    methods( Access = private )
        
        function handle = plotIntegrationMesh( obj, handle, integrationCells )
            
            set(0,'CurrentFigure',handle)
                        
            for i = 1:length(integrationCells)
                
                lines = integrationCells(i).getLines();
                for j = 1:length(lines)
                    
                    vertices = lines(j).getVertices();
                    
                    x = [ vertices(1).getX(), vertices(2).getX() ];
                    y = [ vertices(1).getY(), vertices(2).getY() ];
                    z = [ vertices(1).getZ(), vertices(2).getZ() ];
                    
                    line( x, y, z, 'Color',[ 0 0 0 ], 'LineWidth', 0.5 );
                end
            end
            
            axis tight;
            grid off;
        end
    end
    
    %%
    properties( Access = private )
        feMesh;
    end
    
end

