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
files=list.files(path="data", pattern="*.\\.ab1", full.names=TRUE, recursive=FALSE)

#Import the barcode stats for later
QC=read.csv("data/BarcodePlateStats.csv")

QCpass=subset(QC, Ok==TRUE)
QCpass=QCpass$Chromatogram
Test=paste(QCpass, collapse = "|")

#lapply applies a function to all the files in a folder, in this case it reads them, converts them to 
#a readable form, and then pastes the primary sequence into a vector. some Regex FASTA still needs to be added

PrimaryNullVec= lapply (files, function(x){
  Pass=grepl(Test,basename(x) ) 
  
  if(Pass==TRUE){ ReadFile=read.abif(x)
  Readable=sangerseq(ReadFile)
  
  #this line merges the filename and the primary sequence into one string
  Seq1=paste(basename(x),Readable@primarySeq)
  
  #regex to finish converting to FASTA, > added along with a \n for a line break. .ab1 removed from title for ease of reading
  Seq1=gsub("^",">",Seq1)
  Seq1=gsub(".ab1 ",".ab1 \n", Seq1)
  Seq1=gsub("$","\n\n", Seq1)
}
})
PrimaryVec=PrimaryNullVec[-which(sapply(PrimaryNullVec, is.null))]
PrimaryVec


