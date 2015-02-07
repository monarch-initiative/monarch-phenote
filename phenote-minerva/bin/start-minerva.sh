#!/bin/bash
set -e
# Any subsequent commands which fail will cause the shell script to exit immediately

## Change for different max memory settings 
MINERVA_MEMORY="512M"
## Default Minerva Port
MINERVA_PORT=6800

## start Minerva
# use catalog xml and PURLs
java "-Xmx$MINERVA_MEMORY" -jar m3-server.jar \
-c ../../examples/catalog-v001.xml \
-g ../../examples/minerva-importer.owl \
-f "$HOME"/owlData \
--port $MINERVA_PORT
