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
 
classdef FeMeshVisualizer < AbsMeshVisualizer
    
    methods( Access = public )
        
        function obj = FeMeshVisualizer( feMesh, realVisualizer )
             obj = obj@AbsMeshVisualizer( realVisualizer );
             obj.feMesh = feMesh;
             
        end        
    end
    
    %%
    methods( Access = protected )
        
        function handles =  visualizeMeshes( obj, handles )  
            
            edges = obj.feMesh.getEdges();            
            
            for i = 1:length(handles)
                handles{i} = obj.plotFeMesh( handles{i}, edges );
            end            
        end
        
    end
    
    %%
    methods( Access = private )
        
        function handle = plotFeMesh( obj, handle, edges )
            
            set( 0,'CurrentFigure', handle );
            
            lightGrayValue = 0.9;
            darkGrayValue = 0.0;
            
                        
            hold on;
            for i = 1:length( edges )
                nodes = edges(i).getNodes();
                
                x = [ nodes(1).getX(), nodes(2).getX() ];
                y = [ nodes(1).getY(), nodes(2).getY() ];
                z = [ nodes(1).getZ(), nodes(2).getZ() ];
                
                line( x, y, z, ... 
                    'Color',[ darkGrayValue darkGrayValue darkGrayValue ] , ...
                    'Marker', 'none',...
                    'MarkerFaceColor', [ darkGrayValue darkGrayValue darkGrayValue ], ...
                    'MarkerEdgeColor', 'none' );
            end
            
            axis tight;
            grid off;
        end
    end
    
    properties( Access = private )
        feMesh;
    end
    
end

