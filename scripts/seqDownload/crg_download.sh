#$ -S /bin/bash


# FUNCTION
Help()
{
   # Display Help
   echo
   echo "Syntax: crg_Download [-c|-u|-o|-h]"
   echo "options:"
   echo "c     Number of dirs to cut when downloading CRG repository."
   echo "o     Path to download CRG sequences."
   echo "u     Your user-login to CRG's repository"
   echo "k     Your password-login/key to CRG's repository"
   echo "h     Print this Help."
   echo
}

# Define possitional arguments
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--cut-dirs)
      CUTDIRS="$2"
      shift # past argument
      shift # past value
      ;;
    -u|--user)
      USER="$2"
      shift # past argument
      shift # past value
      ;;
    -k|--key)
      KEY="$2"
      shift # past argument
      shift # past value
      ;;
    -o|--out-dir)
      OUTDIR="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help) 
      echo Help Page: ; exit ;;
      --) shift; break ;;
      *) echo "error: $1"; exit 1;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

# < TODO: This may wont work. Tesr required >
TOCUT="${CUTDIRS:-0}"
if [ $KEY ]; 
then
  PASSW=$(echo "--password ${KEY}") 
else
  PASSW=''
fi

# < TODO: test required after update >
# DOWNLOAD SEQUENCES
echo "DOWNLOADING FILES FROM CRG REPO..."
wget -r --no-parent -R "index.html" -nH $TOCUT \
        -A fastq.gz,tar.gz,txt \
        -P $OUTDIR \
        --user $USR \
        $PASSW \
        $SITE
