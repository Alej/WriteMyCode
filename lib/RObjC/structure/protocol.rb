module RObjC
  class Protocol < Structure
    TOKENIZE_PATTERN = /^\s*@protocol\s+.*?@end/m
    REQUIRED_METHODS_PATTERN = /^\s@required\s+.*?(@end|@optional)/m
    def initialize(params = {})
      super
    end
  end
end