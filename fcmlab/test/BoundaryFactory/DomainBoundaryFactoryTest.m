classdef DomainBoundaryFactoryTest  < TestCase
    
    properties
        
        DomainBoundaryFactory
        Geometry
        BoundingBox
        RecoveredBoundary
        PartitionDepth
        
    end
    
    methods
        
        %% constructor
        function obj = DomainBoundaryFactoryTest(name)
            obj = obj@TestCase(name);
        end
        
        function setUp(obj)
            
            vertex1 = Vertex([0.0 0.0 0.0]);
            vertex2 = Vertex([1.0 0.0 0.0]);
            vertex3 = Vertex([1.0 1.0 0.0]);
            vertex4 = Vertex([0.0 1.0 0.0]);
            
            line1 = Line(vertex1,vertex2);
            line2 = Line(vertex2,vertex3);
            line3 = Line(vertex3,vertex4);
            line4 = Line(vertex4,vertex1);
            
            obj.BoundingBox = Quad([vertex1,vertex2,vertex3,vertex4],[line1,line2,line3,line4]);
            
%             domainFunctionHandle = @(x,y,z) ...
%                 2 - ((x+y)<0.3125);
            
domainFunctionHandle = @(x,y,z) ...
                               2 - (((x-.5)^2+(y-.5)^2)<0.2);
            obj.Geometry = FunctionHandleDomain(domainFunctionHandle);
            
            obj.PartitionDepth=5;
            
            obj.DomainBoundaryFactory=DomainBoundaryFactory(obj.Geometry,obj.BoundingBox,obj.PartitionDepth);
            
        end
        
        function tearDown(obj)
        end
        
        function testBoundaryRecovery(obj)            
            
            obj.RecoveredBoundary = obj.DomainBoundaryFactory.getBoundaryWithVisual();
         
            assertEqual(length(obj.RecoveredBoundary),116);
            
       
            
        end
    end
end