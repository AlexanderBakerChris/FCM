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
 
classdef AbsTopology < handle
    %% 
    methods (Access = public)
        %% Constructor
        function obj = AbsTopology(geometricSupport, dofDimension, numberOfDofsPerFieldComponent)
          obj.geometricSupport = geometricSupport;
          obj.numberOfDofsPerFieldComponent = numberOfDofsPerFieldComponent;
       
          obj.dofs = Dof.empty(dofDimension * numberOfDofsPerFieldComponent, 0);
        
          for i = 1:size(obj.dofs,1)
                obj.dofs(i) = Dof(0);
          end
            
        end
        
        %% getGeometricSupport
        function geometricSupport = getgeometricSupport(obj)
            geometricSupport = obj.geometricSupport;
        end
        
        %% calculate Jacobian
        function J = calcJacobian(obj,Coord)
            J = obj.geometricSupport.calcJacobian(Coord);
        end
        
        function detJ = calcDetJacobian(obj,Coord)
            detJ = obj.geometricSupport.calcDetJacobian(Coord);
        end
        
        %% map edge coordinates to global coordinates
        function GlobalCoord = mapLocalToGlobal(obj,LineCoord)
            GlobalCoord = obj.geometricSupport.mapLocalToGlobal(LineCoord);
        end
        
        %% map global coordinates to edge coordinates
        function LocalCoord = mapGlobalToLocal(obj,GlobalCoord)
            LocalCoord = obj.geometricSupport.mapGlobalToLocal(GlobalCoord);
        end
        
        %% get all degrees of freedom
        function dofs = getDof(obj)
            dofs = obj.dofs;
        end
        
        %% get degrees of freedom of one field component
        function dofs = getDofsForIndex(obj, fieldComponentIndex)
            dofs = obj.dofs( 1 + ( fieldComponentIndex - 1) * obj.numberOfDofsPerFieldComponent: ...
                fieldComponentIndex * obj.numberOfDofsPerFieldComponent);
        end
    end
    
    properties (Access = protected)
        geometricSupport
        dofs
        numberOfDofsPerFieldComponent
    end
    
end

