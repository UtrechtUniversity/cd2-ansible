# CD² ansible playbook 

Ansible playbook for the deployment of the CD² metadata catalogue.

### Requirements
- [Vagrant](https://www.vagrantup.com) (installation instructions [here](https://www.vagrantup.com/downloads))
- [Ansible](https://ansible.com) (installation instructions [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-ansible-community-package))
- [community.postgresql Ansible Galaxy repository](https://galaxy.ansible.com/community/postgresql) (install by running `ansible-galaxy collection install community.postgresql`)

###  Confirmed to work on the following host operating systems
- Ubuntu 20.04 LTS

###  Installing the CD2 catalog in a local development VM
1. Navigate to the cd2-ansible directory
2. Run `vagrant up`
3. Add the following line to your hostfile (e.g. `/etc/hosts` on Unix-based systems): `192.168.60.30 cd2.ckan.test`
4. If you are on a Windows system, log in on the controller VM (`vagrant ssh cd2-controller`) and go to the repository directory (`cd cd2-ansible`). This step is not applicable to Linux and macOS systems.
5. On a GNU/Linux or macOS host make sure the SSH keys have the right permissions (skip this step on Windows): `chmod 0600 ./vagrant/ssh/vagrant`
6. Install the application using Ansible: `ansible-playbook -DK -i environments/development playbook.yml`
7. Press enter when Ansible asks for a password.
8. You can now access the CKAN environment at <https://cd2.ckan.test/user/login>. The credentials for the default administrative user are: username `ckanadmin` and password `testtest`.
9. To log into the virtual machine using SSH, run `vagrant ssh` (on Linux or macOS) or `vagrant ssh cd2` (on Windows)
