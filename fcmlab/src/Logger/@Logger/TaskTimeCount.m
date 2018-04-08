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
 
%% TaskTimeCount
function TaskTimeCount( command, TaskName, InLevel )

persistent timeCount
persistent taskNames
persistent top

if isempty(top)
    top = 0;
    %timeNames = zeors(10,50);
end
if strcmp(command,'start')
    top = top + 1;
    temp = clock;
    timeCount(top) = temp(4)*3600+temp(5)*60+temp(6);%tic
    %TaskName
    taskNames(top,1:length(TaskName)) = TaskName;
    Logger.Log([TaskName '......'], InLevel, 1);
end
if strcmp(command,'finish')
    if top == 0
        Logger.Log('More TaskFinish than TaskStart ','highlight',0);
    else
        if strcmp(char(taskNames(top,1:length(TaskName))),TaskName)
            temp = clock;
            time= temp(4)*3600+temp(5)*60+temp(6) - timeCount(top); %toc
            tempStr = [TaskName ' finished. Cost ' num2str(time, '%.3f') 's'];
            Logger.Log(tempStr, InLevel, -1);
            top = top - 1;
        else
            Logger.Log(['No TaskFinish for ' char(taskNames(top,:)) ' '],'highlight',0);
        end
    end
end
if strcmp(command,'clear')
    top = 0;
end

end