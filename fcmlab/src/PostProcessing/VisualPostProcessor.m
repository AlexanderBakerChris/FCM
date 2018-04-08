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
 
classdef VisualPostProcessor < AbsPostProcess
    
    
    methods( Access = public )
        
        %%
        function obj = VisualPostProcessor( PostProcessingMeshFactory, visualizer )
            
            obj.PostProcessingMeshFactory = PostProcessingMeshFactory;

            obj.visualizer = visualizer;
        end
        
        
        %%
        function visualizeResults( obj, FeMesh )
            
            Logger.TaskStart('Visual Post-Processing','release');

                Logger.TaskStart('Create Post-Processing Mesh','release');
                postProcessingMesh = obj.PostProcessingMeshFactory.createPostProcessingMesh( FeMesh );
                Logger.TaskFinish('Create Post-Processing Mesh','release');

                Logger.TaskStart('Compute Post-Processing Results','release');
                results = obj.computeResults( postProcessingMesh );
                Logger.TaskFinish('Compute Post-Processing Results','release');

                Logger.TaskStart('Visualize Results','release');
                
                numberOfProcessors = length( obj.pointProcessors );
                for j = 1:numberOfProcessors  
                
                    Logger.TaskStart(['Visualize ', obj.pointProcessors{j}.getLabel()],'release');
                    
                    obj.visualizer.visualizeResults( postProcessingMesh, ...
                        results{j}, obj.pointProcessors{j}.getLabel() );                   
                    
                    Logger.TaskFinish(['Visualize ', obj.pointProcessors{j}.getLabel()],'release');
                end
                
                Logger.TaskFinish('Visualize Results','release');
            
            Logger.TaskFinish('Visual Post-Processing','release');
            
        end
    end
    
    methods( Access = private )
        
        %%
        function results = computeResults( obj, postProcessingMesh )
            
            resultPoints = postProcessingMesh.getResultPoints();
            
            numberOfPoints = length( resultPoints );
            numberOfProcessors = length( obj.pointProcessors );
            results = cell( 1, numberOfProcessors );
            values = cell( numberOfPoints, 1 );
            
            for i = 1:numberOfProcessors
                processor = obj.pointProcessors{i};
                parfor j = 1:numberOfPoints
                    values{ j } = transpose( processor.evaluate( resultPoints( j ) ) );
                end
                results{ i } = cell2mat( values )';
            end
            
        end
        
    end
    
    properties( Access = private )
        
        PostProcessingMeshFactory;
        

        visualizer;
        
    end
    
end

