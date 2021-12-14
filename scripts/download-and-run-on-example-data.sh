#!/usr/bin/env bash

###############################################################################
#
#   Example MAPP workflow run:
#   * download test data
#   * set up the environment
#   * prepare configuration files
#   * initiate local run in conda envs
#
#   AUTHOR: Maciej_Bak
#   AFFILIATION: University_of_Basel
#   AFFILIATION: Swiss_Institute_of_Bioinformatics
#   CONTACT: maciej.bak@unibas.ch
#   CREATED: 13-10-2021
#   LICENSE: Apache_2.0
#
###############################################################################

echo "### Downloading test dataset ###"
wget https://zenodo.org/record/5772967/files/MAPP_test_data.tar.gz

echo "### Extracting test dataset ###"
tar -xzf MAPP_test_data.tar.gz
rm -rf MAPP_test_data.tar.gz

echo "### Adjusting configuration template ###"
MAPP_directory=$(pwd)

# Specify absolute paths to all the test data:
sed -i '23s|""|"'$MAPP_directory'"|'  MAPP_test_data/config_template.yml
genomic_annotation=${MAPP_directory}/MAPP_test_data/Homo_sapiens.GRCh38.87.chr21.gtf
sed -i '26s|""|"'$genomic_annotation'"|'  MAPP_test_data/config_template.yml
genomic_sequence=${MAPP_directory}/MAPP_test_data/Homo_sapiens.GRCh38.dna.chromosome.21.fa
sed -i '35s|""|"'$genomic_sequence'"|'  MAPP_test_data/config_template.yml
genomic_index=${MAPP_directory}/MAPP_test_data/GRCh38_STAR_index_hsa105
sed -i '41s|""|"'$genomic_index'"|'  MAPP_test_data/config_template.yml
analysis_design_table=${MAPP_directory}/MAPP_test_data/design_table.tsv
sed -i '44s|""|"'$analysis_design_table'"|'  MAPP_test_data/config_template.yml
PWM_directory=${MAPP_directory}/MAPP_test_data/PWMS
sed -i '48s|""|"'$PWM_directory'"|'  MAPP_test_data/config_template.yml
seqlogo_directory=${MAPP_directory}/MAPP_test_data/SEQLOGOS
sed -i '52s|""|"'$seqlogo_directory'"|'  MAPP_test_data/config_template.yml
PAS_atlas=${MAPP_directory}/MAPP_test_data/polyAsiteAtlas2.chr21.bed
sed -i '55s|""|"'$PAS_atlas'"|'  MAPP_test_data/config_template.yml

#echo "### Building conda env for MAPP workflow ###"
source $CONDA_PREFIX/etc/profile.d/conda.sh
conda env remove --name mapp
bash scripts/create-conda-environment.sh
conda activate mapp

echo "### Setting up configuration file for MAPP workflow ###"
python scripts/create-main-config-file.py \
--config-template MAPP_test_data/config_template.yml \
--pipeline-configfile configs/config.yml

#echo "### Initiating MAPP workflow ###"
bash execution/run.sh \
--configfile configs/config.yml \
--environment local  \
--technology conda