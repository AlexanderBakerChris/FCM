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
 
classdef SurfacePlot < AbsVisualizer
    
    methods( Access = public )
        
        %%
        function obj = SurfacePlot( varargin )
            if( nargin > 0 )
                obj.SolutionNumbersToWarp = varargin{1};
                obj.WarpScalingFactor = varargin{2};
            else
                obj.SolutionNumbersToWarp = [];
                obj.WarpScalingFactor = 1;
            end
        end
        
        %%
        function handles = visualizeResults( obj, postProcessingMesh, results, resultLabel )
            
            if ( isempty( obj.SolutionNumbersToWarp ) )
                handles = obj.visualizeResultsUnWarped( postProcessingMesh, results, resultLabel );
            else
                handles = obj.visualizeResultsWarped( postProcessingMesh, results, resultLabel );
            end
            
            
            
        end
        
    end
    
    methods( Access = private )
        
        %%
        function handles = visualizeResultsUnWarped( obj, postProcessingMesh, results, resultLabel )
             
            [ xyz, tris ] = postProcessingMesh.getPostProcessingSurface();
            
            handles = {};
            for i = 1:size(results,1)
                handles{end+1} =  obj.createHandelAndVisualize( i, resultLabel, results, xyz, tris );
            end
        end
        
        %%
        function handles = visualizeResultsWarped( obj, postProcessingMesh, results, resultLabel )
             
            if( length( obj.SolutionNumbersToWarp ) ~= size(results,1) )
                Logger.ThrowException( ... 
                    ['Number of results and warps have to match! Instead they are ', ... 
                    num2str( size(results,1) ), ...
                    ' and ', ...
                    num2str( length( obj.SolutionNumbersToWarp ) ) ] );
            end
            
            handles = {};
            for i = 1:size(results,1)
                [ xyz, tris ] = postProcessingMesh.getWarpedPostProcessingSurface( obj.SolutionNumbersToWarp(i), obj.WarpScalingFactor );
                
                handles{end+1} =  obj.createHandelAndVisualize( i, resultLabel, results, xyz, tris );
            end
        end
        
        %%
        function handle = createHandelAndVisualize( obj, i, resultLabel, results, xyz, tris )
            if size(results,1) > 1
                label = [ resultLabel , ' ( Component ', num2str(i), ' )'];
            else
                label = resultLabel;
            end
            
            handle = obj.visualizeResult( xyz, tris, results(i,:), label );
        end
        
        %%
        function handle = visualizeResult( obj,  xyz, tris, result, resultLabel  )
            
            handle = figure( 'Name', resultLabel );
            
            patch('Faces',tris,'Vertices',xyz,'FaceVertexCData',result', ...
                'FaceColor','interp',...
                'FaceLighting','phong',...
                'EdgeColor','interp', ...
                'EdgeLighting','none', ...
                'EdgeAlpha', 0);
            
            az = 0;
            el = 90;
            view(az,el);
            
            axis equal;
            axis tight;
            
            colorbar;
            
            xlabel('x');
            ylabel('y');
            
        end
        
        
    end
    
    properties( Access = private )
        SolutionNumbersToWarp;
        WarpScalingFactor;
    end
    
end

