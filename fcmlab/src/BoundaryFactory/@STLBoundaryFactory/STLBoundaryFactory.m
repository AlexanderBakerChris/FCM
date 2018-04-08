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
 
% STLBoundaryFactory

classdef STLBoundaryFactory < AbsBoundaryFactory
    
    methods (Access = public)
        %% constructor
        function obj = STLBoundaryFactory(BinarySTLFile)
            obj.BinarySTLFile = BinarySTLFile;
        end
        
        %%
        function Boundary = getBoundary(obj)
            
            Boundary = [];
            
            [x,y,z] = obj.stlread(obj.BinarySTLFile);
            
            for i = 1:size(x,2);
                Vertex1 = Vertex([x(1,i) y(1,i) z(1,i)]); 
                Vertex2 = Vertex([x(2,i) y(2,i) z(2,i)]);
                Vertex3 = Vertex([x(3,i) y(3,i) z(3,i)]);
                Line1 = Line(Vertex1,Vertex2);
                Line2 = Line(Vertex2,Vertex3);
                Line3 = Line(Vertex1,Vertex3);
                Boundary = [Boundary ...
                    Triangle([Vertex1 Vertex2 Vertex3],[Line1 Line2 Line3])];
            end  
            
        end
    end
    
    methods (Access = private)
        [x y z] = stlread(obj,Filename);
    end
    
    properties (Access = private)
        BinarySTLFile
    end
    
end