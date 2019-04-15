# Partion Extraction using Hive CLI
Genereate Hive add and drop partition statements by extracting location details from Hive Metastore

## Pre-requisites
1.Hive CLI Installed in environment with required user access to hive metastore
	a.show paritions
	b.descrive formatted
2.Access to create and drop files in /tmp/ location

## Ouput
Output file will be generated in /tmp/ location and will be echo'ed before program terminates.

## Assumption
1.My requirement to develop this script was to get partition location for my source tables from production environment and re-create partitions in development environment to develop ETL logic.
2.DevOps could also use this script if they want to sync hive metastore across environments.
