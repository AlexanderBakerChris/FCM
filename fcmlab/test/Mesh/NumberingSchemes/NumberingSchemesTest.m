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
 
%% testing of class MeshFactory1DUniform

classdef NumberingSchemesTest < TestCase
    
    properties
        PolynomialDegree
        NumberGP
        MeshOrigin
        Lx
        Ly
        Lz
        NumberOfXDivisions
        NumberOfYDivisions
        NumberOfZDivisions
        Mat1D
        Mat2D
        Mat3D
    end
    
    methods
        %% constructor
        function obj = NumberingSchemesTest (name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            obj.PolynomialDegree = 3;
            obj.NumberGP = obj.PolynomialDegree + 1;
            obj.MeshOrigin = [0 0 0];
            obj.Lx = 10;
            obj.Ly = 12;
            obj.Lz = 14;
            
            obj.NumberOfXDivisions = 3;
            obj.NumberOfYDivisions = 4;
            obj.NumberOfZDivisions = 5;
            
            obj.Mat1D = Hooke1D(1,1,2,1);
            obj.Mat2D = HookePlaneStress(1,0.3,2,1);
            obj.Mat3D = Hooke3D(1,0.3,2,1);
            
        end
        
        function tearDown(obj)
        end
        
        %% testTopologicalSortingFor1D
        function testTopologicalSortingFor1D(obj)
            NumberingScheme = TopologicalSorting();
            DofDimension = 1;
            ElementFactory1D = ElementFactoryElasticBar(obj.Mat1D,obj.NumberGP);
            MeshFactory1D = MeshFactory1DUniform(obj.NumberOfXDivisions,obj.PolynomialDegree,...
                NumberingScheme,DofDimension,obj.MeshOrigin,obj.Lx,ElementFactory1D);

            Mesh1D = Mesh(MeshFactory1D);
            
            Elements = Mesh1D.getElements;
            
            assertEqual(Elements(1).getLocationMatrix,[1 2 5 6]);
            assertEqual(Elements(2).getLocationMatrix,[2 3 7 8]);
            assertEqual(Elements(3).getLocationMatrix,[3 4 9 10]);
        end
        
        %% testPolynomialDegreeSortingFor1D
        function testPolynomialDegreeSortingFor1D(obj)
            NumberingScheme = PolynomialDegreeSorting();
            DofDimension = 1;
            ElementFactory1D = ElementFactoryElasticBar(obj.Mat1D,obj.NumberGP);
            MeshFactory1D = MeshFactory1DUniform(obj.NumberOfXDivisions,obj.PolynomialDegree,...
                NumberingScheme,DofDimension,obj.MeshOrigin,obj.Lx,ElementFactory1D);
            
            Mesh1D = Mesh(MeshFactory1D);
            
            Elements = Mesh1D.getElements;
            
            assertEqual(Elements(1).getLocationMatrix,[1 2 5 8]);
            assertEqual(Elements(2).getLocationMatrix,[2 3 6 9]);
            assertEqual(Elements(3).getLocationMatrix,[3 4 7 10]);

        end
        
        %% testTopologicalSortingFor2D
        function testTopologicalSortingFor2D(obj)
          
            NumberingScheme = TopologicalSorting();
            DofDimension = 2;
            ElementFactory2D = ElementFactoryElasticQuad(obj.Mat2D,obj.NumberGP);
            MeshFactory2D = MeshFactory2DUniform(obj.NumberOfXDivisions,obj.NumberOfYDivisions,obj.PolynomialDegree,...
                NumberingScheme,DofDimension,obj.MeshOrigin,obj.Lx,obj.Ly,ElementFactory2D);
            
            Mesh2D = Mesh(MeshFactory2D);
            
            Elements = Mesh2D.getElements;
            
            assertEqual(Elements(1).getLocationMatrix,[1,2,6,5,21,22,59,60,27,28,51,52,83,84,85,86,131,132,136,135,151,152,189,190,157,158,181,182,213,214,215,216;]);
            assertEqual(Elements(2).getLocationMatrix,[2,3,7,6,23,24,67,68,29,30,59,60,87,88,89,90,132,133,137,136,153,154,197,198,159,160,189,190,217,218,219,220;]);
            assertEqual(Elements(11).getLocationMatrix,[14,15,19,18,41,42,73,74,47,48,65,66,123,124,125,126,144,145,149,148,171,172,203,204,177,178,195,196,253,254,255,256;]);
            assertEqual(Elements(12).getLocationMatrix,[15,16,20,19,43,44,81,82,49,50,73,74,127,128,129,130,145,146,150,149,173,174,211,212,179,180,203,204,257,258,259,260;]);
            
        end
        
        %% testPolynomialDegreeSortingFor2D
        function testPolynomialDegreeSortingFor2D(obj)
            
            NumberingScheme = PolynomialDegreeSorting();
            DofDimension = 2;
            ElementFactory2D = ElementFactoryElasticQuad(obj.Mat2D,obj.NumberGP);
            MeshFactory2D = MeshFactory2DUniform(obj.NumberOfXDivisions,obj.NumberOfYDivisions,obj.PolynomialDegree,...
                NumberingScheme,DofDimension,obj.MeshOrigin,obj.Lx,obj.Ly,ElementFactory2D);
            
            Mesh2D = Mesh(MeshFactory2D);
            
            Elements = Mesh2D.getElements;
            
            assertEqual(Elements(1).getLocationMatrix,[1,2,6,5,21,64,40,83,24,67,36,79,52,95,96,97,131,132,136,135,151,194,170,213,154,197,166,209,182,225,226,227;]);
            assertEqual(Elements(2).getLocationMatrix,[2,3,7,6,22,65,44,87,25,68,40,83,53,98,99,100,132,133,137,136,152,195,174,217,155,198,170,213,183,228,229,230;]);
            assertEqual(Elements(11).getLocationMatrix,[14,15,19,18,31,74,47,90,34,77,43,86,62,125,126,127,144,145,149,148,161,204,177,220,164,207,173,216,192,255,256,257;]);
            assertEqual(Elements(12).getLocationMatrix,[15,16,20,19,32,75,51,94,35,78,47,90,63,128,129,130,145,146,150,149,162,205,181,224,165,208,177,220,193,258,259,260;]);
            
        end
        %% testTopologicalSortingFor3D
        function testTopologicalSortingFor3D(obj)
            NumberingScheme = TopologicalSorting();
            DofDimension = 3;
            ElementFactory3D = ElementFactoryElasticHexa(obj.Mat3D,obj.NumberGP);
            MeshFactory3D = MeshFactory3DUniform(obj.NumberOfXDivisions,obj.NumberOfYDivisions,obj.NumberOfZDivisions,obj.PolynomialDegree,...
                NumberingScheme,DofDimension,obj.MeshOrigin,obj.Lx,obj.Ly,obj.Lz,ElementFactory3D);
            
            Mesh3D = Mesh(MeshFactory3D);
            
            Elements = Mesh3D.getElements;
            
            assertEqual(Elements(1).getLocationMatrix,[1,2,6,5,21,22,26,25,121,122,349,350,127,128,301,302,493,494,503,504,543,544,533,534,151,152,357,358,157,158,309,310,693,694,695,696,1301,1302,1303,1304,1061,1062,1063,1064,1361,1362,1363,1364,981,982,983,984,741,742,743,744,1601,1602,1603,1604,1605,1606,1607,1608,2081,2082,2086,2085,2101,2102,2106,2105,2201,2202,2429,2430,2207,2208,2381,2382,2573,2574,2583,2584,2623,2624,2613,2614,2231,2232,2437,2438,2237,2238,2389,2390,2773,2774,2775,2776,3381,3382,3383,3384,3141,3142,3143,3144,3441,3442,3443,3444,3061,3062,3063,3064,2821,2822,2823,2824,3681,3682,3683,3684,3685,3686,3687,3688,4161,4162,4166,4165,4181,4182,4186,4185,4281,4282,4509,4510,4287,4288,4461,4462,4653,4654,4663,4664,4703,4704,4693,4694,4311,4312,4517,4518,4317,4318,4469,4470,4853,4854,4855,4856,5461,5462,5463,5464,5221,5222,5223,5224,5521,5522,5523,5524,5141,5142,5143,5144,4901,4902,4903,4904,5761,5762,5763,5764,5765,5766,5767,5768;]);
            assertEqual(Elements(2).getLocationMatrix,[2,3,7,6,22,23,27,26,123,124,397,398,129,130,349,350,503,504,513,514,553,554,543,544,153,154,405,406,159,160,357,358,697,698,699,700,1321,1322,1323,1324,1141,1142,1143,1144,1381,1382,1383,1384,1061,1062,1063,1064,745,746,747,748,1609,1610,1611,1612,1613,1614,1615,1616,2082,2083,2087,2086,2102,2103,2107,2106,2203,2204,2477,2478,2209,2210,2429,2430,2583,2584,2593,2594,2633,2634,2623,2624,2233,2234,2485,2486,2239,2240,2437,2438,2777,2778,2779,2780,3401,3402,3403,3404,3221,3222,3223,3224,3461,3462,3463,3464,3141,3142,3143,3144,2825,2826,2827,2828,3689,3690,3691,3692,3693,3694,3695,3696,4162,4163,4167,4166,4182,4183,4187,4186,4283,4284,4557,4558,4289,4290,4509,4510,4663,4664,4673,4674,4713,4714,4703,4704,4313,4314,4565,4566,4319,4320,4517,4518,4857,4858,4859,4860,5481,5482,5483,5484,5301,5302,5303,5304,5541,5542,5543,5544,5221,5222,5223,5224,4905,4906,4907,4908,5769,5770,5771,5772,5773,5774,5775,5776;]);
            assertEqual(Elements(59).getLocationMatrix,[94,95,99,98,114,115,119,118,261,262,435,436,267,268,387,388,631,632,641,642,681,682,671,672,291,292,443,444,297,298,395,396,925,926,927,928,1517,1518,1519,1520,1217,1218,1219,1220,1577,1578,1579,1580,1137,1138,1139,1140,973,974,975,976,2065,2066,2067,2068,2069,2070,2071,2072,2174,2175,2179,2178,2194,2195,2199,2198,2341,2342,2515,2516,2347,2348,2467,2468,2711,2712,2721,2722,2761,2762,2751,2752,2371,2372,2523,2524,2377,2378,2475,2476,3005,3006,3007,3008,3597,3598,3599,3600,3297,3298,3299,3300,3657,3658,3659,3660,3217,3218,3219,3220,3053,3054,3055,3056,4145,4146,4147,4148,4149,4150,4151,4152,4254,4255,4259,4258,4274,4275,4279,4278,4421,4422,4595,4596,4427,4428,4547,4548,4791,4792,4801,4802,4841,4842,4831,4832,4451,4452,4603,4604,4457,4458,4555,4556,5085,5086,5087,5088,5677,5678,5679,5680,5377,5378,5379,5380,5737,5738,5739,5740,5297,5298,5299,5300,5133,5134,5135,5136,6225,6226,6227,6228,6229,6230,6231,6232;]);
            assertEqual(Elements(60).getLocationMatrix,[95,96,100,99,115,116,120,119,263,264,483,484,269,270,435,436,641,642,651,652,691,692,681,682,293,294,491,492,299,300,443,444,929,930,931,932,1537,1538,1539,1540,1297,1298,1299,1300,1597,1598,1599,1600,1217,1218,1219,1220,977,978,979,980,2073,2074,2075,2076,2077,2078,2079,2080,2175,2176,2180,2179,2195,2196,2200,2199,2343,2344,2563,2564,2349,2350,2515,2516,2721,2722,2731,2732,2771,2772,2761,2762,2373,2374,2571,2572,2379,2380,2523,2524,3009,3010,3011,3012,3617,3618,3619,3620,3377,3378,3379,3380,3677,3678,3679,3680,3297,3298,3299,3300,3057,3058,3059,3060,4153,4154,4155,4156,4157,4158,4159,4160,4255,4256,4260,4259,4275,4276,4280,4279,4423,4424,4643,4644,4429,4430,4595,4596,4801,4802,4811,4812,4851,4852,4841,4842,4453,4454,4651,4652,4459,4460,4603,4604,5089,5090,5091,5092,5697,5698,5699,5700,5457,5458,5459,5460,5757,5758,5759,5760,5377,5378,5379,5380,5137,5138,5139,5140,6233,6234,6235,6236,6237,6238,6239,6240;]);
        end
        %% testPolynomialDegreeSortingFor3D
        function testPolynomialDegreeSortingFor3D(obj)
            
            NumberingScheme = PolynomialDegreeSorting();
            DofDimension = 3;
            ElementFactory3D = ElementFactoryElasticHexa(obj.Mat3D,obj.NumberGP);
            MeshFactory3D = MeshFactory3DUniform(obj.NumberOfXDivisions,obj.NumberOfYDivisions,obj.NumberOfZDivisions,obj.PolynomialDegree,...
                NumberingScheme,DofDimension,obj.MeshOrigin,obj.Lx,obj.Ly,obj.Lz,ElementFactory3D);
            
            Mesh3D = Mesh(MeshFactory3D);
            
            Elements = Mesh3D.getElements;
            
            assertEqual(Elements(1).getLocationMatrix,[1,2,6,5,21,22,26,25,121,694,235,808,124,697,211,784,307,880,312,885,332,905,327,900,136,709,239,812,139,712,215,788,407,980,981,982,559,1436,1437,1438,499,1256,1257,1258,574,1481,1482,1483,479,1196,1197,1198,419,1016,1017,1018,634,1661,1662,1663,1664,1665,1666,1667,2081,2082,2086,2085,2101,2102,2106,2105,2201,2774,2315,2888,2204,2777,2291,2864,2387,2960,2392,2965,2412,2985,2407,2980,2216,2789,2319,2892,2219,2792,2295,2868,2487,3060,3061,3062,2639,3516,3517,3518,2579,3336,3337,3338,2654,3561,3562,3563,2559,3276,3277,3278,2499,3096,3097,3098,2714,3741,3742,3743,3744,3745,3746,3747,4161,4162,4166,4165,4181,4182,4186,4185,4281,4854,4395,4968,4284,4857,4371,4944,4467,5040,4472,5045,4492,5065,4487,5060,4296,4869,4399,4972,4299,4872,4375,4948,4567,5140,5141,5142,4719,5596,5597,5598,4659,5416,5417,5418,4734,5641,5642,5643,4639,5356,5357,5358,4579,5176,5177,5178,4794,5821,5822,5823,5824,5825,5826,5827;]);
            assertEqual(Elements(2).getLocationMatrix,[2,3,7,6,22,23,27,26,122,695,259,832,125,698,235,808,312,885,317,890,337,910,332,905,137,710,263,836,140,713,239,812,408,983,984,985,564,1451,1452,1453,519,1316,1317,1318,579,1496,1497,1498,499,1256,1257,1258,420,1019,1020,1021,635,1668,1669,1670,1671,1672,1673,1674,2082,2083,2087,2086,2102,2103,2107,2106,2202,2775,2339,2912,2205,2778,2315,2888,2392,2965,2397,2970,2417,2990,2412,2985,2217,2790,2343,2916,2220,2793,2319,2892,2488,3063,3064,3065,2644,3531,3532,3533,2599,3396,3397,3398,2659,3576,3577,3578,2579,3336,3337,3338,2500,3099,3100,3101,2715,3748,3749,3750,3751,3752,3753,3754,4162,4163,4167,4166,4182,4183,4187,4186,4282,4855,4419,4992,4285,4858,4395,4968,4472,5045,4477,5050,4497,5070,4492,5065,4297,4870,4423,4996,4300,4873,4399,4972,4568,5143,5144,5145,4724,5611,5612,5613,4679,5476,5477,5478,4739,5656,5657,5658,4659,5416,5417,5418,4580,5179,5180,5181,4795,5828,5829,5830,5831,5832,5833,5834;]);
            assertEqual(Elements(59).getLocationMatrix,[94,95,99,98,114,115,119,118,191,764,278,851,194,767,254,827,376,949,381,954,401,974,396,969,206,779,282,855,209,782,258,831,465,1154,1155,1156,613,1598,1599,1600,538,1373,1374,1375,628,1643,1644,1645,518,1313,1314,1315,477,1190,1191,1192,692,2067,2068,2069,2070,2071,2072,2073,2174,2175,2179,2178,2194,2195,2199,2198,2271,2844,2358,2931,2274,2847,2334,2907,2456,3029,2461,3034,2481,3054,2476,3049,2286,2859,2362,2935,2289,2862,2338,2911,2545,3234,3235,3236,2693,3678,3679,3680,2618,3453,3454,3455,2708,3723,3724,3725,2598,3393,3394,3395,2557,3270,3271,3272,2772,4147,4148,4149,4150,4151,4152,4153,4254,4255,4259,4258,4274,4275,4279,4278,4351,4924,4438,5011,4354,4927,4414,4987,4536,5109,4541,5114,4561,5134,4556,5129,4366,4939,4442,5015,4369,4942,4418,4991,4625,5314,5315,5316,4773,5758,5759,5760,4698,5533,5534,5535,4788,5803,5804,5805,4678,5473,5474,5475,4637,5350,5351,5352,4852,6227,6228,6229,6230,6231,6232,6233;]);
            assertEqual(Elements(60).getLocationMatrix,[95,96,100,99,115,116,120,119,192,765,302,875,195,768,278,851,381,954,386,959,406,979,401,974,207,780,306,879,210,783,282,855,466,1157,1158,1159,618,1613,1614,1615,558,1433,1434,1435,633,1658,1659,1660,538,1373,1374,1375,478,1193,1194,1195,693,2074,2075,2076,2077,2078,2079,2080,2175,2176,2180,2179,2195,2196,2200,2199,2272,2845,2382,2955,2275,2848,2358,2931,2461,3034,2466,3039,2486,3059,2481,3054,2287,2860,2386,2959,2290,2863,2362,2935,2546,3237,3238,3239,2698,3693,3694,3695,2638,3513,3514,3515,2713,3738,3739,3740,2618,3453,3454,3455,2558,3273,3274,3275,2773,4154,4155,4156,4157,4158,4159,4160,4255,4256,4260,4259,4275,4276,4280,4279,4352,4925,4462,5035,4355,4928,4438,5011,4541,5114,4546,5119,4566,5139,4561,5134,4367,4940,4466,5039,4370,4943,4442,5015,4626,5317,5318,5319,4778,5773,5774,5775,4718,5593,5594,5595,4793,5818,5819,5820,4698,5533,5534,5535,4638,5353,5354,5355,4853,6234,6235,6236,6237,6238,6239,6240;]);
        end
    end
    
end

