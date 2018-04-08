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
 
%Function to get the Legendre Polynomial Derivative

function value = getLegendrePolynomialDerivative(x,p)

x2 = x*x;

switch p

    case 0
        value = 0.0;

    case 1
        value = 1.0;
            
    case 2 
        value = 3.0*x;
                
    case 3 
        value =  15.0/2.0*x2-3.0/2.0;
        
    case 4 
        value =  (-15.0/2.0+35.0/2.0*x2 )*x;
        
    case 5 
        value =  15.0/8.0+(-105.0/4.0+315.0/8.0*x2 )*x2;
        
    case 6 
        value = (105.0/8.0+(-315.0/4.0+693.0/8.0*x2 )*x2 )*x;
        
    case 7 
        value =  -35.0/16.0+(945.0/16.0+(-3465.0/16.0+3003.0/16.0*x2 )*x2 )*x2;
        
    case 8 
        value = (-315.0/16.0+(3465.0/16.0+(-9009.0/16.0+6435.0/16.0*x2 )*x2 )*x2 )*x;
        
    case 9 
        value = 315.0/128.0+(-3465.0/32.0+(45045.0/64.0+(-45045.0/32.0+109395.0/...
        128.0*x2 )*x2 )*x2 )*x2;
        
    case 10 
        value = (3465.0/128.0+(-15015.0/32.0+(135135.0/64.0+(-109395.0/32.0+230945.0...
        /128.0*x2 )*x2 )*x2 )*x2 )*x;
        
    case 11 
        value =  -693.0/256.0+(45045.0/256.0+(-225225.0/128.0+(765765.0/128.0+(...
        -2078505.0/256.0+969969.0/256.0*x2 )*x2 )*x2 )*x2 )*x2;
        
    case 12 
        value = (-9009.0/256.0+(225225.0/256.0+(-765765.0/128.0+(2078505.0/128.0+(...
        -4849845.0/256.0+2028117.0/256.0*x2 )*x2 )*x2 )*x2 )*x2 )*x;
        
    case 13 
        value = 3003.0/1024.0+(-135135.0/512.0+(3828825.0/1024.0+(-4849845.0/256.0+(...
        43648605.0/1024.0+(-22309287.0/512.0+16900975.0/1024.0*x2 )*x2 )*x2 )*x2...
        )*x2 )*x2;
        
    case 14 
        value = (45045.0/1024.0+(-765765.0/512.0+(14549535.0/1024.0+(-14549535.0/...
        256.0+(111546435.0/1024.0+(-50702925.0/512.0+35102025.0/1024.0*x2 )*x2...
        )*x2 )* x2 )*x2 )*x2 )*x;
        
    case 15 
        value = -6435.0/2048.0+(765765.0/2048.0+(-14549535.0/2048.0+(101846745.0/...
        2048.0+(-334639305.0/2048.0+(557732175.0/2048.0+(-456326325.0/2048.0+...
        145422675.0/2048.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2;
        
    case 16 
        value = (-109395.0/2048.0+(4849845.0/2048.0+(-61108047.0/2048.0+(334639305.0...
        /2048.0+(-929553625.0/2048.0+(1368978975.0/2048.0+(-1017958725.0/2048.0+...
        300540195.0/2048.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x;
        
    case 17 
        value =  109395.0/32768.0+(-2078505.0/4096.0+(101846745.0/8192.0+(...
        -468495027.0/4096.0+(8365982625.0/16384.0+(-5019589575.0/4096.0+(13233463425.0/...
        8192.0+(-4508102925.0/4096.0+9917826435.0/32768.0*x2 )*x2 )*x2 )*x2 )*x2...
        )*x2 ) *x2 )*x2;
        
    case 18 
        value = (2078505.0/32768.0+(-14549535.0/4096.0+(468495027.0/8192.0+(...
        -1673196525.0/4096.0+(25097947875.0/16384.0+(-13233463425.0/4096.0+(...
        31556720475.0/8192.0+(-9917826435.0/4096.0+20419054425.0/32768.0*x2 )*x2...
        )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x;
  
    case 19 
        value = -230945.0/65536.0+(43648605.0/65536.0+(-334639305.0/16384.0+(...
        3904125225.0/16384.0+(-45176306175.0/32768.0+(145568097675.0/32768.0+(...
        -136745788725.0/16384.0+(148767396525.0/16384.0+(-347123925225.0/65536.0+...
        83945001525.0/65536.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2;
        
    case 20 
        value =  (-4849845.0/65536.0+(334639305.0/65536.0+(-1673196525.0/16384.0+(...
        15058768725.0/16384.0+(-145568097675.0/32768.0+(410237366175.0/32768.0+(...
        -347123925225.0/16384.0+(347123925225.0/16384.0+(-755505013725.0/65536.0+...
        172308161025.0/65536.0*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x2 )*x;
    
end
                                                                
end

