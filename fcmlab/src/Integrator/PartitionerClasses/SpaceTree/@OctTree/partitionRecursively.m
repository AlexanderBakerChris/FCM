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
 
%%
function subDomains = partitionRecursively(obj, indexGeometry, support, subDomains, depthCounter)

if(obj.isIntersected(indexGeometry, support) && depthCounter < obj.Depth)
    
    % Vertices
    %
    %         +---------+---------+
    %        /|25      /|26      /|27
    %       / |       / |       / |
    %      /  |      /  |      /  |
    %     +---------+---------+   |
    %    /|22 +----/|23-+----/|24-+
    %   / |  /|16 / |  /|17 / |  /|18
    %  /  | / |  /  | / |  /  | / |
    % +---------+---------+   |/  |
    % |19 +-----|20-+-----|21-+   |
    % |  /|13 +-|--/|14-+-|--/|15-+
    % | / |  / 7| / |  / 8| / |  / 9
    % |/  | /   |/  | /   |/  | /
    % +---------+---------+   |/
    % |10 +-----|11-+-----|12-+
    % |  / 4    |  / 5    |  / 6
    % | /       | /       | /
    % |/        |/        |/
    % +---------+---------+
    %  1         2         3
    
    % Lines
    %         +----17---+---18----+
    %        /|        /|        /|
    %       34|       35|       36|
    %      /  52     /  53     /  54
    %     +----15---+---16----+   |
    %    /|   +--11/|---+--12/|---+
    %   3149 /|   3250 /|   3351 /|
    %  /  | 2843 /  | 2944 /  | 3045
    % +----13---+---14----+   |/  |
    % |   +----9|---+---10|---+   |
    % 46 /|   +-47-5|---+-486/|---+
    % | 2540 /  | 2641 /  | 2742 /
    % |/  | 22  |/  | 23  |/  | 24
    % +----7----+----8----+   |/
    % |   +----3|---+----4|---+
    % 37 /      38 /      39 /
    % | 19      | 20      | 21
    % |/        |/        |/
    % +----1----+----2----+
    
    
    vertices = Vertex.empty(27,0);
    
    vertices(1) = Vertex(indexGeometry.mapLocalToGlobal([-1.0,-1.0,-1.0]));
    vertices(2) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0,-1.0,-1.0]));
    vertices(3) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0,-1.0,-1.0]));
    vertices(4) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 0.0,-1.0]));
    vertices(5) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 0.0,-1.0]));
    vertices(6) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 0.0,-1.0]));
    vertices(7) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 1.0,-1.0]));
    vertices(8) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 1.0,-1.0]));
    vertices(9) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 1.0,-1.0]));
    
    vertices(10) = Vertex(indexGeometry.mapLocalToGlobal([-1.0,-1.0, 0.0]));
    vertices(11) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0,-1.0, 0.0]));
    vertices(12) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0,-1.0, 0.0]));
    vertices(13) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 0.0, 0.0]));
    vertices(14) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 0.0, 0.0]));
    vertices(15) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 0.0, 0.0]));
    vertices(16) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 1.0, 0.0]));
    vertices(17) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 1.0, 0.0]));
    vertices(18) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 1.0, 0.0]));
    
    vertices(19) = Vertex(indexGeometry.mapLocalToGlobal([-1.0,-1.0, 1.0]));
    vertices(20) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0,-1.0, 1.0]));
    vertices(21) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0,-1.0, 1.0]));
    vertices(22) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 0.0, 1.0]));
    vertices(23) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 0.0, 1.0]));
    vertices(24) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 0.0, 1.0]));
    vertices(25) = Vertex(indexGeometry.mapLocalToGlobal([-1.0, 1.0, 1.0]));
    vertices(26) = Vertex(indexGeometry.mapLocalToGlobal([ 0.0, 1.0, 1.0]));
    vertices(27) = Vertex(indexGeometry.mapLocalToGlobal([ 1.0, 1.0, 1.0]));
    
    subCubes = Cuboid.empty(8,0);
    
    lines = Line.empty(54,0);
    
    lines( 1) = createLine(vertices([ 1  2]));
    lines( 2) = createLine(vertices([ 2  3]));
    lines( 3) = createLine(vertices([ 4  5]));
    lines( 4) = createLine(vertices([ 5  6]));
    lines( 5) = createLine(vertices([ 7  8]));
    lines( 6) = createLine(vertices([ 8  9]));
    lines( 7) = createLine(vertices([10 11]));
    lines( 8) = createLine(vertices([11 12]));
    lines( 9) = createLine(vertices([13 14]));
    lines(10) = createLine(vertices([14 15]));
    lines(11) = createLine(vertices([16 17]));
    lines(12) = createLine(vertices([17 18]));
    lines(13) = createLine(vertices([19 20]));
    lines(14) = createLine(vertices([20 21]));
    lines(15) = createLine(vertices([22 23]));
    lines(16) = createLine(vertices([23 24]));
    lines(17) = createLine(vertices([25 26]));
    lines(18) = createLine(vertices([26 27]));
   
    lines(19) = createLine(vertices([ 1  4]));
    lines(20) = createLine(vertices([ 2  5]));
    lines(21) = createLine(vertices([ 3  6]));
    lines(22) = createLine(vertices([ 4  7]));
    lines(23) = createLine(vertices([ 5  8]));
    lines(24) = createLine(vertices([ 6  9]));
    lines(25) = createLine(vertices([10 13]));
    lines(26) = createLine(vertices([11 14]));
    lines(27) = createLine(vertices([12 15]));
    lines(28) = createLine(vertices([13 16]));
    lines(29) = createLine(vertices([14 17]));
    lines(30) = createLine(vertices([15 18]));
    lines(31) = createLine(vertices([19 22]));
    lines(32) = createLine(vertices([20 23]));
    lines(33) = createLine(vertices([21 24]));
    lines(34) = createLine(vertices([22 25]));
    lines(35) = createLine(vertices([23 26]));
    lines(36) = createLine(vertices([24 27]));
    
    lines(37) = createLine(vertices([ 1 10]));
    lines(38) = createLine(vertices([ 2 11]));
    lines(39) = createLine(vertices([ 3 12]));
    lines(40) = createLine(vertices([ 4 13]));
    lines(41) = createLine(vertices([ 5 14]));
    lines(42) = createLine(vertices([ 6 15]));
    lines(43) = createLine(vertices([ 7 16]));
    lines(44) = createLine(vertices([ 8 17]));
    lines(45) = createLine(vertices([ 9 18]));
    lines(46) = createLine(vertices([10 19]));
    lines(47) = createLine(vertices([11 20]));
    lines(48) = createLine(vertices([12 21]));
    lines(49) = createLine(vertices([13 22]));
    lines(50) = createLine(vertices([14 23]));
    lines(51) = createLine(vertices([15 24]));
    lines(52) = createLine(vertices([16 25]));
    lines(53) = createLine(vertices([17 26]));
    lines(54) = createLine(vertices([18 27]));
   
    Cubes = [];
    
    subCubes(1) = Cuboid(vertices([1 2 5 4 10 11 14 13]),lines([1 20 3 19 7 26 9 25 37 38 41 40]),Cubes);
    subCubes(2) = Cuboid(vertices([2 3 6 5 11 12 15 14]),lines([2 21 4 20 8 27 10 26 38 39 42 41]),Cubes);
    subCubes(3) = Cuboid(vertices([5 6 9 8 14 15 18 17]),lines([4 24 6 23 10 30 12 29 41 42 45 44]),Cubes);
    subCubes(4) = Cuboid(vertices([4 5 8 7 13 14 17 16]),lines([3 23 5 22 9 29 11 28 40 41 44 43]),Cubes);
    subCubes(5) = Cuboid(vertices([10 11 14 13 19 20 23 22]),lines([7 26 9 25 13 32 15 31 46 47 50 49]),Cubes);
    subCubes(6) = Cuboid(vertices([11 12 15 14 20 21 24 23]),lines([8 27 10 26 14 33 16 32 47 48 51 50]),Cubes);
    subCubes(7) = Cuboid(vertices([14 15 18 17 23 24 27 26]),lines([10 30 12 29 16 36 18 35 50 51 54 53]),Cubes);
    subCubes(8) = Cuboid(vertices([13 14 17 16 22 23 26 25]),lines([9 29 11 28 15 35 17 34 49 50 53 52]),Cubes);
    
    depthCounter = depthCounter + 1;
    
    for i = 1:length(subCubes)
        subDomains = obj.partitionRecursively(subCubes(i),support,subDomains, depthCounter);
    end
    
else
    subDomains = [subDomains indexGeometry];
end

end

function line = createLine(vertices)
    line = Line(vertices(1), vertices(2));
end