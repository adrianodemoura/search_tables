#!/bin/bash
: '
Este script localiza a tabela e a coluna que possui o texto.
'

# descobrindo o diretório completo
DIR_SCRIPT=${PWD}"/"$(dirname $0)

# parameters
USER='usuario'
PASSWORD='senha'
DATABASE='banco'
TEXTO=$1

if [ ${#TEXTO} = 0 ]; then
	echo "Texto inválido !"
	exit
fi

CONECTION="mysql -u$USER -p$PASSWORD $DATABASE"

TABLES=`$CONECTION -e"SHOW TABLES"`

ARR_TABLES=$(echo $TABLES | tr " " "\n")

for TABLE in $ARR_TABLES
do
	COLUMNS=`$CONECTION -e"SELECT column_name FROM information_schema.columns WHERE table_name='$TABLE' AND table_schema='$DATABASE'" | grep -v 'column_name'`
	
	ARR_COLUMNS=$(echo $COLUMNS | tr " " "\n")
	
	for COLUMN in $ARR_COLUMNS
	do
		RES=`$CONECTION -e"SELECT * FROM $DATABASE.$TABLE WHERE $COLUMN LIKE '%$TEXTO%'"`

		if [ ! -z "$RES" ]; then
			echo "achei em $TABLE na coluna $COLUMN"
		fi
	done
done
