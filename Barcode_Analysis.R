#Assignment 4 script. 
#Kai Ellis, 20019803
#Github link: https://github.com/kellisfm/Barcode_reader

#library for this script:
library(BiocManager)

#This script will: 
#1 Extract and call the sequence from an .ab1 file
#2 Use regex to slice, paste and extract the Primary Seq (use paste() or [[]])
#3 Convert to FASTA
#4 loop through every .ab1 and do steps 1-3, saving the output as a vector of strings
#5 Use the barcodeplatestats csv to cut any seq that fail QC
#6 dont commit any files in data, but commit everything else. only upload R script to onq.