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
 
classdef PostProcessor1DforDisplacement < PostProcessor1D
    % Solution = displacement
    
    methods
        
        %% Constructor
        function obj = PostProcessor1DforDisplacement(Length,NumberOfPoints)
            % That's the way to code a subclass constructor
            obj = obj@PostProcessor1D(Length,NumberOfPoints);
            obj.PlotTitle='Displacement(x)';
            Logger.Log('PostProcessor1DforDisplacement Created.','debug');
        end
        
        %% doPostprocess
        function doPostprocess(obj,Mesh)
            
            Logger.TaskStart('Plotting Displacement','release');
            t = tic;
            obj.processMesh(Mesh);
            obj.plotSolution;
            Logger.TaskFinish('Plotting Displacement','release');
            
        end
        
        function doPostprocessForComparisonHP(obj,Mesh)
            
            Logger.TaskStart('Plotting Displacement','release');
            t = tic;
            obj.processMesh(Mesh);
            Logger.TaskFinish('Plotting Displacement','release');
            
        end        
        %% getSolutionOfElementAtR
        % Get the displacement ("solution" for this subclass) in Element at local coordinate r
        function SolutionValueAtR = getSolutionOfElementAtR(obj,Element,r)
            ShapeFunctionsVectorAtR = Element.evalShapeFunct(r);
            % syntax : function without input ()? or nothing?  either way work, but using () makes it clear that it's a function 
            CoefficientsVector = Element.getDofVector(1);
            SolutionValueAtR = ShapeFunctionsVectorAtR*CoefficientsVector; % scalar product for the displacement
        end 
        
    end
    
end