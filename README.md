![flash kick](img/Flash_Kick.gif)
```
_____________             ______       ______ _____      ______
___  __/__  /_____ __________  /_      ___  /____(_)________  /__
__  /_ __  /_  __ `/_  ___/_  __ \     __  //_/_  /_  ___/_  //_/
_  __/ _  / / /_/ /_(__  )_  / / /     _  ,<  _  / / /__ _  ,<
/_/    /_/  \__,_/ /____/ /_/ /_/      /_/|_| /_/  \___/ /_/|_|

         Flash kick = Ansible + Mina + Nginx + Puma
```
This gem is a fork of [Ahoy](https://github.com/npearson72/rails-ahoy)

# Flash Kick will generate everything you need to deploy your Rails application

* Ansible scripts to provision your server with Nginx, Ruby, PostgreSQL, and recommended security settings (ssh hardening, firewall, fail2ban, etc.)
* Mina scripts to deploy your Rails application
* Puma application server configuration files
* An *.env* directory that will use YAML to store your environment variables securely

## Installation

**RECOMMENDATION:** You might want to first try this using a fresh Rails application so you can see how it effects your files before running this in your existing code base.
Add this line to your application's Gemfile:

You'll need [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
and [Mina](http://nadarei.co/mina/)

### Step 1

Add the gem to your Gemfile and bundle

```ruby
gem 'flash_kick'
```

    $ bundle install

Execute the following terminal command to launch flash_kick's interactive guide

    $ rails g flash_kick:init

Continue to next step AFTER you complete the interactive guide

### Step 2

If you don't have a production *secret_key_base*, generate one using:

    $ rake secret

This will produce something that looks like:

    $ f67395912d0ddd0de80a734822e73b327d007809123...

Now just copy and paste it into the following file:

    $ <YOUR RAILS APP>/.env/production_env.yml

**IMPORTANT:** At this point make sure to commit your changes and push them up to your repo!

### Step 3

**IMPORTANT:** For this step, you will need a freshly installed Ubuntu box with root ssh privileges. If you're not sure how to do this, contact your web hosting administrator.

From the root of your Rails application...

    $ cd config/ansible && ./provision.sh production

Executing `provision.sh <RAILS ENVIRONMENT FOR DEPLOYED APP>` will launch the provisioning process and setup your box so it can run Rails using Nginx as the web server, Puma as your application server, and PostgreSQL as your database.

**NOTE:** This process may take a while (15 mins or so), so sit back and relax.

### Step 4
Once the provisioning process is complete, log into your box with the server user (ex: deployer)

    $ ssh deployer@<YOUR SERVER IP>

Once in, get your server user's public key

    $ cat ~/.ssh/id_rsa.pub

This will print out something like this:

	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOv2hw90hySH+41A6NVjp6GXhBS/PUVmTot...

Copy the public key and paste it into your git repo [Github](https://developer.github.com/guides/using-ssh-agent-forwarding/), [Bitbucket](https://confluence.atlassian.com/bitbucket/repository-privacy-permissions-and-more-221449716.html) settings to allow SSH access.

### Step 5
Go back to the ***root of your Rails application and execute the following command:

    $ mina production setup

Then...

    $ mina production deploy

### Congratulations!

If everything worked as it should have, your Rails application should be up and running on the Web. Enjoy!


## Contributing

1. Fork it ( https://github.com/heliohead/flash_kick/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/heliohead/flash_kick. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available under the terms of the [wtfpl](LICENSE.txt).

