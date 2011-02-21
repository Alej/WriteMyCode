module RObjC
  class FilePair
    HEADER_EXTENSION = '.h'
    IMPLEMENTATION_EXTENSION = '.m'
    attr_reader :header_file, :implementation_file
    
    def initialize(file_path)
        raise LoadError.exception "#{file_path} doesn't exist" unless File.exists? file_path
        raise "#{file_path} is not writable" unless File.writable? file_path
        @header_file = RObjC::File.new(file_path.sub(File.extname(file_path),HEADER_EXTENSION),'r+')
        @implementation_file = RObjC::File.new(file_path.sub(File.extname(file_path),IMPLEMENTATION_EXTENSION),'r+')
    end
    
  end
end