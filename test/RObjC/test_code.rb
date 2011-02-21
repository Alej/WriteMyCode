require 'helper'

module RObjC 
  class CodeTokenizer
    include Tokenize
    TOKENIZE_PATTERN = /CODE.*CODE/
  end
end

class TestCode < Test::Unit::TestCase
  context 'wrap in blocks' do
    setup do
      text =  
%Q{[object do];
[otherObject somethingElse];
[lastObject lastThing];}
      @code = RObjC::Code.new(text)
    end
    
    should 'wrap around if statement' do
      block = 'if (YES)'
      end_code = 
%Q{if (YES) {
\t[object do];
\t[otherObject somethingElse];
\t[lastObject lastThing];
}}
      assert_equal(end_code,@code.wrapped_in_block(block))
    end
  end
  
  context 'untokenize' do
    setup do
      @code = RObjC::Code.new "CODE be my code CODE not a token"
      result = RObjC::CodeTokenizer.tokenize_code(@code)
      @tokenized_code = result[:tokenized_code]
      @tokens = result[:tokens]
    end
    
    should 'not touch unrecognized code' do
      assert @tokenized_code['not a token'], 'did not touch "not a token"'
      assert @tokenized_code[@tokens.first.o_to_s], 'contains the token'
    end
    
    should 'return tokenized_code of class code' do
      assert_equal(RObjC::Code,@tokenized_code.class)
    end
    
    should 'respond to untokenize' do
      assert_respond_to(@tokenized_code,:untokenize)
    end
    
    should 'respond to untokenize!' do
      assert_respond_to(@tokenized_code,:untokenize!)
    end
    
    should 'return original code' do
      untokenized_code = @tokenized_code.untokenize(@tokens)
      assert_equal(@code,untokenized_code)
      assert_equal(RObjC::Code,untokenized_code.class)
    end
    
  end
    
end

