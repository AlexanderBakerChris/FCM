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
 
% Test of edge class
classdef EdgeTest < TestCase
   properties
       MyEdge
   end
   
   methods
       %% Constructor
       function obj = EdgeTest(name)
           obj = obj@TestCase(name);           
       end
       
       %% Set up
       function setUp(obj)
           DofDimension = 1;
           PolynomialDegree = 4;
           obj.MyEdge = Edge([Node([1 2 3],1) Node([6 5 4],1)],PolynomialDegree,...
               DofDimension);
       end
       
       %% Tear Down
       function tearDown(obj)
       end
       
       %% Test get nodes
       function testGetNodes(obj)
           assertEqual(obj.MyEdge.getNodes, [Node([1 2 3],1) Node([6 5 4],1)]);
       end
       
       %% Test the Edge Dof
       function testEdgeDof(obj) 
           assertEqual(obj.MyEdge.getDof(), [Dof(0) Dof(0) Dof(0)]);
       end
       
       %% Test Calculate Jacobian
       function testCalcJacobian(obj)
           LocalCoord = NaN; % just to work with the interface
           assertElementsAlmostEqual(obj.MyEdge.calcJacobian(LocalCoord),[(6-1)/2,(5-2)/2,(4-3)/2]);
       end
            
        %% Test mapping from local to global
        function testMapLocalToGlobalCoords(obj)
            GlobalCoordinates1 = obj.MyEdge.mapLocalToGlobal(-1);
            GlobalCoordinates2 = obj.MyEdge.mapLocalToGlobal(0);
            GlobalCoordinates3 = obj.MyEdge.mapLocalToGlobal(1);
            assertEqual(GlobalCoordinates1,[1 2 3]);
            assertEqual(GlobalCoordinates2,[3.5 3.5 3.5]);
            assertEqual(GlobalCoordinates3,[6 5 4]);
        end
        
%         %% Test mapping from global to local
%         function testMapGlobalToLocalCoords(obj)
%             
%         end
   end
end