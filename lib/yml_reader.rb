require "yml_reader/version"
require 'yaml'
require 'erb'

module YmlReader

  #
  # Set the directory to use when reading yml files
  #
  def yml_directory=(directory)
    @yml_directory = directory
  end

  #
  # Returns the directory to be used when reading yml files
  #
  def yml_directory
    return @yml_directory if @yml_directory
    return default_directory if self.respond_to? :default_directory
    nil
  end

  #
  # Loads the requested file.  It will look for the file in the
  # directory specified by a call to the yml_directory= method.
  # The parameter can also be a comma delimited list of files to
  # load and merge.
  #
  def load(filename)
    files= filename.include?(',') ? filename.split(',') : [filename]
    @yml = files.inject({}) do |total_merge, file|
      data = yml_key_include(::YAML.load(include_yml(file)))
      total_merge.merge!(data) if data
    end
  end

  def include_yml(file)
    filename = Pathname.new(file).absolute? ? file : "#{yml_directory}/#{file}"
    ERB.new(IO.read(filename)).result(binding) if File.exist?(filename)
  end

  private

  def yml_key_include(data)
    include_data = {}
    [data['_include_']].flatten.each {|file_path| include_data.merge!(self.load(file_path))} if data.key?('_include_')
    data.delete('_include_')
    data.merge!(include_data)
    data.each do |key, value|
      data[key] = yml_key_include(value) if value.is_a?(Hash)
    end
    data
  end

end
