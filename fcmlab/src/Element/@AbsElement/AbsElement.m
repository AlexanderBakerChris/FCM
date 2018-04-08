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
 
% abstract element handle class for a pFEM/FCM combination
%   This class defines the interface for the elements.
%   Specific element types and their behaviour need to be specified in
%   subclasses.

classdef AbsElement < handle
    
    methods (Access = public)
        %% constructor
        function obj = AbsElement(Nodes,Edges,Faces,Solid,Material,Integrator,...
                PolynomialDegree,DofDimension,SpaceDimension,Domain)
            obj.id = obj.incrementId();
            obj.nodes = Nodes;
            obj.edges = Edges;
            obj.faces = Faces;
            obj.solid = Solid;
            obj.PolynomialDegree = PolynomialDegree;
            obj.DofDimension = DofDimension;
            obj.SpaceDimension = SpaceDimension;
            obj.LocationMatrix = obj.setupLocationMatrix();
            obj.material = Material;
            obj.Integrator = Integrator;
            obj.domain = Domain;
            obj.jacobianAtCenter = obj.calcJacobian([0 0 0]);
        end
        
        %%
        LoadVector = calcBodyLoadVector(obj,LoadFunction);
        M = calcMassMatrix(obj);
        Ke = calcStiffnessMatrix(obj);
        Value = doDomainIntegration(obj,Integrand,Points,Weights);
        assembleAndCacheDofVector(obj, numberOfSoultions);
        DofVector = getDofVector(obj, SolutionNumber);
        SubDomains = getIntegrationCells(obj);
        Mat = getMaterialAtPoint(obj, Coord);
        N = getShapeFunctionsMatrix(obj,LocalCoord);

        %% get location matrix
        function LocationMatrix = getLocationMatrix(obj)
            LocationMatrix = obj.LocationMatrix;
        end
        
        %% get Id
        function id = getId(obj)
            id = obj.id;
        end
        
        %% get Nodes
        function nodes = getNodes(obj)
            nodes = obj.nodes;
        end
        
        %% get Edges
        function edges = getEdges(obj)
            edges = obj.edges;
        end
        
        %% get Faces
        function faces = getFaces(obj)
            faces = obj.faces;
        end
        
        %% get material(s)
        function material = getMaterial(obj)
            material = obj.material;
        end
        
        %% get polynomial degree
        function degree = getPolynomialDegree(obj)
            degree = obj.PolynomialDegree;
        end
        
        %% get Dof dimension
        function DofDimension = getDofDimension(obj)
            DofDimension = obj.DofDimension;
        end
        
        %% get space dimension
        function SpaceDimension = getSpaceDimension(obj)
            SpaceDimension = obj.SpaceDimension;
        end
        
        %% get integrator
        function Integrator = getIntegrator( obj )
            Integrator = obj.Integrator;
        end
        
        %%
        function support = getGeometricSupport( obj )
            support = obj.geometricSupport;
        end
        
        %%
        function domainIndex = getDomainIndex( obj, globalCoords )
            domainIndex = obj.domain.getDomainIndex( globalCoords );
        end
        
    end
    
    methods(Abstract, Access = public)
        %%
        N = evalShapeFunct(obj,Coord);
        dN = evalDerivOfShapeFunct(obj,Coord);
        B = getB(obj,Coord);
        J = calcJacobian(obj);
        detJ = calcDetJacobian(obj,LocalCoords);
        
        LocalCoord = mapGlobalToLocal(obj,GlobalCoord);
        GlobalCoord = mapLocalToGlobal(obj,LocalCoord);
        
    end
    
    methods (Access = protected)
        %%
        LocationMatrix = setupLocationMatrix(obj);
        
        function Phi = evalPhi(~,i,Coord)
            Phi = 1/sqrt(4*i-2);
            Phi = Phi *(getLegendrePolynomial(Coord,i)-getLegendrePolynomial(Coord,i-2));
        end
        
        function dPhi = evalDerivOfPhi(~,i,Coord)
            dPhi = 1/sqrt(4*i-2);
            dPhi = dPhi *(getLegendrePolynomialDerivative(Coord,i)-getLegendrePolynomialDerivative(Coord,i-2));
        end
        
        %% get jacobian in zero zero coordinates (used for getB)
        function jacobianZeroZero = getJacobianZeroZero(obj)
            jacobianZeroZero = obj.jacobianAtCenter;
        end
        
    end
    
    methods (Abstract, Access = protected)
        
        NodalModes = evalNodalModes(obj,Coord);
        EdgeModes = evalEdgeModes(obj,Coord);
        FaceModes = evalFaceModes(obj,Coord);
        VolumeModes = evalVolumeModes(obj,Coord);
        
        NodalModesDeriv = evalNodalModesDeriv(obj,Coord);
        EdgeModesDeriv = evalEdgeModesDeriv(obj,Coord);
        FaceModesDeriv = evalFaceModesDeriv(obj,Coord);
        VolumeModesDeriv = evalVolumeModesDeriv(obj,Coord);
        
    end
    
    methods ( Static, Access = protected )
        
        %% continuous id increments while creating elements
        function id = incrementId()
            persistent Counter;
            if isempty( Counter )
                Counter = 0;
            end
            Counter = Counter+1;
            id = Counter;
        end
    end
    
    properties (Access = protected)
        id % unique ID of the element, should be the same as index in mesh
        material
        nodes
        edges
        faces
        solid
        LocationMatrix
        Integrator
        PolynomialDegree
        DofDimension
        SpaceDimension
        domain
        jacobianAtCenter % Used for getB
        geometricSupport
        dofVector
    end
end
