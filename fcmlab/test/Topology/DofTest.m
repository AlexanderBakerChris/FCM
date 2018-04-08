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
 
% Testing of Dof class
classdef DofTest < TestCase
   properties
       Dof
   end
   
   methods
      %% Constructor
      function obj = DofTest(name)
          obj = obj@TestCase(name);
      end
      
      %% Set up
      function setUp(obj)
          obj.Dof = Dof(1);
          obj.Dof.setValue(1,1);
      end
      
      %% Tear down
      function TearDown(obj)
      end
      
      %% Test Get and Set ID
      function testId(obj)
          assertEqual(obj.Dof.getId(), 1); %test the current ID
          obj.Dof.setId(2); %set new ID
          assertEqual(obj.Dof.getId(), 2); %test new ID
      end
      
      %% Test Get and Set Value
      function testValue(obj)
          assertEqual(obj.Dof.getValue(1), 1); 
      end
      
      %% Test Get and Set Load
%       function testLoad(obj)
%           assertEqual(obj.Dof.getLoad, []);
%           obj.Dof.setLoad(1);
%           assertEqual(obj.Dof.getLoad, 1);
%       end
   end
end