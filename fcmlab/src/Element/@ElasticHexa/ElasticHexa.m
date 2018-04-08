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
 
% Class ElasticHexa
% A 3D-hexahedral element for pFEM and FCM is defined

classdef ElasticHexa < AbsElement
    
    methods(Access = public)
        %% constructor
        function obj = ElasticHexa(Nodes,Edges,Faces,Solid,Material,Integrator,...
                PolynomialDegree,DofDimension,Domain)
            SpaceDimension = 3;
            obj = obj@AbsElement(Nodes,Edges,Faces,Solid,Material,Integrator,...
                PolynomialDegree,DofDimension,SpaceDimension,Domain);
            obj.geometricSupport = Solid(1).getSolid();
        end
        
        %%
        N = evalShapeFunct(obj,Coord);
        dN = evalDerivOfShapeFunct(obj,Coord);
        B = getB(obj,Coord);
        
        LocalCoord = mapGlobalToLocal(obj,GlobalCoord);
        GlobalCoord = mapLocalToGlobal(obj,LocalCoord);
        
        %% calculate the jacobian of the element
        function J = calcJacobian(obj,LocalCoord)
            J = obj.solid.calcJacobian(LocalCoord);
        end
        
        %% calculate det jacobian
        function detJ = calcDetJacobian(obj,LocalCoords)
            detJ = obj.solid.calcDetJacobian(LocalCoords);
        end
        
    end
    
    methods (Access = protected)
        NodalModes = evalNodalModes(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS);
        EdgeModes = evalEdgeModes(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DofsPerEdge);
        FaceModes = evalFaceModes(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DofsLocalDirection);
        VolumeModes = evalVolumeModes(obj,PhiR,PhiS,PhiT,InternalModes);
        
        NodalModesDeriv = evalNodalModesDeriv(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS)
        EdgeModesDeriv = evalEdgeModesDeriv(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsPerEdge)
        FaceModesDeriv = evalFaceModesDeriv(obj,OneMinusT,OnePlusT,OneMinusR,OnePlusR,OneMinusS,OnePlusS,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,DofsPerFace)
        VolumeModesDeriv = evalVolumeModesDeriv(obj,PhiR,PhiS,PhiT,DerivPhiR,DerivPhiS,DerivPhiT,NumberOfInternalModes)
    end
    
    properties (Access = private)
    end
    
end

