class FactoryGraph
  def initialize
    @objects = {}
  end

  def create_objects(*args)
    factory_specs = []
    test = args.shift
    args.each do |arg|
      if arg.is_a?(Hash) then
        arg.each {|k,v| factory_specs.push({k => v}) }
      else
        factory_specs.push(arg)
      end
    end
      
    build_objects_from_spec_array(factory_specs)

    # set instance variables in test
    @objects.each do |k, v|
      test.instance_variable_set("@#{k}", v)
    end

    @objects
  end

  def build_objects_from_spec_array(factory_specs)
    factory_specs.each do |factory_spec|
      build_object(factory_spec)
    end
    @objects
  end

  def build_object(factory_spec)
    if factory_spec.is_a?(Hash) then
      factory_name = factory_spec.keys.first
    else
      factory_name = factory_spec
    end

    return @objects[factory_name] if @objects[factory_name]
    object = FactoryGirl.create(factory_name)

    if factory_spec.is_a?(Hash) then
      factory_spec[factory_name].each do |field, value|
        # if field to be set is an association
        reflection = object.class.reflections[field]
        # if reflection
        if reflection then
          # the values are factory names
          if reflection.macro == :has_many then
            if value.is_a?(Array)
              objects = value.map{|factory_name| build_object(factory_name)}
            else
              objects = [build_object(value)]
            end
            object.send(field) << objects
          else
            object.send("#{field}=", build_object(value))
          end
        else
          object.send("#{k}=", v)
        end
      end
    end

    object.save
    @objects[factory_name] = object
  end
end


