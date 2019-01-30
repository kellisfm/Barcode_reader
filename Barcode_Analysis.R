#Assignment 4 script. 
#Kai Ellis, 20019803
#Github link: https://github.com/kellisfm/Barcode_reader

#library for this script:
library(BiocManager)
library(sangerseqR)

#This script will: 
#1 Extract and call the sequence from an .ab1 file
#2 Use regex to slice, paste and extract the Primary Seq (use paste() or [[]])
#3 Convert to FASTA
#4 loop through every .ab1 and do steps 1-3, saving the output as a vector of strings
#5 Use the barcodeplatestats csv to cut any seq that fail QC
#6 dont commit any files in data, but commit everything else. only upload R script to onq.

#list.files creates a list of all files with a file name ending in ab1
#path chooses the file the files come from. pattern forces only files with a name that ends in .ab1
#this allows looping through all the files in a folder
files <- list.files(path="data", pattern="*.\\.ab1", full.names=TRUE, recursive=FALSE)

#lapply applies a function to all the files in a folder, in this case it reads them, converts them to 
#a readable form, and then pastes the primary sequence into a vector. Regex FASTA still needs to be added
lapply (files, function(x) {
  ReadFile <- read.abif(x)
  Sequence=sangerseq(ReadFile)
  paste(SeQ1@primarySeq)
  
})
Quality=read.csv("Data/BarcodePlateStats.csv")
