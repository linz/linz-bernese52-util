# Script to install LINZ Bernese 5.2 utilities 
#
# Currently provides GETDATA and CREATABB
# 
# Also provides the configuration for GETDATA in the datapool.  
#

all: 

# Seem to need a dependency in install for debuild to work

install: all
	mkdir -p ${DESTDIR}/opt/bernese52
	cp -r bernese/* ${DESTDIR}/opt/bernese52/
	mkdir -p ${DESTDIR}/etc/bernese52
	cp -r etc/* ${DESTDIR}/etc/bernese52/
	mkdir -p ${DESTDIR}/usr/bin
	cp bin/* ${DESTDIR}/usr/bin
	mkdir -p ${DESTDIR}/var/lib/bernese52/datapool/
	cp datapool/* ${DESTDIR}/var/lib/bernese52/datapool/

