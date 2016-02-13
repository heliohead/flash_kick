require 'flash_kick/version'
require 'rails/generators'
require 'generators/flash_kick/base'
require 'generators/flash_kick/lib/variable_store'

module FlashKick
  class InitGenerator < FlashKick::Generator::Base

    def init
      FlashKick::VariableStore.mkdir_tmp
      section_divider
      masthead
      section_divider
      generate 'flash_kick:deployment'
      section_divider
      generate 'flash_kick:vagrant'
      section_divider
      puts 'Finalizing...'
      section_divider
      puts 'Finished!'
      FlashKick::VariableStore.rm_tmp
    end


    private

    def section_divider
      puts '=' * 100
    end

    def masthead
      puts '  _____________             ______       ______ _____      ______   '
      puts '  ___  __/__  /_____ __________  /_      ___  /____(_)________  /__ ' + '         FlashKick!'
      puts '  __  /_ __  /_  __ `/_  ___/_  __ \     __  //_/_  /_  ___/_  //_/ ' + '   Get your Rails app deployed'
      puts '  _  __/ _  / / /_/ /_(__  )_  / / /     _  ,<  _  / / /__ _  ,<    '
      puts '  /_/    /_/  \__,_/ /____/ /_/ /_/      /_/|_| /_/  \___/ /_/|_|   ' + "  v.#{FlashKick::VERSION}"
      puts '  _________________________________________________________________ '
      puts '           Flash kick = Ansible + Mina + Nginx + Puma               '

    end
  end
end
