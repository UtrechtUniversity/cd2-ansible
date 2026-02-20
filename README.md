# CD² ansible playbook 

Ansible playbook for the deployment of the CD² metadata catalogue.

## Requirements

### Requirements for local development (Docker setup)

* [Docker Compose](https://docs.docker.com/compose/)
* The images have been developed for the amd64 architecture

### Requirements for deploying to server

* [Ansible](https://docs.ansible.com/ansible/intro_installation.html) (>= 2.9)
* [Vagrant](https://www.vagrantup.com/docs/installation/) (2.x - only for local VM)
* Enterprise Linux 9 (e.g. AlmaLinux or RHEL)
* The images have been developed for the amd64 architecture

## Local development in containers (Docker)

If you use Windows, ensure that core.autocrlf is set to false in your git client before you clone the CD2 catalog
repository: _git config --global core.autocrlf false_ Otherwise the Docker images may not work due to line
ending changes.

### Building the images

If you want to test any local updates, you need to re-build the images:

```
cd docker
./build-local-images.sh
```

### Running the application using Docker

First add an entry to your `/etc/hosts` file (or equivalent) so that queries for the development setup
interface resolve to your loopback interface. For example:

```
127.0.0.1 cd2.ckan
```

Unless you want to build the images locally (see above), you need to pull them from the registry:

```
cd docker
docker compose pull
```

Then start the Docker Compose setup:
```
docker compose up
```

Then wait until CKAN has started. This may take a couple of minutes. Navigate to
https://cd2.ckan in your browser. The development VM runs with
self-signed certificates, so you'll need to accept the security warning in your browser.

## Local development VM

First create the VMs using Vagrant:

```bash
vagrant up
```

On a Windows host, first SSH into the Ansible controller virtual machine (skip this step on GNU/Linux or macOS):
```bash
vagrant ssh cd2-controller
cd ~/cd2-ansible
```

Deploy CD2 catalog to development virtual machine:
```bash
ansible-playbook playbook.yml
```

Add the following host to /etc/hosts (GNU/Linux or macOS) or %SystemRoot%\System32\drivers\etc\hosts (Windows):
```
192.168.60.30 cd2.ckan
```

### Configuration parameters

The main Ansible configuration parameters are:

|Setting                                    | Meaning                                                              |
|-------------------------------------------|----------------------------------------------------------------------|
|cd2_catalog_ckan_database_password         | CKAN database password                                               |
|cd2_catalog_admin_password                 | CKAN application ckanadmin account password                          |
|cd2_catalog_host_name                      | Hostname of the application that users connect to                    |
|cd2_catalog_host_ip                        | IP address that the application will run on                          |
|cd2_catalog_host_port                      | TCP port that the application will run on                            |
|cd2_catalog_mta_role                       | Type of MTA: use mailpit for local setup; postfix for production     |
|cd2_catalog_postfix_relayhost_fqdn         | Postfix relay mail server name                                       |
|cd2_catalog_postfix_relayhost_port         | Postfix: TCP port of mail server to use                              |
|cd2_catalog_postfix_relayhost_username     | Postfix: username on relay mail server (if authentication enabled)   |
|cd2_catalog_postfix_relayhost_password     | Postfix: password on relay mail server (if authentication enabled)   |
|cd2_catalog_postfix_relayhost_auth_enabled | Postfix: enable authentication (yes/no, default: yes)                |
|cd2_catalog_postfix_relayhost_tls_enabled  | Postfix: whether to use TLS (yes/no, default: yes)                   |
|cd2_catalog_postfix_myhostname             | Postfix: own server name to send in EHLO/HELO messages               |
|cd2_catalog_postfix_origin                 | Postfix: origin domain                                               |
|cd2_catalog_mail_from_address              | Sender address to use for mail messages                              |
|cd2_catalog_cert_mode                      | Currently supported modes: selfsigned or static                      |
|cd2_catalog_static_cert                    | TLS certificate for reverse proxy (if static mode is selected)       |
|cd2_catalog_static_cert_key                | TLS certificate key for rev proxy (if static mode is selected)       |
|cd2_catalog_ckan_uwsgi_num_workers         | Number of UWSGI workers for CKAN (default: 2)                        |
|cd2_catalog_anubis_ed25519_private_key     | Private key for Anubis. If you run the application in production, randomly generate a key using `openssl rand -hex 32` |
|cd2_catalog_behind_loadbalancer            | Set to 1 if catalog is running behind loadbalancer, otherwise 0 (default: 0) |

## License

This project is licensed under the Aferro GPL-v3 license.
The full license can be found in [LICENSE](LICENSE).
