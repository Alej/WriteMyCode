require 'helper'
class TestFile < Test::Unit::TestCase
  def self.should_contain_the_following_structures(file, structures = {})
    context '' do
      should "have #{structures[:interfaces]} interfaces" do
        assert_equal(structures[:interfaces],file.interfaces.count) if structures.key? :interfaces
      end
      
      should "have #{structures[:implementations]} implementations" do
        assert_equal(structures[:implementations],file.implementations.count) if structures.key? :implementations
      end
      
      should "have #{structures[:protocols]} protocols" do
        assert_equal(structures[:protocols],file.protocols.count) if structures.key? :protocols
      end
    end
  end
  file_dir = File.dirname(__FILE__)
  header_path = "#{file_dir}/../tmp/someObject.h"
  file_pair = RObjC::FilePair.new(header_path)

  context 'header file' do    
    should_contain_the_following_structures(file_pair.header_file,{interfaces: 1})
  end
  
  context 'implementation file' do
    should_contain_the_following_structures(file_pair.implementation_file,{implementations: 1})
  end
  
end