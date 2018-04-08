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

function eigenvalues = solve(obj)

stiffnessMatrix = obj.mesh.assembleStiffnessMatrix;
massMatrix = obj.mesh.assembleMassMatrix;
loadVector = zeros(length(stiffnessMatrix),1);

for i = 1:length(obj.dirichletBoundaryConditions)
    [stiffnessMatrix, ~] = ...
        obj.dirichletBoundaryConditions{i}.modifyLinearSystem(obj.mesh,stiffnessMatrix,loadVector);
end

Logger.TaskStart('Solving for Eigenmodes','release');

[eigenvectors, obj.eigenvaluesDiagonal, convergenceFlag] = ...
    eigs(stiffnessMatrix,massMatrix,obj.numberOfEigenmodes,'SM');

Logger.TaskFinish('Solving for Eigenmodes','release');

if convergenceFlag ~= 0
    Logger.Log('Warning: solver did not converge for all eigenvalues!!','highlight');
end

for n =1:obj.numberOfEigenmodes
    Logger.Log(['Mode ', num2str(n)],'release');
    Logger.Log(['EigenValue: ', num2str(obj.eigenvaluesDiagonal(n,n))],'release');
    Logger.Log(['EigenFreq: ', num2str( sqrt(obj.eigenvaluesDiagonal(n,n))/(2*pi) ) ],'release');
    Logger.Log('','release');
    
    %normalize eigenvectors to have 2-norm = 1
    eigenvectors(:,n) = eigenvectors(:,n)/norm(eigenvectors(:,n));
end

obj.mesh.scatterSolution(eigenvectors);

eigenvalues = diag( obj.eigenvaluesDiagonal );

end
