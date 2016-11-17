# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring

# ./checkMirror.sh [ro|monarch|hp] # Default is ro

ROOTOWL="${1:-ro}"
if [ "$ROOTOWL" == 'hp' ]; then
	ROOTOWL_URL='http://purl.obolibrary.org/obo/hp.owl'
fi
if [ "$ROOTOWL" == 'monarch' ]; then
	ROOTOWL_URL='http://purl.obolibrary.org/obo/upheno/monarch.owl'
fi
if [ "$ROOTOWL" == 'ro' ]; then
	ROOTOWL_URL='http://purl.obolibrary.org/obo/ro.owl'
fi
echo "ROOTOWL: $ROOTOWL"
echo "CACHEDIR: $CACHEDIR"
echo "ROOTOWL: $ROOTOWL"
echo "ROOTOWL_URL: $ROOTOWL_URL"

export CACHEDIR=`pwd`/$ROOTOWL-cached/
export CATALOG=./catalog.xml
export OWLTOOLS_JAR="/opt/owltools/OWLTools-Runner/bin/owltools-runner-all.jar"
export OWLTOOLS="java -Xms3000m -Xmx5500m -DentityExpansionLimit=4086000 -Djava.awt.headless=true -jar ${OWLTOOLS_JAR}"

$OWLTOOLS \
	--catalog-xml $CACHEDIR/$CATALOG \
	$ROOTOWL_URL \
	> $CACHEDIR/check.log

grep 'from: http:' $CACHEDIR/check.log > $CACHEDIR/uncached.log

echo ""
echo "# Complete log"
cat $CACHEDIR/check.log
echo ""
echo ""
echo ""
echo "# Uncached entries"
cat $CACHEDIR/uncached.log
echo ""
echo ""
echo ""
