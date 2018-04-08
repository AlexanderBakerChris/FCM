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
 
% Test of Logger
classdef LoggerTest < TestCase
   
    properties
        MyLogger
    end
    
    methods
        %% Constructor
        function obj = LoggerTest(name)
            obj = obj@TestCase(name);        
        end
        
        %% Set Up
        function setUp(obj)
            % the clear all commands restore the initial conditions of
            % matlab to use the logger properly and avoid any crash during
            % testing
            clear all;
            obj.MyLogger = Logger;
            
            % create a different log file if the toolbox is used in linux
            % or in windows
            if (strcmp(computer,'GLNX86') == 1 || strcmp(computer,'GLNXA64') == 1)
                obj.MyLogger.setPathForLogger('LoggerTest.m','loggerTestGlnx.out',1);
            elseif (strcmp(computer,'PCWIN') == 1 || strcmp(computer,'PCWIN64') == 1)
                obj.MyLogger.setPathForLogger('LoggerTest.m','loggerTestPcwin.out',1);
            end

            obj.MyLogger.ConsoleLevel('silent');

            obj.MyLogger.Log('We are logging!1 ','highlight');
            obj.MyLogger.Log('We are logging!2 ','release');
            obj.MyLogger.Log('We are logging!3 ','debug');
            
            obj.MyLogger.LogFileLevel('release');
            
            obj.MyLogger.Log('We are logging!4 ','highlight');
            obj.MyLogger.Log('We are logging!5 ','release');
            obj.MyLogger.Log('We are logging!6 ','debug');
            clear all;
        end
        
        %% Tear Down
        function tearDown(obj)
            Logger.ConsoleLevel('silent');
        end
        
        %% Testing log out file
        function testLogger(obj)
            % The log file has different size according to the platform
            % where the toolbox is running
            if (strcmp(computer,'GLNX86') == 1 || strcmp(computer,'GLNXA64') == 1)
                assertFilesEqual('loggerTestGlnx.out','logTrueGLNX.out');
            elseif (strcmp(computer,'PCWIN') == 1 || strcmp(computer,'PCWIN64') == 1)
                assertFilesEqual('loggerTestPcwin.out','logTruePCWIN.out');
            end
        end
                 
    end
    
end