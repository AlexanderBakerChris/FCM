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
 
% Abstract class for postprocessing in 1D case
%   Outputs a plot of the solution, taking as input the mesh, the length 
%   of the beam, and the number of points for the plot. 
classdef PostProcessor1D < PostProcessor
    
    properties (Access = protected)
        NumberOfPoints % number of points that will be plotted
        NumberOfElements
        Length
        LengthOfElements
    end
    
    
    methods
        %% Constructor
        function obj = PostProcessor1D(Length,NumberOfPoints)
            if ~(round(NumberOfPoints)==NumberOfPoints)
                Logger.ThrowException('Error! Resolution is not an integer!');
            end
            obj.NumberOfPoints = NumberOfPoints; % it would be good to check if NumberOfPoints is an integer
%             obj.Mesh = Mesh;
            obj.Length = Length;
        end 
                
        
        %% processMesh
        % Set the solution matrix to be plotted
        function processMesh(obj,Mesh)
            
            obj.Mesh = Mesh;
            
            % initialize what has not been initialized in the constructor
            obj.NumberOfElements = obj.Mesh.getNumberOfElements();
            obj.LengthOfElements = obj.Length/obj.NumberOfElements;
            % Set resolution
            PlotResolution = obj.Length/(obj.NumberOfPoints);
            % Loop to fill Solution
            obj.Solution = zeros(2,obj.NumberOfPoints); % pre allocation
            for i=1:(obj.NumberOfPoints)
                x = PlotResolution*(i-1); % global coordinate
                obj.Solution(1,i) = x;
                obj.Solution(2,i) = obj.getSolutionAtX(x);   
            end
            Logger.Log('Meshed for PostProcessor.','debug');
        end
        
        %% getSolutionAtX
        function SolutionValueAtX = getSolutionAtX(obj,x)
            [Element,r] = obj.getElementAndLocalCoordinate(x);
            SolutionValueAtX = obj.getSolutionOfElementAtR(Element,r);
        end
        
        %% plotSolutionColorful
        function plotSolutionColorful(obj)
            figure;
            [X,Y] = meshgrid(0:(obj.Length-0.01)/(obj.NumberOfPoints-1):obj.Length-0.01, 0:obj.Length/10:obj.Length/10);
            for i=1:obj.NumberOfPoints
                Z(1,i)=obj.getSolutionAtX(X(1,i));
            end
            Z(2,:)=Z(1,:);
            hh=surfc(X,Y,Z);                        % handle of the graph
            view(0,90);                         
            axis equal;
            set(hh,'LineStyle','none');             %  switch the grid line off
            title(obj.PlotTitle);
        end
                
        
        %% getElementAndLocalCoordinate
        function [Element,r] = getElementAndLocalCoordinate(obj,x)
            ElementIndex = floor(x/obj.LengthOfElements)+1;
            Element = obj.Mesh.getElement(ElementIndex);
            r = Element.mapGlobalToLocal(x);
            % test wrong cases : "exception": test it (chercher sur google)
            % faire des tests n�gatifs
        end
        
        %% plotSolution
        function plotSolution(obj)
            figure;
            obj.Plot=plot(obj.Solution(1,:),obj.Solution(2,:));
            title(obj.PlotTitle);
        end
        
        %% integration
        function result = integration(obj,Mesh)
            result = 0;
            elements = Mesh.getElements();
            for i=1:length(elements)
%                 order=elements(i).getOrder();
                IntegrationCoordinates = elements(i).getIntegrator().getCoordinates();
                IntegrationWeights = elements(i).getIntegrator().getWeights();
                
                for j = 1:length(IntegrationCoordinates);
                    Jacobian = elements(i).calcJacobian([]);
                    result = result + IntegrationWeights(j) * ...
                        obj.getSolutionOfElementAtR(elements(i),IntegrationCoordinates{j}) * Jacobian(1);
                end
            end
        end
        
        %% get and set properties functions
        function NumberPoints = getNumberOfPoints(obj)
            NumberPoints = obj.NumberOfPoints;
        end
        function Mesh = getMesh(obj)
            Mesh = obj.Mesh;
        end
        function Length = getLength(obj)
            Length = obj.Length;
        end
        function setLengthOfElements(obj,LengthOfElements)
            obj.LengthOfElements = LengthOfElements;
        end
        function Solution = getSolution(obj)
            Solution = obj.Solution;
        end
        
    end

        
    methods (Abstract)
        %% getSolutionOfElementAtR
        % Dependent on the type of solution asked (displacement, stress)
        % don't forget ;
        SolutionValueAtR = getSolutionOfElementAtR(obj,Element,r);        
    end
    
end

    