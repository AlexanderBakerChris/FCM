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
 
%% setPathForLogger
%   Allows to create the *.out file where we want and with the name we want
%   "CurrentMFile" is the name of the .m file where the function is called,
%   the *.out file will be created in the same folder as this .m file.
%   "NameOutPutFile" is the name of the desired output file, the ".out"
%   needs to be written.
%   "Option" take 1 to start writting a *.out file from zero. If any other
%   option number, then the logger will continue in the existing previous
%   file, if there was no previous file it will create a new one.

function setPathForLogger(CurrentMFile,NameOutputFile,Option)

dir = fileparts(which(CurrentMFile));
cd(dir);

% determine if matlab is running under windows or linux
if (strcmp(computer,'GLNX86') == 1 || strcmp(computer,'GLNXA64') == 1)
    LoggerPath = [dir '/' NameOutputFile];
elseif (strcmp(computer,'PCWIN') == 1 || strcmp(computer,'PCWIN64') == 1)
    LoggerPath = [dir '\' NameOutputFile];
end

if (Option == 1 && exist(NameOutputFile,'file') == 2)% 2 if NameOutputFile is an M-file on MATLAB's search path.
    delete(LoggerPath); % Delete previous *.out file and start from zero
end
Logger.FileName(LoggerPath);
delete('log.out'); % 'log.out' is the default file name in the logger

end