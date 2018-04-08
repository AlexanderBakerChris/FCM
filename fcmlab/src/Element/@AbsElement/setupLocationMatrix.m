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
 
%setUpLocationMatrix sets up the location matrix for the elements.
%  id of nodalDofs is stored first, followed by ids of edgeDofs (local 
%  numbering scheme), then the id of faceDofs and finally the id of 
%  volumeDofs.

function LocationMatrix = setupLocationMatrix(obj)

numberOfElementDofs = (obj.PolynomialDegree+1)^obj.SpaceDimension;
LocationMatrix = zeros(1,obj.DofDimension*numberOfElementDofs);

for d = 1:obj.DofDimension    
    % initialize position of the vector
    N = 0;
    
    % store the node Dofs into the LocationMatrix
    setupLocationMatrixTopology(obj.nodes,0);
    
    % set the position after the Nodes
    N = length(obj.nodes);

    % store the edge Dofs into the LocationMatrix
    setupLocationMatrixTopology(obj.edges,1);
    
    % set the position after the Edges
    N = N + length(obj.edges)*(obj.PolynomialDegree -1);
    
    % store the face Dofs into the LocationMatrix
    setupLocationMatrixTopology(obj.faces,2);
    
    % set the position after the Faces
    N = N + length(obj.faces)*(obj.PolynomialDegree -1)^2;
    
    % store the volume Dofs into the LocationMatrix
    setupLocationMatrixTopology(obj.solid,3);
    
end

    % nested function to modify location matrix according to the topology
    function setupLocationMatrixTopology(Topology,spaceDimension)
        for i=1:length(Topology)
            DofHandle = Topology(i).getDof();
            
            numberOfTopolgyDofs = (obj.PolynomialDegree -1)^spaceDimension;
            
            for j = 1:numberOfTopolgyDofs
                LocationMatrix(N+j+(i-1)*numberOfTopolgyDofs+(d-1)*numberOfElementDofs)...
                    = DofHandle(j+(d-1)*numberOfTopolgyDofs).Id;
            end
        end
    end

end

