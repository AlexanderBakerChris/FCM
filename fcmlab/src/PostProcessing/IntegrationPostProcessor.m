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
 
classdef IntegrationPostProcessor < AbsPostProcess
    
    
    methods( Access = public )
        
        %%
        function obj = IntegrationPostProcessor(   )           

        end
        
        
        
        %%
        function integrals = integrate( obj, FeMesh )
            
            Logger.TaskStart('Integrate Results','release');
            
                numberOfProcessors = length( obj.pointProcessors );
            
                integrals = zeros( numberOfProcessors , 1 );
                
                parfor i = 1:numberOfProcessors
                    integrals(i) = obj.integratePointProcessor( FeMesh, obj.pointProcessors{i} );
                end
            
            Logger.TaskFinish('Integrate Results','release');
            
            
        end        
    end
    
    methods( Access = private )
        
        %%
        function integral = integratePointProcessor( obj, FeMesh, pointProcessor )
            
            Logger.TaskStart([ 'Integrate ' , pointProcessor.getLabel()],'release');
                
                elements = FeMesh.getElements();
    
                integral = 0;
                for i = 1:length( elements )

                    integrator = elements(i).getIntegrator();

                    resultPoint = @(localCoords) ResultPoint( elements(i), localCoords, elements(i).mapLocalToGlobal( localCoords ) );
                    integrand = @(localCoords) pointProcessor.evaluate(resultPoint(localCoords));

                    support = elements(i).getGeometricSupport();

                    integral = integral + integrator.integrate( integrand, support);                
                end
                Logger.Log( ['Integral of ', pointProcessor.getLabel(), ' is: ' ], 'release' );
                
                for i = 1:length(integral)
                    Logger.Log( ['   Component ', num2str(i), ': '  num2str( integral(i), '%.9E' ) ], 'release' );
                end
            
            Logger.TaskFinish([ 'Integrate ' , pointProcessor.getLabel()],'release');
        end
        
    end
    
    
    properties( Access = private )

    end
    
end

