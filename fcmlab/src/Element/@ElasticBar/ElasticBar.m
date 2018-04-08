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
 
% Class ElasticBar
%   This class defines a 1D bar element under distributed axial loading.

classdef ElasticBar < AbsElement
    
    methods(Access = public)
        %% constructor
        function obj = ElasticBar(Nodes,Edges,Material,Integrator,...
                PolynomialDegree,DofDimension,Domain)
            SpaceDimension = 1;
            obj = obj@AbsElement(Nodes,Edges,[],[],Material,Integrator,...
                PolynomialDegree,DofDimension,SpaceDimension,Domain);
            obj.geometricSupport = Edges(1).getLine();
        end
        
        %%
        N = evalShapeFunct(obj,Coord)
        dN = evalDerivOfShapeFunct(obj,Coord)
        B = getB(obj,Coord)
        
        LocalCoord = mapGlobalToLocal(obj,GlobalCoord)
        GlobalCoord = mapLocalToGlobal(obj,LocalCoord)
        
        %% calculate the Jacobian
        function J = calcJacobian(obj,Coord)
            J = obj.edges.calcJacobian(Coord);
        end
        
        %% calculate the determinant of the Jacobian
        function detJ = calcDetJacobian(obj,Coord)
            detJ = obj.edges.calcDetJacobian(Coord);
        end
        
    end
    
    methods (Access = protected)
        %%
        NodalModes = evalNodalModes(obj,Coord);
        EdgeModes = evalEdgeModes(obj,Coord);
        
        NodalModesDerivR = evalNodalModesDeriv(obj,Coord);
        EdgeModesDerivR = evalEdgeModesDeriv(obj,Coord);
        
        function FaceModes = evalFaceModes(obj)
            FaceModes = [];
        end
        
        function VolumeModes = evalVolumeModes(obj)
            VolumeModes = [];
        end
        
        function FaceModesDeriv = evalFaceModesDeriv(obj)
            FaceModesDeriv = [];
        end
        
        function VolumeModesDeriv = evalVolumeModesDeriv(obj)
            VolumeModesDeriv = [];
        end
        
    end    
    
    properties (Access = private)
    end
    
end