require 'helper'

module RObjC
  class Structure
    def o_to_s
      "<TestStructureToken>"
    end
  end
end

class TestStructure < Test::Unit::TestCase

  context 'tokenize/untokenize' do
    
    context '1 sample structure' do
      setup do
        @code_string = 
%Q{@structure aStructure : something 
change some lines
dome more stuff
@end}
        @code = @code_string.to_code
        @tokenized_code, @tokens = *RObjC::Structure.tokenize_code(@code).values
      end
      
      should 'contain 1 structures' do
        assert_equal(1,@tokens.count)
        assert_equal("<TestStructureToken>",@tokenized_code)
      end
      
      should 'untokenize to 1 structure' do
        @tokenized_code.untokenize(@tokens)
      end
    end
    
    
    context '2 sample structures' do
      setup do 
        @code_string = 
%Q{@structure aStructure : something 
change some lines
dome more stuff
@end


@structure aStructure2 : something 
change some lines
dome more stuff
@end}
      @code = @code_string.to_code
    end
    
    
    should 'contain 2 structures' do
      tokenized_code, tokens = *RObjC::Structure.tokenize_code(@code).values
      assert_equal(2,tokens.count)
      assert_equal("<TestStructureToken>\n\n\n<TestStructureToken>",tokenized_code)
    end
  end
    
  end
    
end