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
 
classdef GaussLegendre < AbsIntegrationScheme
    
    methods
        %% constructor
        function obj = GaussLegendre(integrationOrder)
            obj.integrationOrder = integrationOrder;
        end
        
        %% getCoordinates
        function integrationPoints = getCoordinates(obj,geometry)
            integrationPoints1D = ...
                getGaussQuadratureCoordinates(obj.integrationOrder);
            
            if isa(geometry,'AbsCurve')
                integrationPoints = ...
                    [integrationPoints1D,zeros(length(integrationPoints1D),2)];
            elseif isa(geometry,'AbsArea')
                [r,s] = meshgrid(integrationPoints1D,integrationPoints1D);
                integrationPoints = [r(:),s(:),zeros(length(integrationPoints1D)^2,1)];
            elseif isa(geometry,'AbsVolume')
                [s,r,t] = meshgrid(integrationPoints1D,integrationPoints1D,integrationPoints1D);
                integrationPoints = [r(:),s(:),t(:)];
            else
                Logger.ThrowException(['Unknown Geometric Type: ' class(geometry) '!!']);
            end
        end
        
        %% getWeights
        function integrationWeights = getWeights(obj,geometry)
            integrationWeights1D = ...
                getGaussQuadratureWeights(obj.integrationOrder);
            
            if isa(geometry,'AbsCurve')
                integrationWeights = integrationWeights1D;
            elseif isa(geometry,'AbsArea')
                integrationWeights = ...
                    kron(integrationWeights1D,integrationWeights1D);
            elseif isa(geometry,'AbsVolume')
                integrationWeights = ...
                    kron(integrationWeights1D,...
                    kron(integrationWeights1D,integrationWeights1D));
            else
                Logger.ThrowException(['Unknown Geometric Type: ' class(geometry) '!!']);
            end
        end
        
    end
    
    properties (Access = private)
        integrationOrder
    end
    
end

