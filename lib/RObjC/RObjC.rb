module RObjC
end

#import everything
fileDir = File.dirname(__FILE__)
folders = {'logic' => %w{code tokenize parse_error helper},
           'variable' => %w{comment variable instance_variable property objc_method preprocessor_directive variable_to_method}}
folders.each_key do |folder| 
  folders[folder].each {|file| require "#{fileDir}/#{folder.to_s}/#{file}" }
end
