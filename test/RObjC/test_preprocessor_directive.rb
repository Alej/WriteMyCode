require 'helper'

class TestPreprocessorDirective < Test::Unit::TestCase
  def assert_good_preprocessor_directive(directive_code, expected_class, expected_value, expected_type=nil, expected_code=directive_code)
    directive = RObjC::PreprocessorDirective::Any.tokenize_code(directive_code)[:tokens].first
    assert_not_nil(directive)
    assert_equal(expected_code,directive.code,'code')
    assert_equal(expected_class,directive.class,'class')
    assert_equal(expected_value,directive.value,'value')
    assert_equal(expected_type,directive.type,'type') if expected_type
  end
  
  context 'Tokenize' do
    should 'respond to tokenize_code' do
      assert_respond_to(RObjC::PreprocessorDirective::Any,:tokenize_code)
    end
    
    should 'parse define' do
      assert_good_preprocessor_directive('#define hello hola',RObjC::PreprocessorDirective::Define,'hello hola','define')
    end
    
    should 'parse pragma mark -' do
      assert_good_preprocessor_directive('#pragma mark -',RObjC::PreprocessorDirective::Pragma,'-','pragma mark')
    end
    
    should 'parse pragma mark hola' do
      assert_good_preprocessor_directive('#pragma mark hola',RObjC::PreprocessorDirective::Pragma,'hola','pragma mark')
    end
    
    should 'parse import <cocoa.h>' do
      assert_good_preprocessor_directive('#import <cocoa.h>',RObjC::PreprocessorDirective::Import,'<cocoa.h>','import')
    end
    
    should 'parse import "cocoa.h"' do
      assert_good_preprocessor_directive('#import "cocoa.h"',RObjC::PreprocessorDirective::Import,'"cocoa.h"','import')
    end
    
    should 'parse include <cocoa.h>' do
      assert_good_preprocessor_directive('#include <cocoa.h>',RObjC::PreprocessorDirective::Include,'<cocoa.h>','include')
    end
    
    should 'parse include "cocoa.h"' do
      assert_good_preprocessor_directive('#include "cocoa.h"',RObjC::PreprocessorDirective::Include,'"cocoa.h"','include')
    end
    
  end
      
end