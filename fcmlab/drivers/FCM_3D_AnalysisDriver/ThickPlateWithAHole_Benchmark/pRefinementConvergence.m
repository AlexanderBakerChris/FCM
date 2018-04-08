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
 
function [numberOfDofs, strainEnergy] = pRefinementConvergence(...
    ansatzOrderStart, ansatzOrderEnd,...
    numberOfXDivisions,numberOfYDivisions, numberOfZDivisions, ...
    meshOrigin,Lx,Ly,Lz,...
    mat3DFCM, integrationRefinementDepths,plate,...
    strongBoundaryConditions, ...
    outFileName)

    numberOfDofs = zeros(1,ansatzOrderEnd - ansatzOrderStart + 1);
    strainEnergy = zeros(ansatzOrderEnd - ansatzOrderStart + 1,length(integrationRefinementDepths));
    
    for p = ansatzOrderStart:ansatzOrderEnd
        
        
        for j = 1:length(integrationRefinementDepths)
            clear myAnalysis;
            
            Logger.Log(['Ansatz Order = ',num2str(p)],'release');    
            Logger.Log([ 'Octree depth: ' num2str(integrationRefinementDepths(j)) ],'release');
            
            integrationOrder = p + 1;
            
            % Creation of the FEM system
            
            dofDimension = 3;
            
            myElementFactory = ElementFactoryElasticHexaFCM(mat3DFCM,plate,...
                integrationOrder,integrationRefinementDepths(j));
            
            myMeshFactory = MeshFactory3DUniform(numberOfXDivisions,...
                numberOfYDivisions,numberOfZDivisions,p,PolynomialDegreeSorting(),...
                dofDimension,meshOrigin,Lx,Ly,Lz,myElementFactory);
            
            myAnalysis = QuasiStaticAnalysis(myMeshFactory);
            
            
            % Traction
            myLoadCase = LoadCase();
            
            tractionStartPoint = meshOrigin + [0.0 Lx 0.0];
            tractionEndPoint = meshOrigin + [Lx Ly Lz];
            tractionValue = @(x,y,z) [0; 100; 0;];
            
            traction = WeakFaceNeumannBoundaryCondition(tractionStartPoint, tractionEndPoint, GaussLegendre(integrationOrder), tractionValue );
            
            myLoadCase.addNeumannBoundaryCondition( traction );
            
            myAnalysis.addLoadCases(myLoadCase);
            
            
            for k = 1:length(strongBoundaryConditions)
                myAnalysis.addDirichletBoundaryCondition(strongBoundaryConditions{k});
            end
            
            [~, strainEnergy(p - ansatzOrderStart + 1, j)] = myAnalysis.solve();
            
%             % Post Processing
%             postProcessor = IntegrationPostProcessor( );
%             loadCaseToVisualize = 1;
%             indexOfPhysicalDomain = 2;
%             
%             strainEnergyProcessor = StrainEnergy( ...
%                 loadCaseToVisualize, ...
%                 indexOfPhysicalDomain );
%             
            FeMesh = myAnalysis.getMesh();
%             
%             postProcessor.registerPointProcessor( strainEnergyProcessor );
%             
%             strainEnergy(p - ansatzOrderStart + 1, j) = postProcessor.integrate( FeMesh );
            numberOfDofs(p - ansatzOrderStart + 1) = FeMesh.getNumberOfDofs();
            
        end
        
        % Append Result to outFile
        outFileId = fopen(outFileName,'a');
        fprintf(outFileId,'% 7i \t',numberOfDofs(p - ansatzOrderStart + 1));
        fprintf(outFileId,'%10.9E ',strainEnergy(p - ansatzOrderStart + 1,:));
        fprintf(outFileId,'\n');
        fclose(outFileId);
        

    end

end