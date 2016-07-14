# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring

# ./mirrorOntologyLocally.sh [ro|monarch|hp] # Default is ro

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
echo "# CACHEDIR: $CACHEDIR"
echo "# ROOTOWL: $ROOTOWL"
echo "# ROOTOWL_URL: $ROOTOWL_URL"

export CACHEDIR=`pwd`/$ROOTOWL-cached/
export CATALOG=./catalog.xml
export OWLTOOLS_JAR="/opt/owltools/OWLTools-Runner/bin/owltools-runner-all.jar"
export OWLTOOLS="java -Xms3000m -Xmx5500m -DentityExpansionLimit=4086000 -Djava.awt.headless=true -jar ${OWLTOOLS_JAR}"

mkdir -p $CACHEDIR

$OWLTOOLS \
	$ROOTOWL_URL \
	--slurp-import-closure \
	-d $CACHEDIR \
	-c $CATALOG \
	> $CACHEDIR/mirror.log

echo ""
echo ""
cat $CACHEDIR/mirror.log
