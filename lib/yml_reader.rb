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
  # Loads the requested files.  It will look for them in the
  # directory specified by a call to the yml_directory= method.
  # The parameter can be a single file or a comma delimited list of files to
  # load and merge.
  #
  def load(file_list)
    files = file_list.include?(',') ? file_list.split(',') : [file_list]
    @yml = files.inject({}) do |total_merge,file|
      data_from_file = ::YAML.load(ERB.new(File.read("#{yml_directory}/#{file}")).result(binding))
      total_merge.merge! data_from_file
    end
  end
  
  def include_yml(filename)
    ERB.new(IO.read("#{yml_directory}/#{filename}")).result
  end

end
