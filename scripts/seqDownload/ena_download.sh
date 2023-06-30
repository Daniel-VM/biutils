#!/usr/bin/env bash
# < TODO: add help page >

# Define possitional arguments
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -sdrf|--sdrf-file)
      SDRF="$2"
      shift # past argument
      shift # past value
      ;;
    -o|--out-dir)
      OUT_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters
# Run  script
# STEP 1 - GET FIELD == Comment[FASTQ_URI]
awk -v col='Comment[FASTQ_URI]' 'BEGIN{FS="\t"} NR==1{for(i=1;i<=NF;i++){if($i==col){c=i;break}} print $c} NR>1{print $c}' $SDRF | \
    awk '{if (NR!=1) {print}}' > ${OUT_DIR}/tmp_enaRUN_idList.txt

# STEP 2 - DOWNLOAD ENA FASTQ FILE FROM FTPSITE
TMPFTPLIST=${OUT_DIR}/tmp_enaRUN_idList.txt
while read -r ftpsite; do
    echo "Processing ... ${ftpsite}"
    wget -A .fastq.gz -P $OUT_DIR $ftpsite
done < $TMPFTPLIST

# REMOVE TMPFILES
rm $TMPFTPLIST
