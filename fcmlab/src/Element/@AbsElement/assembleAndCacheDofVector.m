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
 
% assemble the solution field vector for an element from its topologies and store it


function assembleAndCacheDofVector(obj, numberOfSoultions)


obj.dofVector  = zeros(obj.DofDimension*(length(obj.nodes) + ...
                      (obj.PolynomialDegree - 1) * length(obj.edges) + ...
                      (obj.PolynomialDegree - 1)^2 * length(obj.faces) + ...
                      (obj.PolynomialDegree - 1)^3 * length(obj.solid)), numberOfSoultions);
    k = 1;
    for d=1:obj.DofDimension
        % Dof vector for nodes
        getDofVectorTopology(obj.nodes,0);
        % Dof vector for edges
        getDofVectorTopology(obj.edges,1);
        % Dof vector for faces
        getDofVectorTopology(obj.faces,2);
        % Dof fector for volumes
        getDofVectorTopology(obj.solid,3);

    end
    
    % nested function to get Dof vector depending on the topology
    function getDofVectorTopology(Topology,TopologyDegree)
        for i=1:length(Topology)
            TopologyDofs = Topology(i).getDof();
            for j=1+(obj.PolynomialDegree-1)^TopologyDegree*(d-1):(obj.PolynomialDegree-1)^TopologyDegree*d
                obj.dofVector(k,:) = TopologyDofs(j).Value;
                k = k + 1;
            end
        end
    end
    
end