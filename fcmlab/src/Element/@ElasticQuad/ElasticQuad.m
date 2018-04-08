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
 
% Class ElasticQuad
% A 2D-rectangular element is defined for pFEM and FCM analysis
% It is a plane element without any thickness defined

classdef ElasticQuad < AbsElement
    
    methods(Access = public)
        %% constructor
        function obj = ElasticQuad(Nodes,Edges,Faces,Material,Integrator,...
                PolynomialDegree,DofDimension,Domain)
            SpaceDimension = 2;
            obj = obj@AbsElement(Nodes,Edges,Faces,[],Material,Integrator,...
                PolynomialDegree,DofDimension,SpaceDimension,Domain);
            obj.geometricSupport = Faces(1).getQuad();
        end
        
        %%
        N = evalShapeFunct(obj,Coord);
        dN = evalDerivOfShapeFunct(obj,Coord);
        B = getB(obj,Coord);
        
        LocalCoord = mapGlobalToLocal(obj,GlobalCoord);
        GlobalCoord = mapLocalToGlobal(obj,LocalCoord);
        
        %% calculate the jacobian of the element
        function J = calcJacobian(obj,LocalCoords)
            J = obj.faces.calcJacobian(LocalCoords);
        end

        %% calculate det jacobian
        function detJ = calcDetJacobian(obj,LocalCoords)
            detJ = obj.faces.calcDetJacobian(LocalCoords);
        end
        
    end
    
    methods (Access = protected)
        %%
        NodalModes = evalNodalModes(obj,OneMinusR,OnePlusR,OneMinusS,OnePlusS);
        EdgeModes = evalEdgeModes(obj,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,DofsLocalDirection);
        FaceModes = evalFaceModes(obj,PhiR,PhiS,DofsLocalDirection);
        
        NodalModesDeriv = evalNodalModesDeriv(obj,OneMinusR,OnePlusR,OneMinusS,OnePlusS);
        EdgeModesDeriv = evalEdgeModesDeriv(obj,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,DerivPhiR,DerivPhiS,DofsLocalDirection);
        FaceModesDeriv = evalFaceModesDeriv(obj,PhiR,PhiS,DerivPhiR,DerivPhiS,DofsLocalDirection);
        
        function VolumeModes = evalVolumeModes(obj)
            VolumeModes = [];
        end
        
        function VolumeModesDeriv = evalVolumeModesDeriv(obj)
            VolumeModesDeriv = [];
        end
        
    end
    
    properties (Access = private)
    end
    
end

