require "flash_kick/version"

module FlashKick
  def self.load_variables
    begin
      env_file = File.open(Rails.root + ".env/#{Rails.env}_env.yml", 'r')
      if env_file
        env_yaml = YAML.load(env_file)
        env_yaml.each { |k,v| ENV[k.to_s.upcase] = v.to_s } if env_yaml.present?
      end
    rescue
    end
  end
end
