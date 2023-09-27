# clone immcantation repository
git clone https://bitbucket.org/kleinstein/immcantation.git
export PATH=~/immcantation/scripts:$PATH
# clone dandelion repository
git clone https://github.com/zktuong/dandelion.git

# Download and extract IgBLAST
wget ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/1.21.0/ncbi-igblast-1.21.0-x64-linux.tar.gz
tar -zxf ncbi-igblast-1.21.0-x64-linux.tar.gz
export PATH=~/ncbi-igblast-1.21.0/bin:$PATH
# Download and extract BLAST
wget https://ftp.ncbi.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.14.1+-x64-linux.tar.gz
tar -zxf ncbi-blast-2.14.1+-x64-linux.tar.gz
export PATH=~/ncbi-blast-2.14.1+/bin:$PATH
# Download reference databases and setup IGDATA directory
# just in case, can remove  dandelion/container/database/igblast and dandelion/container/database/germlines
bash fetch_igblastdb.sh -o dandelion/container/database/igblast
cp -r ncbi-igblast-1.21.0/internal_data dandelion/container/database/igblast
cp -r ncbi-igblast-1.21.0/optional_file dandelion/container/database/igblast
# Build IgBLAST database from IMGT reference sequences
bash fetch_imgtdb.sh -o dandelion/container/database/germlines/imgt
bash imgt2igblast.sh -i dandelion/container/database/germlines/imgt -o dandelion/container/database/igblast
# use makeblastdb on the 2 fasta files in dandelion/container/blast
makeblastdb -dbtype nucl -parse_seqids -in dandelion/container/database/blast/human/human_BCR_C.fasta
makeblastdb -dbtype nucl -parse_seqids -in dandelion/container/database/blast/mouse/mouse_BCR_C.fasta
# create singularity image
cd dandelion/container
sudo singularity build --notest sc-dandelion.sif sc-dandelion.def
sudo singularity test --writable-tmpfs sc-dandelion.sif
