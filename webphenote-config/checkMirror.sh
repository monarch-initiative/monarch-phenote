# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring

export CACHEDIR=`pwd`/cached-models
export CATALOG=./catalog.xml
#export OWLTOOLS_JAR="../java/lib/owltools-runner-all.jar"
export OWLTOOLS_JAR="../../owltools/OWLTools-Runner/bin/owltools-runner-all.jar"
export OWLTOOLS="java -Xms3000m -Xmx5500m -DentityExpansionLimit=4086000 -Djava.awt.headless=true -jar ${OWLTOOLS_JAR}"

# export ROOT=http://purl.obolibrary.org/obo/upheno/monarch.owl
export ROOT=http://purl.obolibrary.org/obo/so.owl

$OWLTOOLS \
	--catalog-xml $CACHEDIR/$CATALOG \
	$ROOT \
	> $CACHEDIR/check.log


grep 'from: http:' $CACHEDIR/check.log > $CACHEDIR/uncached.log

echo ""
echo "# Uncached entries"
cat $CACHEDIR/uncached.log
echo ""
echo ""
echo ""
echo ""
echo "# Complete log"
cat $CACHEDIR/check.log
