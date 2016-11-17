# Load ontology into a GOLR core named /ontology
# This script intended to run on the GOLR server itself, for efficiency and
# to avoid tying up a laptop for hours.
#
# This script assumes you have a mirrored ontology with a catalog.xml
# Use the mirrorOntologyLocally.sh script to prepare this cache.
#
#IMPORTANT NOTE:
#	This particular script is rarely executed and is expensive to test.
#	There may be some errors that were introduced when generalizing this
#	script to support monarch/go/hpo, but they are probably confined to the
#	catalog.xml file location
#
# ./uploadMonarchToOntologyCore.sh [ro|monarch|hp] # Default is ro
#

ROOTOWL="${1:-ro}"
if [ "$ROOTOWL" == 'hp' ]; then
	# ROOTOWL_URL='http://purl.obolibrary.org/obo/hp.owl'
	ROOTOWL_URL='./hp.owl'
fi
if [ "$ROOTOWL" == 'monarch' ]; then
	ROOTOWL_URL='http://purl.obolibrary.org/obo/upheno/monarch.owl'
fi
if [ "$ROOTOWL" == 'go' ]; then
	ROOTOWL_URL='http://purl.obolibrary.org/obo/go/extensions/go-lego.owl'
fi
if [ "$ROOTOWL" == 'ro' ]; then
	ROOTOWL_URL='http://purl.obolibrary.org/obo/ro.owl'
fi

echo "# ROOTOWL: $ROOTOWL"
echo "# ROOTOWL: $ROOTOWL"
echo "# ROOTOWL_URL: $ROOTOWL_URL"

export CACHEDIR=`pwd`/$ROOTOWL-cached/
export CATALOG=./catalog.xml
export OWLTOOLS_JAR="/opt/owltools/OWLTools-Runner/bin/owltools-runner-all.jar"
export OWLTOOLS="java -Xms5500m -Xmx20500m -DentityExpansionLimit=4086000 -Djava.awt.headless=true -jar ${OWLTOOLS_JAR}"

#export SOLR_URL=http://solr-dev.monarchinitiative.org/solr/ontology/
export SOLR_URL=http://localhost/solr/ontology/   # because we are running on GOLR server
export SOLR_CONFIG=ont-config.yaml

# Purge anything in the core

$OWLTOOLS \
       --solr-log solr-purge.log \
       --solr-url $SOLR_URL \
       --solr-purge \
       --solr-config $SOLR_CONFIG

# Load from the mirrored ontology, into the GOLR core

$OWLTOOLS \
	--catalog-xml $CACHEDIR/$CATALOG \
	$ROOTOWL_URL \
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
	--solr-load-ontology-general \
	> $CACHEDIR/upload.log
