module RObjC
  class InstanceVariable
    def getter_method
      method = Method.new
      method.return_type = dup
      method.name = name
      method.implementation = "return #{ivar_name};"
      method
    end
    
    def setter_method
      method = Method.new
      method.return_type = Method::VOID_RETURN_TYPE
      method.name = "set#{name.capitalize}:"
      method.parameters = [Variable.new(name: param_name, type: type, asteriscs: asteriscs)]
      implementation_lines = ["if (#{ivar_name} == #{param_name}) return;"]
      case setter_semantic
      when RETAIN then implementation_lines << "[#{param_name} retain];\n[#{ivar_name} release];"
      when COPY then implementation_lines << "[#{param_name} copy];\n[#{ivar_name} release];"
      end
      implementation_lines << "#{ivar_name} = #{param_name};"
      method.implementation = implementation_lines.join "\n"
      method
    end
    
  end
  
  class Property
    def getter_method
      method = super
      if atomic?
        method.implementation = method.implementation.to_code.wrapped_in_block('@synchronized (self)')
      end
      method
    end
    
    def setter_method
      method = super
      if atomic?
        method.implementation = method.implementation.to_code.wrapped_in_block('@synchronized (self)')
      end
      method
    end
    
  end
end