Instructions for building SolrCloud / Blacklight application using Ansible and Vagrant
======================================================================================

Overview
--------

These scripts install the following applications:

* Solr 6.3.0
* Zookeeper 3.4.8
* Ruby 2.3.1 (via rbenv)
* Latest version of Ruby-on-Rails (should this be pinned?)
* Blacklight (which version?) and its associated gems

To replicate the production environment, the Solr nodes, Zookeeper and Blacklight (with Ruby-on-Rails) should each be installed on separate VMs. This repo contains a Vagrant file that will set up all the VMs and create the relevant service user on each. The Ansible scripts then deploy and start all the applications on the appropriate nodes.


Requirements for local development
----------------------------------
- Vagrant v1.8.4: https://releases.hashicorp.com/vagrant/1.8.4/
- VirtualBox > 5.0 & < 5.1: https://www.virtualbox.org/wiki/Download_Old_Builds_5_0
- Pip: https://pip.pypa.io/en/stable/installing/

There appears to be an issue with the latest version of Vagrant (1.9.n) which means that synced folders are not owned by the service user. This breaks the Ansible scripts, as the service user (bodl-tei-svc) doesn't end up with the correct permissions in its own home folder. I have posted to the Vagrant mailing list about this, and will also post a GitHub issue. By release this should hopefully be fixed.

https://groups.google.com/forum/#!topic/vagrant-up/WgUxjLpOThI


Setup
-----

On host machine:

Clone the Git repo and create the relevant home folders:

```bash
git clone git@gitlab.bodleian.ox.ac.uk:TEI-consolidation/solrcloud-ansible-build-scripts.git
cd solrcloud-ansible-build-scripts
mkdir zookeeper_home solr1_home solr2_home blacklight_home
```
Start a python virtual environment and install Ansible:

```bash
virtualenv ~/solrcloud-ansible-build-scripts/env
source env/bin/activate
pip install ansible
sudo mkdir /etc/ansible
sudo nano /etc/ansible/hosts
```

Copy and paste the following into the hosts file.

```bash
#### Local development machines
[zookeeper-dev]
zoo1-dev ansible_host=172.28.128.9

[solrcloud-dev]
solr1-dev ansible_host=172.28.128.10
solr2-dev ansible_host=172.28.128.11

[blacklight-dev]
bl1-dev ansible_host=172.28.128.12

#### QA machines
[zookeeper-qa]
zoo1-qa ansible_host=129.67.246.168

[solrcloud-qa]
solr1-qa ansible_host=129.67.246.169
solr2-qa ansible_host=129.67.246.172

[blacklight-qa]
bl1-qa ansible_host=129.67.246.170

#### Production machines

[zookeeper-prd]
zoo1-prd ansible_host=129.67.246.184

[solrcloud-prd]
solr1-prd ansible_host=129.67.246.182
solr2-prd ansible_host=129.67.246.183

[blacklight-prd]
bl1-prd ansible_host=129.67.246.181

#### Machine groups

[development:children]
blacklight-dev
solrcloud-dev
zookeeper-dev

[qa:children]
blacklight-qa
solrcloud-qa
zookeeper-qa

[production:children]
blacklight-prd
solrcloud-prd
zookeeper-prd
```

TL;DR
=====

Both the SSH and Sudo passwords for the vagrant boxes are 'vagrant'. You will be asked for this each time you run a playbook.

All commands below should be run from the `solrcloud-ansible-build-scripts/ansible_scripts` folder.

```bash
vagrant up
```
The blacklight playbook clones the Blacklight application and the Solr schema configuration from GitLab. Because of this you need to create an ssh key on the blacklight and solr VMs and add them to your GitLab account.

```bash
vagrant ssh solr1
sudo su bodl-tei-svc
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```

Once the ssh keys are saved to your GitLab account, you can run the Ansible playbooks:

```bash
cd ansible_scripts
./deploy.sh vagrant zookeeper dev
./deploy.sh vagrant solrcloud dev
./deploy.sh vagrant blacklight dev tolkien
```

Long version
============

Create Vagrant boxes
--------------------
The `Vagrantfile` in the root of the project directory defines how the four virtual machines for the various parts of the application should be created. Create them with the following command:

```bash
vagrant up
```

Runtime: ~2 mins


Install Zookeeper
-----------------
Zookeeper must be built first, so that the Solr nodes have something to connect to.

The following command will install and start Zookeeper on the `zoo1` node:

```bash
./deploy.sh vagrant zookeeper dev
```

Runtime: ~2 mins


Install Solr nodes
------------------
The Solrcloud playbook clones the solr config repos from GitLab. Because of this you need to create an ssh key on both the Solrcloud VMs and add them to your GitLab account.

```bash
vagrant ssh solr1
sudo su bodl-tei-svc
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```

The following command will then install and start Solr in SolrCloud mode on each of the nodes in the `solrcloud` group:

```bash
./deploy.sh vagrant solrcloud dev
```

Runtime: ~10 mins


Install Apache, Ruby, Rails, Blacklight
---------------------------------------
The blacklight playbook clones the Blacklight application from GitLab. Because of this you need to create an ssh key on the blacklight VM and add it to your GitLab account.

```bash
vagrant ssh blacklight
sudo su bodl-tei-svc
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```
Once this ssh key is saved to your GitLab account, you can run the final Ansible playbook.

The following command will install rbenv, Ruby, Rails, Apache and Blacklight on the one node in the `blacklight` group:

```bash
./deploy.sh vagrant blacklight dev tolkien
```

The deploy script for the Blacklight application requires an additional option ('tolkien' above). This references an item in the `catalogues` dictionary in the `blacklight-install` `vars` file. The `vars` file can be found at `ansible_scripts/roles/blacklight-install/vars`. When creating a new TEI catalogue Blacklight application, you should add a dictionary entry for it into this file and check it in to the Git repo.

Runtime: 15 - 20 mins

bodl-tei-svc service user
-------------------------

All the applications (Zookeeper, Solr, Blacklight etc) are run from and by the service user on each node.
The service worker is called `bodl-tei-svc` on all the nodes.


Deploying to QA or PRD (WIP)
============================

Add your public key (`~/.ssh/id_rsa.pub`) to the `~/.ssh/known_hosts` file for your Connect user on each of the target machines.

Add the public keys for each of the Solrcloud VMs and the Blacklight VM to your GitLab SSH keys.

The following commands will then deploy the applications to QA:

```bash
./deploy.sh {{ YOUR CONNECT ACCOUNT USER NAME}} zookeeper qa
./deploy.sh {{ YOUR CONNECT ACCOUNT USER NAME}} solrcloud qa
./deploy.sh {{ YOUR CONNECT ACCOUNT USER NAME}} blacklight qa {{ COLLECTION NAME HERE }}
```

For production deployment do the above but replace `qa` with `prd` in the deploy commands.

TO DO:
------

* [ ] Add start-up scripts for both Zookeeper, Solr and Blacklight/apache
