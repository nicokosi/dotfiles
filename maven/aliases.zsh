alias mt="mvn test"
alias mvnt=mt
alias mci="mvn clean install"
alias mvnci=mci
alias mcist="mvn clean install -DskipTests"
alias mvncist=mcist
alias mvn-jacoco='mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent verify org.jacoco:jacoco-maven-plugin:report'
alias mvn-update-deps-to-latest-patch='mvn versions:use-latest-versions -DallowAnyUpdates=false -DallowMajorUpdates=false -DallowMinorUpdates=false -DallowIncrementalUpdates=true -DallowSnapshots=false'
