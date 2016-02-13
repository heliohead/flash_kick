require 'rails/generators'
require 'generators/flash_kick/base'
require 'generators/flash_kick/lib/question_helper'
require 'generators/flash_kick/lib/variable_store'
require 'fileutils'

module FlashKick
  class VagrantGenerator < FlashKick::Generator::Base

    def use_vagrant
      question :boolean do
        {
          use_vagrant: 'Would you like to use Vagrant with your project?',
          default: 'No'
        }
      end
    end

    def prompt_user
      if FlashKick::VariableStore.variables['use_vagrant'] == true
        question :string do
          {
            vagrant_memory: 'How many Megabytes of memory would you like to allocate to your VM? [enter for default]',
            default: '2'
          }
        end
        question :string do
          {
            vagrant_cpus: 'How many CPUs would you like to allocated? [enter for default]',
            default: '1'
          }
        end
      else
        puts 'Skipping Vagrant'
        exit
      end
    end

    def copy_files
      copy_file 'ansible_templates/playbooks/_vagrant.yml', 'config/ansible/playbooks/vagrant.yml'
    end

    def modify_files
      append_file '.gitignore', "\n.vagrant/"
    end

    def backup_files
      FileUtils.mv 'config/database.yml', 'config/database.yml.bak'
    end

    def copy_templates
      template '_database.yml', 'config/database.yml'
      template '_Vagrantfile', 'Vagrantfile'
    end
  end
end
