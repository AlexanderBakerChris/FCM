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
 
classdef VonMisesStress < AbsDerivativeBasedProcessor
    
    
    methods( Access = public )
        
        function obj = VonMisesStress( solutionNumbers, domainIndex )
            obj = obj@AbsDerivativeBasedProcessor( solutionNumbers, 'von Mises Stress', domainIndex );  
           
        end
        
    end
    
    methods( Access = protected )
        
        function result = evaluateProcessor( obj, dofs )
            
            strains = obj.B*dofs;
            
            StressVector = obj.C*strains;          
            
            
            if ( obj.problemDimensionality == 1 )
                
                result = StressVector(1); 
                
            elseif ( obj.problemDimensionality == 2 )
                
                result = sqrt(...
                    0.5*( ( StressVector(1)-StressVector(2) )^2 ...
                          + StressVector(2)^2 + StressVector(1)^2 ... 
                        + 6*StressVector(3)^2) );  
                    
            elseif ( obj.problemDimensionality == 3 )
                
                result = sqrt( ...
                    0.5*( ( StressVector(1)-StressVector(2) )^2 ...
                         +( StressVector(2)-StressVector(3) )^2 ...
                         +( StressVector(1)-StressVector(3) )^2 ...
                       +6*( StressVector(4)^2+StressVector(5)^2+StressVector(6)^2) ) );  
                            
            else
                Logger.ThrowException( ['Unkown Dimenison: ' , num2str(problemDimensionality)] );
            end  
            
        end
                
    end
    
    
    
    
    
    properties(Access = private )
           
        
    end
    
end

