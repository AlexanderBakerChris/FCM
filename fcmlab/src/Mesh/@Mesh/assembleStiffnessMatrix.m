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
% Submitted to Advances in Engineering Software, 2013					          %
%                                                                       %
%=======================================================================%
 
%assembleStiffnessMatrix function
%   This function assembles the element stiffness matrix and get the 
%   global one.
%   The global stiffness matrix is initalized with the number of degrees
%   of freedom, then the element values are taken and assembled into the 
%   global stiffness matrix, this is done using the location matrix LM.

function K = assembleStiffnessMatrix(obj)
    Logger.TaskStart('Calculating global stiffness matrix K','release');
    numberOfDofs = obj.NumberOfDofs;

    Logger.Log(['nDofs = ' num2str(numberOfDofs)],'release');

    K = sparse(numberOfDofs,numberOfDofs); % Initializing global stiffness matrix K

    TCalc = 0;
    TScatter = 0;
    
    for i = 1:length(obj.Elements)

        tCalc = tic;
        % Element stiffness matrix Ke
        Ke = obj.Elements(i).calcStiffnessMatrix;
        TCalc = TCalc + toc(tCalc);
        
        tScatter = tic;
        % Element location matrix LM
        LM = obj.Elements(i).getLocationMatrix;
              
        K = obj.scatterElementMatrixIntoGlobalMatrix(Ke,LM,K);

        TScatter = TScatter + toc(tScatter);
    end
    
    Logger.Log(['Tcalc: ' num2str(TCalc)],'release');
    Logger.Log(['TScatter: ' num2str(TScatter)],'release');
    Logger.TaskFinish('Calculating global stiffness matrix K','release');

end
