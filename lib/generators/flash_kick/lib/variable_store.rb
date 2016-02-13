require 'generators/flash_kick/base'
require 'fileutils'
require 'yaml'

module FlashKick
  class VariableStore
    def self.add_variable(key, value)
      File.open(FlashKick::Generator.temp_dir + "variables.yml", 'a') {|f| f.write("#{key}: #{value}\n") }
    end

    def self.variables
      YAML.load(File.open(FlashKick::Generator.temp_dir + "variables.yml", 'r'))
    end

    def self.mkdir_tmp
      FileUtils.mkdir(FlashKick::Generator.root + '/tmp')
    end

    def self.rm_tmp
      FileUtils.remove_dir(FlashKick::Generator.root + '/tmp')
    end
  end
end
