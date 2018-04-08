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
 
classdef AbsPostProcess < handle 
    
    methods( Access = public )
        
        %%
        function obj = AbsPostProcess()
            obj.pointProcessors = {};
        end
        
        
        %%
        function registerPointProcessor( obj, varargin )
            
            
            % don't forget to count the obj as input argument!!!
            if ( nargin == 2 )
                pointProcessorToRegister = varargin{1};
            elseif ( nargin == 3 )
                classContstructor = varargin{1};
                inputArguments = varargin{2};
                pointProcessorToRegister = feval( classContstructor, inputArguments{:} ); 
            else
                Logger.ThrowException([ 'Illegal number of input arguments provided! nargin = ', num2str(nargin)] );                
            end
            
            obj.pointProcessors{end+1} = pointProcessorToRegister;
        end
    end
    
    properties( Access = protected )
         pointProcessors;
    end
    
end

