require "yml_reader/version"

module YmlReader

  def yml_directory=(directory)
    @yml_directory = directory
  end

  def yml_directory
    return @yml_directory if @yml_directory
    return default_directory if self.respond_to? :default_directory
    nil
  end

  def load(filename)
    @yml = YAML.load_file "#{@yml_directory}/#{filename}"
  end
  
end
