To create a new TEI catalogue application, you need three things:

1) A Solr configuration folder for the new catalogue, stored its own GitRepo.
2) A name for the Solr collection as it will be stored in SolrCloud
3) A clone of the Blacklight boilerplate application repo, again, stored in its own separate repo.

Once you have these three things, you can follow the instructions below to build the application with a catalogue-specific Blacklight implementation.


1) Clone the solrcloud-ansible-build-scripts repo:

```bash
git clone git@gitlab.bodleian.ox.ac.uk:TEI-consolidation/solrcloud-ansible-build-scripts.git
```

2) Add in the relevant Solr config, Solr collection name, and Blacklight repo to the various variable files:

  - In the file, ansible-scripts/roles/common/vars/main.yml, add the Solr config name and repo to the solr_conf_repos variable list.
  - In the file, ansible-scripts/roles/blacklight-install/vars/main.yml, change the blacklight repo and solr_collection name as necessary.

3) Go through the steps in the main Readme.md file to build Zookeeper, SolrCloud and Blacklight locally.

Running multiple Blacklight instances locally
---------------------------------------------

* Add additional Vagrant boxes into the `Vagrantfile`, copying the 'Blacklight' configuration block. This will build the VMs necessary for each Blacklight instance.
* Copy the `roles/blacklight-install` folder and rename to something catalogue specific (e.g. `tolkien-install`).
* Copy `ansible-scripts/blacklight.yml` and rename to something catalogue specific (e.g. `tolkien.yml`).
* Copy
