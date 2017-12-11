#!/bin/sh

PAYARA_REPO="https://github.com/payara/Payara_PatchedProjects/raw/master"
REPOSITORY_ID="release"
REPOSITORY_URL="http://artifactory.lapsa.tech/artifactory/ext-release-local/"

download() {
	local FILE="$1"
	local URL="$2"
	curl -L -f -o $FILE $URL || { echo "Failed to download $FILE from $URL"; exit 1; }
}

cachePayaraLib() {
	local groupId="$1"
	local artifactId="$2"
	local version="$3"

	echo ""
	echo "Processing \"$groupId:$artifactId:$version\"..."
	echo ""

	local JAR="$artifactId-$version.jar"
	local POM="$artifactId-$version.pom"

	local JAR_URL="$PAYARA_REPO/${groupId//\./\/}/$artifactId/$version/$artifactId-$version.jar"
	local POM_URL="$PAYARA_REPO/${groupId//\./\/}/$artifactId/$version/$artifactId-$version.pom"

	test -f $JAR || download $JAR $JAR_URL
	test -f $POM || download $POM $POM_URL

	mvn deploy:deploy-file \
		-DpomFile=$POM \
		-Dfile=$JAR \
		-DrepositoryId=$REPOSITORY_ID \
		-Durl=$REPOSITORY_URL

}


PERSISTENCE_GROUP_ID="org.eclipse.persistence"
PERSISTENCE_VERSION="2.6.4.payara-p2"

cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.antlr" $PERSISTENCE_VERSION #1
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.asm" $PERSISTENCE_VERSION #2
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.core" $PERSISTENCE_VERSION #3
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.dbws" $PERSISTENCE_VERSION #4
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.jpa.jpql" $PERSISTENCE_VERSION #5
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.jpa.modelgen.processor" $PERSISTENCE_VERSION #6
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.jpa" $PERSISTENCE_VERSION #7
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.moxy" $PERSISTENCE_VERSION #8
cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.oracle" $PERSISTENCE_VERSION #9
#cachePayaraLib $PERSISTENCE_GROUP_ID "org.eclipse.persistence.sdo" $PERSISTENCE_VERSION ?? # no such artifact