classdef revisionTest < TestCase
    methods
        function this = revisionTest(name)
            this = this@TestCase(name);
        end
        
        function testRevision(~)
            [rev,differences] = edu.stanford.covert.util.revision();
            assertTrue(isa(differences, 'char'));
            assertTrue(isa(rev, 'double'));
            assertEqual(fix(rev), rev);
        end
    end
end
