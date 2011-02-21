class NilClass
  def empty?
    true
  end
end

class Object
  def parameters_to_ivars(params = {})
    params.each_pair do |key,value|
           instance_variable_set "@#{key}", value
    end
  end
end