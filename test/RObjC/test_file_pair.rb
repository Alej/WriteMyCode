require 'helper'

#copy fixtures to tmp
file_dir = File.dirname(__FILE__)
SOMEOBJECT_HEADER_PATH = "#{file_dir}/../tmp/someObject.h"
SOMEOBJECT_IMPLEMENTATION_PATH = "#{file_dir}/../tmp/someObject.m"
tmpPath = "#{file_dir}/../tmp"
FileUtils.mkdir_p tmpPath
FileUtils.cp File.join(file_dir,'..','Fixtures','someObject.h'), SOMEOBJECT_HEADER_PATH
FileUtils.cp File.join(file_dir,'..','Fixtures','someObject.m'), SOMEOBJECT_IMPLEMENTATION_PATH

class TestFilePair < Test::Unit::TestCase
  
  def self.should_have_interface_and_implementations_files(objC_file_path)
    context "" do
      setup do
        @file_pair = RObjC::FilePair.new(objC_file_path)
      end

      should "not be nil" do
        assert_not_nil @file_pair
      end

      should "have header file" do
        assert_not_nil @file_pair.header_file
      end
      
      should "have implementation file" do
        assert_not_nil @file_pair.implementation_file
      end
    end
  end
  
  context 'file pair' do
  
    context 'with missing file' do
      should 'raise exception' do
        assert_raise(LoadError) {RObjC::FilePair.new('./not_a_real_file.nf')}
      end
    end
  
    context 'from h file' do    
      should_have_interface_and_implementations_files(SOMEOBJECT_HEADER_PATH)
      setup do
        @file_pair = RObjC::FilePair.new(SOMEOBJECT_HEADER_PATH)
      end
    
    end
  
    context 'from m file' do
      should_have_interface_and_implementations_files(SOMEOBJECT_IMPLEMENTATION_PATH)
      setup do
        @file_pair = RObjC::FilePair.new(SOMEOBJECT_IMPLEMENTATION_PATH)
      end

    end
    
  end
  
end