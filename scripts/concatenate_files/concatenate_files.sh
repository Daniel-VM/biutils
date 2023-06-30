#!/bin/bash

## FIX:
##      - This script must be adapted to the HPC environment and must be generalized to be executed elsewere
##



## THIS SCRIPT CAN BE USED TO CONCATENATE FASTQ.GZ FILES BY IDENTICAL SAMPLE IDS.

## SET CONFIG VARS
SOURCEDIR="$(dirname -- "$(realpath -- ./bin/concatenate_files.sh)")"
BASEDIR="$(dirname ${SOURCEDIR})"
OUTDIR=$BASEDIR/tmp_concat
CONCATDIR1=$BASEDIR/Pendientes_de_concatenar/Concat_parte_1
CONCATDIR2=$BASEDIR/Pendientes_de_concatenar/Concat_parte_2

## LOOP THOUGHT FILES THAT REQUIRE CONCATENATION
for i in $CONCATDIR2/*fastq.gz; do

	FILENAME="$(basename -- $i)"
        BASENAME="$(echo "${FILENAME}" | awk -F '.' '{print $1}')"
	SAMPLEID="$(echo "${BASENAME}" | awk -F '_' '{print $1}')"
	cat ${CONCATDIR1}/${FILENAME} ${CONCATDIR2}/${FILENAME} > ${OUTDIR}/${SAMPLEID}_concat.fastq.gz
	echo " ${BASENAME} done"
done
