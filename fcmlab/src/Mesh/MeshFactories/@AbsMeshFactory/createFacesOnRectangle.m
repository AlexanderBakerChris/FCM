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
 
function FacesOnRectangle = createFacesOnRectangle(obj,...
    NodesOnRectangle,EdgesOnRectangle,NumberOf1Divisions,NumberOf2Divisions)

NumberOf1Edges = NumberOf1Divisions*(NumberOf2Divisions+1);
FacesOnRectangle = [];

% A face has a node distribution as follows:
%  4        3
%  o--------o
%  |        |
%  |        |
%  |        |
%  o--------o
%  1        2

% A face has an edge distribution as follows:
%        3
%   o--------o
%   |        |
% 4 |        |2
%   |        |
%   o--------o
%       1

% loop in  direction-2
for i=1:NumberOf2Divisions
    
    % loop in direction-1
    for j=1:NumberOf1Divisions
        % Node Indices
        Node1Id = j + (i-1)*(NumberOf1Divisions+1);
        Node2Id = Node1Id + 1;
        Node4Id = Node1Id + (NumberOf1Divisions+1);
        Node3Id = Node4Id + 1;
        
        % Edge Indices
        Edge1Id = j + (i-1)*NumberOf1Divisions;
        Edge3Id = Edge1Id + NumberOf1Divisions;
        Edge4Id = NumberOf1Edges + (j-1)*NumberOf2Divisions + i;
        Edge2Id = Edge4Id + NumberOf2Divisions;
        
        
        FacesOnRectangle = [FacesOnRectangle Face(...
            NodesOnRectangle([Node1Id Node2Id Node3Id Node4Id]),...
            EdgesOnRectangle([Edge1Id Edge2Id Edge3Id Edge4Id]),...
            obj.PolynomialDegree, obj.DofDimension)];
    
    end
    
end

end

