Managing SolrCloud config sets
==============================

Creating a collection for the first time
----------------------------------------

```bash
vagrant ssh solr1
sudo su bodl-tei-svc
cd ~/solr-6.4.0
bin/solr create -c tolkien-catalogue -d  tolkien_config -s 2 -rf 2
```

Reuploading a changed config set and reloading config in Solr
-------------------------------------------------------------

```bash
bin/solr zk upconfig -z 172.28.128.9:2181/solr -n tolkien_config -d /home/bodl-tei-svc/solr-6.4.0/server/solr/configsets/tolkien_config
curl "http://localhost:8983/solr/admin/collections?action=RELOAD&name=tolkien-catalogue"
```

Config sets should be stored in GitHub, cloned, changed and reuploaded to zookeeper using the Solr control script commands:

Clear all documents from Solr
-----------------------------

curl "http://localhost:8983/solr/tolkien-catalogue/update?stream.body=<delete><query>*:*</query></delete>&commit=true"

Link config file to a collection
--------------------------------

./server/scripts/cloud-scripts/zkcli.sh -zkhost 172.28.128.9:2181/solr -cmd linkconfig -collection tolkien-catalogue -confname tolkien_config

curl "http://localhost:8983/solr/tolkien-catalogue/update?commit=true" -H "Content-type: text/xml" --data-binary @tei-solr-input.xml
