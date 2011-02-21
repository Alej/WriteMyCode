require 'helper'

class TestComment < Test::Unit::TestCase
  context 'tokenize' do
    def assert_good_comment(comment_code, expected_comment = comment_code)
      comment = @klass.tokenize_code(comment_code)[:tokens].first
      assert_not_nil(comment)
      assert_equal(expected_comment,comment.code)
    end
    
    setup do
      @comments_code = 
"
// a comment
/* another coment */
/* multi
line comment */
"
    end
    
    should 'respond to tokenize_code' do
      assert_respond_to(RObjC::Comment,:tokenize_code)
    end
    
    should 'parse 2 multiline comments' do
      tokens = RObjC::MultiLineComment.tokenize_code(@comments_code)[:tokens]
      assert_equal(2,tokens.count)
    end
    
    should 'parse 1 single line comment' do
      tokens = RObjC::SingleLineComment.tokenize_code(@comments_code)[:tokens]
      assert_equal(1,tokens.count)
    end
  end
  
  context 'parsing' do
  
    context 'single line comment' do
      setup do
        @klass = RObjC::SingleLineComment
      end
    
      should 'match' do
        assert_good_comment('// a comment')
      end
      
      should 'match without space' do
        assert_good_comment('//a comment')
      end
    
      should 'match with text in front' do
        assert_good_comment('text in front //comment','//comment')
      end
      
      should 'match with text in front without spaces' do
        assert_good_comment('text in front//comment','//comment')
      end
    
    end
  
    context 'multiline comment' do
      setup do
        @klass = RObjC::MultiLineComment
      end
      
      should 'match' do
        comment_code = '/* multi
        line comment */'
        assert_good_comment(comment_code)
      end
      
      should 'match without spaces' do
        assert_good_comment('/*aComment*/')
        assert_good_comment ('/*AComment that is 
        multi line*/')
      end
      
      should 'match in single line' do
        assert_good_comment('/* a multiline comment in a single line */')
      end
      
      should 'multiline within text' do
        assert_good_comment('text/*comment*/end','/*comment*/')
      end
      
    end
  


  end
end