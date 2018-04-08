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
 
% scatterSolution function
%   This function scatters the solution into the topology (nodes, edges,
%   faces and solids).

function scatterSolution(obj,SolutionVectors)

numberOfSoultions = size(SolutionVectors,2);

Logger.TaskStart('Scattering The Solution Vectors Into Topology','release');
Logger.Log(['Scattering ',num2str(numberOfSoultions),' Solutions'],'release');

for s = 1:numberOfSoultions;
    
    % Scattering over the nodes
    scatterTopologyItem(obj.Nodes,SolutionVectors(:,s),s);
    
    % Scattering over the edges
    scatterTopologyItem(obj.Edges,SolutionVectors(:,s),s);
    
    % Scattering over the faces
    scatterTopologyItem(obj.Faces,SolutionVectors(:,s),s);
    
    % Scattering over the solids
    scatterTopologyItem(obj.solids,SolutionVectors(:,s),s);
    
end

for i = 1:length(obj.Elements)
    obj.Elements(i).assembleAndCacheDofVector(numberOfSoultions);
end

Logger.TaskFinish('Scattering The Solution Vector','release');
end

%% scatter topology item
function scatterTopologyItem(TopologyItem,SolutionVector,SolutionNumber)

for i = 1:length(TopologyItem)
    DofHandle = TopologyItem(i).getDof();
    for j = 1:length(DofHandle)
        id = DofHandle(j).Id;
        DofHandle(j).Value(SolutionNumber) = SolutionVector(id);
    end
end

end
