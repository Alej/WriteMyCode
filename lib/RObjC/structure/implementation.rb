module RObjC
  class Implementation < Structure
    TOKENIZE_PATTERN = /^\s*@implementation\s+.*?@end/m
  end
end

