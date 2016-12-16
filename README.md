## BoundRound Web App Summary
- KEY GEMS and VERSIONS
	- Ruby 2.1.3
	- Rails 4.1.6
	- Devise
	- Omniauth (Facebook, Google+, Instagram)
	- Algolia Search
	- Memcached (Server Side Cache - Gems memcachier and dalli)
	- Sidekiq / Redis (MQ)
	- Fastly (CDN)
	- Carrierwave (uploads to AWS)
	- CKEditor (WYSIWYG Editing)
	- Geocomplete Rails
	- New Relic
	- Rails Admin
	- Simple Form
	- See GEMFILE for further info

## Getting Up And Running

## Install Bound Round Vagrant Box

### Package includes
- Ubuntu 12.04
- Ruby 2.1.3 and 1.9.3
- RVM 1.25.25
- PostgreSQL 9.3
- Node 0.6.12

### Installation
- Download and install Vagrant (http://www.vagrantup.com)
- Download and install VirtualBox (https://www.virtualbox.org)
- Navigate to working directory
- Put the Vagrantfile provided in the working directory OR
  - Type <code>vagrant init dwhitworth/boundround</code>
  - This initializes your directory with a new <code>Vagrantfile</code>

### Operation
- Type <code>vagrant up</code>
  - This starts your Vagrant VM
- ssh into your VM by typing <code>vagrant ssh</code>
- You should be inside of your working directory
  - NOTE: some users have had to cd ../../vagrant to get into the working directory

You can share files seamlessly between your host operating system and your virtual machine. This is useful if, for instance, you’d like to use a graphical editor in the host operating system, but run the code inside the VM.

The folder that you used to store the vagrant configuration is automatically shared with the virtual machine. So…

Say you’re working in the directory <code>~/projects/rails_example</code>
It currently contains the config file <code>~/projects/rails_example/Vagrantfile</code>
You can create a file <code>~/projects/rails_example/README.md</code> using your host OS and any editor

Within the VM’s SSH session, you can interact with that file, like <code>cat /vagrant/README.md</code>

#### Local Editor

Because of the transparent folder sharing you have two options for editing code:

- SSH into your virtual machine and use a text-based editor like Vim or Emacs
- Run a graphical editor in the host operating system

#### Notes
Your terminal will be pretty bare bones. Feel free to pretty it up by installing oh-my-zsh, or implementing any bash enhancements on your own. This is really just to ensure that we are all running the same ruby, OS, db, javascript runtime etc.›

## Running the Web App
Clone this repo into your working directory.  
$ vagrant up  
$ vagrant ssh  
Navigate to the working directory (`$ cd shared` or `$ cd /vagrant`)  
$ bundle  
$ copy database.yml and application.yml to config/  
$ rake db:create db:migrate  
$ rails s  

If you have a copy of the production database (latest.dump), you can also restore from this file using:  
$ `pg_restore --clean --no-acl --no-owner --verbose -U vagrant -d vagrant <path-to-latest.dump>`  
