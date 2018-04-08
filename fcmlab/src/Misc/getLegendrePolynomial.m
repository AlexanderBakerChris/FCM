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
 
% Function to get the Legendre Polynomials

function value = getLegendrePolynomial(x,p)

x2 = x*x;

switch p

    case 0
        value = 1.0;

    case 1
        value = x;
            
    case 2 
        value = 3.0/2.0*x2-1.0/2.0;
                
    case 3 
        value = (-3.0/2.0+5.0/2.0*x2 )*x;
        
    case 4 
        value = 3.0/8.0+(-15.0/4.0+35.0/8.0*x2 )*x2;
        
    case 5 
        value = (15.0/8.0+(-35.0/4.0+63.0/8.0*x2 )*x2 )*x;
        
    case 6 
        value = -5.0/16.0+(105.0/16.0+(-315.0/16.0+231.0/16.0*x2 )*x2 )*x2;
        
    case 7 
        value = (-35.0/16.0+(315.0/16.0+(-693.0/16.0+429.0/16.0*x2 )*x2 )*x2 )*x;
        
    case 8 
        value = 35.0/128.0+(-315.0/32.0+(3465.0/64.0+(-3003.0/32.0+6435.0/128.0*x2 )*x2 )*x2 )*x2;
        
    case 9 
        value = (315.0/128.0+(-1155.0/32.0+(9009.0/64.0+(-6435.0/32.0+12155.0/128.0* ...
        x2 )*x2 )*x2 )*x2 )*x;
        
    case 10 
        value = -63.0/256.0+(3465.0/256.0+(-15015.0/128.0+(45045.0/128.0+(-109395.0/...
        256.0+46189.0/256.0*x2 )*x2 )*x2 )*x2 )*x2;
        
    case 11 
        value = (-693.0/256.0+(15015.0/256.0+(-45045.0/128.0+(109395.0/128.0+(...
        -230945.0/256.0+88179.0/256.0*x2 )*x2 )*x2 )*x2 )*x2 )*x;
        
    case 12 
        value = 231.0/1024.0+(-9009.0/512.0+(225225.0/1024.0+(-255255.0/256.0+(...
        2078505.0/1024.0+(-969969.0/512.0+676039.0/1024.0*x2 )*x2 )*x2 )*x2 )*x2...
        )*x2;
        
    case 13 
        value = (3003.0/1024.0+(-45045.0/512.0+(765765.0/1024.0+(-692835.0/256.0+(...
        4849845.0/1024.0+(-2028117.0/512.0+1300075.0/1024.0*x2 )*x2 )*x2 )*x2 )*x2 )*...
        x2 )*x;
        
    case 14 
        value = -429.0/2048.0+(45045.0/2048.0+(-765765.0/2048.0+(4849845.0/2048.0+(...
        -14549535.0/2048.0+(22309287.0/2048.0+(-16900975.0/2048.0+5014575.0/2048.0*x2)...
        *x2 )*x2 )*x2 )*x2 )*x2 )*x2;
        
    case 15 
        value = (-6435.0/2048.0+(255255.0/2048.0+(-2909907.0/2048.0+(14549535.0/...
        2048.0+(-37182145.0/2048.0+(50702925.0/2048.0+(-35102025.0/2048.0+9694845.0/...
        2048.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x;
        
    case 16 
        value = 6435.0/32768.0+(-109395.0/4096.0+(4849845.0/8192.0+(-20369349.0/...
        4096.0+(334639305.0/16384.0+(-185910725.0/4096.0+(456326325.0/8192.0+(...
        -145422675.0/4096.0+300540195.0/32768.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2...
        )*x2;
        
    case 17 
        value = (109395.0/32768.0+(-692835.0/4096.0+(20369349.0/8192.0+(-66927861.0/...
        4096.0+(929553625.0/16384.0+(-456326325.0/4096.0+(1017958725.0/8192.0+(...
        -300540195.0/4096.0+583401555.0/32768.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )...
        *x;
        
    case 18 
        value = -12155.0/65536.0+(2078505.0/65536.0+(-14549535.0/16384.0+(...
        156165009.0/16384.0+(-1673196525.0/32768.0+(5019589575.0/32768.0+(-4411154475.0...
        /16384.0+(4508102925.0/16384.0+(-9917826435.0/65536.0+2268783825.0/65536.0*x2...
        )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2;
  
    case 19 
        value = (-230945.0/65536.0+(14549535.0/65536.0+(-66927861.0/16384.0+(...
        557732175.0/16384.0+(-5019589575.0/32768.0+(13233463425.0/32768.0+(...
        -10518906825.0/16384.0+(9917826435.0/16384.0+(-20419054425.0/65536.0+...
        4418157975.0/65536.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x;
        
    case 20 
        value = 46189.0/262144.0+(-4849845.0/131072.0+(334639305.0/262144.0+(...
        -557732175.0/32768.0+(15058768725.0/131072.0+(-29113619535.0/65536.0+(...
        136745788725.0/131072.0+(-49589132175.0/32768.0+(347123925225.0/262144.0+(...
        -83945001525.0/131072.0+34461632205.0/262144.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*...
        x2 )*x2 )*x2 )*x2;
    
end
                                                                
end

