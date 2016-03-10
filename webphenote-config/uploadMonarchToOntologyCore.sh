# Load ontology into a GOLR core named /ontology
# This script intended to run on the GOLR server itself, for efficiency and
# to avoid tying up a laptop for hours.
#
# This script assumes you have a mirrored ontology with a catalog.xml
# Use the mirrorOntologyLocally.sh script to prepare this cache.
#

#export OWLTOOLS_JAR="../java/lib/owltools-runner-all.jar"
export OWLTOOLS_JAR="../../owltools/OWLTools-Runner/bin/owltools-runner-all.jar"
export OWLTOOLS="java -Xms5500m -Xmx20500m -DentityExpansionLimit=4086000 -Djava.awt.headless=true -jar ${OWLTOOLS_JAR}"

export CACHEDIR=`pwd`/cached-models
export CATALOG=$CACHEDIR/catalog.xml

#export SOLR_URL=http://solr-dev.monarchinitiative.org/solr/ontology/
export SOLR_URL=http://localhost/solr/ontology/   # because we are running on GOLR server

export SOLR_CONFIG=ont-config.yaml

export ONTOLOGY_ROOT=http://purl.obolibrary.org/obo/ro.owl
# export ONTOLOGY_ROOT=http://purl.obolibrary.org/obo/upheno/monarch.owl

# Purge anything in the core

$OWLTOOLS \
       --solr-log solr-purge.log \
       --solr-url $SOLR_URL \
       --solr-purge \
       --solr-config $SOLR_CONFIG

# Load from the mirrored ontology, into the GOLR core

$OWLTOOLS \
	--catalog-xml $CATALOG \
	$ONTOLOGY_ROOT \
	--merge-support-ontologies \
	--remove-subset-entities upperlevel \
	--merge-imports-closure \
	--remove-disjoints \
	--reasoner elk \
	--silence-elk \
	--solr-log solr-load.log \
	--solr-url $SOLR_URL \
	--solr-config $SOLR_CONFIG \
	--solr-load-ontology \
	--solr-load-ontology-general
