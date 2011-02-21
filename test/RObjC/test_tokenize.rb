require 'helper'

class NoPattern 
  include RObjC::Tokenize
end

class TokenizeTest
  include RObjC::Tokenize
  TOKENIZE_PATTERN = /.+: .+/
  
  def o_to_s
    "#<TESTING_TOKEN>"
  end
end

class TokenizeTestClass < TokenizeTest
  TOKENIZE_PATTERN = /class: .+/
end

class TokenizeTestObject < TokenizeTest
  TOKENIZE_PATTERN = /object: .+/
end

class TestTokenize < Test::Unit::TestCase
  
  context 'Tokenize' do
    
    should 'respond to tokenize_code!' do
      assert_respond_to(TokenizeTest,:tokenize_code!)
    end
    
    should 'respond to tokenize_code' do
      assert_respond_to(TokenizeTest,:tokenize_code)
    end
    
    should 'modify string when using tokenize_code!' do
      original_code = RObjC::Code.new('some: code')
      tokenized_code = original_code.dup
      TokenizeTest::tokenize_code!(tokenized_code)
      assert_not_equal(tokenized_code,original_code)
    end
    
    should 'not modify string when using tokenice_code' do
      original_code = 'some: code'
      tokenized_code = original_code.dup
      TokenizeTest::tokenize_code(tokenized_code)
      assert_equal(tokenized_code,original_code)
    end
    
    should 'raise exception if doesnt have pattern' do
      assert_raise(RObjC::Tokenize::MissingPatternError) {NoPattern.tokenize_code!('no_code')}
    end
    
    should 'find 3 tokens' do
      code = RObjC::Code.new("hey: hey
hi: hi
ho: ho")
      tokens = TokenizeTest::tokenize_code!(code)
      assert_equal(3,tokens.count)
      tokens.each {|t| assert_equal(TokenizeTest,t.class)}
    end
    
    should 'use TokenizeTestClass class' do
      assert_equal(TokenizeTestClass,TokenizeTest::tokenize_code!('class: 123'.to_code).first.class)
    end
    
    should 'use TokenizeTestObject class' do
      assert_equal(TokenizeTestObject,TokenizeTest::tokenize_code!('object: 123'.to_code).first.class)
    end
    
    should 'replace matched text by token' do
      code = RObjC::Code.new("hey: hey
hola
hi: hi
ho: ho")
      tokenized_code = 
"#<TESTING_TOKEN>
hola
#<TESTING_TOKEN>
#<TESTING_TOKEN>"
      TokenizeTest::tokenize_code!(code)
      assert_equal(tokenized_code,code)
    end

  end
  
  context 'Token' do
    setup do
      @original_code = RObjC::Code.new('something: 123')
      @tokenized_code, @tokens = *TokenizeTest::tokenize_code(@original_code).values
    end
    
    should 'respond to token_code' do
      assert_respond_to(@tokens.first,:token_code)
    end
    
    should 'code should match original code' do
      assert_equal(@original_code,@tokens.first.token_code)
    end
      
    context 'Code' do
      should 'respond to untokenize!' do
        assert_respond_to(@tokenized_code,:untokenize!)
      end
      
      should 'respond to untokenize' do
        assert_respond_to(@tokenized_code,:untokenize)
      end
      
      should 'untokenize to original string' do
        assert_equal(@original_code,@tokenized_code.untokenize!(@tokens))
      end
    end
    
  end
      
  
end