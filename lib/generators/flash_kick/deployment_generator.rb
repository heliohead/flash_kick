require 'rails/generators'
require 'generators/flash_kick/base'
require 'generators/flash_kick/lib/question_helper'
require 'generators/flash_kick/lib/variable_store'
require 'fileutils'

module FlashKick
  class DeploymentGenerator < FlashKick::Generator::Base

    def prompt_user
      question :string do
        {
          app_name: 'What is the name of your application? [enter for default]',
          default: Rails.application.class.parent_name.underscore
        }
      end
      question :string do
        {
          server_domain: 'Which domain will you be deploying to? [enter for default]',
          required: true
        }
      end
      question :string do
        {
          server_user: 'Enter a name for your server deployer user',
          default: 'deploy'
        }
      end
      question :string do
        {
          server_ssh_port: 'What SSH port would you like to use on your server? [enter for default]',
          default: '22'
        }
      end
      question :string do
        {
          ruby_version: 'Which version of Ruby would you like to install? [enter for default]',
          default: '2.3.0'
        }
      end
      question :string do
        {
          postgresql_version: 'Which version of PostgreSQL would you like to install? [enter for default]',
          default: '9.5'
        }
      end
      question :string do
        {
          database_name: 'Enter a name for your production database',
          default: Rails.application.class.parent_name.underscore + '_production'
        }
      end
      question :string do
        {
          database_user: 'Enter a name for your production database user',
          default: 'postgres'
        }
      end
      question :string do
        {
          database_password: 'Enter a password for your production database',
          required: true
        }
      end
      question :string do
        {
          app_repo: 'What is the github repository for this application?',
          required: true
        }
      end
      question :string do
        {
          app_repo_branch: 'Which repository branch will be used for deployment? [enter for default]',
          default: 'master'
        }
      end
    end

    def copy_directory
      directory 'ansible', 'config/ansible'
    end

    def copy_files
      copy_file 'env_templates/_development_env.yml', '.env/development_env.yml'
      copy_file 'env_templates/_test_env.yml', '.env/test_env.yml'
    end

    def copy_templates
      template 'ansible_templates/_hosts', 'config/ansible/hosts'
      template 'ansible_templates/playbooks/_production.yml', 'config/ansible/playbooks/production.yml'
      template 'ansible_templates/playbooks/group_vars/_all.yml', 'config/ansible/playbooks/group_vars/all.yml'
      template '_puma.sh', 'bin/puma.sh'
      template '_puma.rb', 'config/puma.rb'
      template '_deploy.rb', 'config/deploy.rb'
      template 'env_templates/_production_env.yml', '.env/production_env.yml'
    end

    def add_gems
      gem 'puma'
      gem 'rb-readline'
    end

    def modify_files
      append_file '.gitignore', '.env/'
      inject_into_file 'config/environment.rb', after: "require File.expand_path('../application', __FILE__)\n\n" do <<-'RUBY'
FlashKick.load_variables

      RUBY
      end
    end

    def change_permissions
      FileUtils.chmod 0751, 'config/ansible/provision.sh'
      FileUtils.chmod 0751, 'bin/puma.sh'
    end

    def create_symlinks
      FileUtils.ln_s '../../../../.env/production_env.yml', 'config/ansible/playbooks/group_vars/production.yml'
    end
  end
end
