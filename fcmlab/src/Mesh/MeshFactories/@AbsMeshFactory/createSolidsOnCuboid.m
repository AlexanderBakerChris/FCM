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
 
function SolidsOnCuboid = createSolidsOnCuboid(obj,...
    NodesOnCuboid,EdgesOnCuboid,FacesOnCuboid)
SolidsOnCuboid = [];

% useful for determining indices of edges and faces
NumberOfXEdges = obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1)*(obj.NumberOfZDivisions+1);
NumberOfYEdges = obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1)*(obj.NumberOfXDivisions+1);

NumberOfXYFaces = obj.NumberOfXDivisions*obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
NumberOfYZFaces = obj.NumberOfYDivisions*obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);

for i=1:obj.NumberOfZDivisions
    for j=1:obj.NumberOfYDivisions
        for k=1:obj.NumberOfXDivisions
            
            % indices of nodes
            Node1 = k + (j-1)*(obj.NumberOfXDivisions+1)...
                + (i-1)*(obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
            Node2 = Node1 + 1;
            Node4 = Node1 + (obj.NumberOfXDivisions+1);
            Node3 = Node4 + 1;
            Node5 = Node1 + (obj.NumberOfXDivisions+1)*(obj.NumberOfYDivisions+1);
            Node6 = Node5 + 1;
            Node8 = Node5 + (obj.NumberOfXDivisions+1);
            Node7 = Node8 + 1;
            
            % indices of edges
            Edge1 = k + (j-1)*obj.NumberOfXDivisions ...
                + (i-1)*obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
            Edge3 = Edge1 + obj.NumberOfXDivisions;
            Edge4 = NumberOfXEdges + j + (i-1)*obj.NumberOfYDivisions ...
                + (k-1)*obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
            Edge2 = Edge4 + obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
            Edge9 = Edge1 + obj.NumberOfXDivisions*(obj.NumberOfYDivisions+1);
            Edge11 = Edge9 + obj.NumberOfXDivisions;
            Edge12 = Edge4 + obj.NumberOfYDivisions;
            Edge10 = Edge12 + obj.NumberOfYDivisions*(obj.NumberOfZDivisions+1);
            Edge5 = NumberOfXEdges + NumberOfYEdges + i + (k-1)*obj.NumberOfZDivisions ...
                + (j-1)*obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);
            Edge6 = Edge5 + obj.NumberOfZDivisions;
            Edge8 = Edge5 + obj.NumberOfZDivisions*(obj.NumberOfXDivisions+1);
            Edge7 = Edge8 + obj.NumberOfZDivisions;
            
            % indices of faces
            Face1 = k + (j-1)*obj.NumberOfXDivisions...
                + (i-1)*obj.NumberOfXDivisions*obj.NumberOfYDivisions;
            Face6 = Face1 + obj.NumberOfXDivisions*obj.NumberOfYDivisions;
            Face5 = NumberOfXYFaces + j + (i-1)*obj.NumberOfYDivisions...
                + (k-1)*obj.NumberOfYDivisions*obj.NumberOfZDivisions;
            Face3 = Face5 + obj.NumberOfYDivisions*obj.NumberOfZDivisions;
            Face2 = NumberOfXYFaces + NumberOfYZFaces + i + (k-1)*obj.NumberOfZDivisions...
                + (j-1)*obj.NumberOfZDivisions*obj.NumberOfXDivisions;
            Face4 = Face2 + obj.NumberOfZDivisions*obj.NumberOfXDivisions;
            
            % picking nodes, edges, and faces
            Nodes = NodesOnCuboid([Node1 Node2 Node3 Node4 Node5 Node6 Node7 Node8]);
            Edges = EdgesOnCuboid([Edge1 Edge2 Edge3 Edge4 Edge5 Edge6 Edge7 Edge8 Edge9 Edge10 Edge11 Edge12]);
            Faces = FacesOnCuboid([Face1 Face2 Face3 Face4 Face5 Face6]);
            
            % creating solids
            SolidsOnCuboid = [SolidsOnCuboid ...
                Solid(Nodes,Edges,Faces,obj.PolynomialDegree,obj.DofDimension)];
            
        end
    end
end

end