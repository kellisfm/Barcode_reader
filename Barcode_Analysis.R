#Assignment 4 script. 
#Kai Ellis, 20019803
#Github link: https://github.com/kellisfm/Barcode_reader

#library for this script:
library(BiocManager)
library(sangerseqR)
#this code cannot run if seqinr is loaded too early, this ensures its removed
detach("package:seqinr", unload=TRUE)

#This script will: 
#1 Extract and call the sequence from an .ab1 file
#2 Use regex to slice, paste and extract the Primary Seq (use paste() or [[]])
#3 Convert to FASTA
#4 loop through every .ab1 and do steps 1-3, saving the output as a vector of strings
#5 Use the barcodeplatestats csv to cut any seq that fail QC
#6 dont commit any files in data, but commit everything else. only upload R script to onq.

#Import the barcode stats for later
QC=read.csv("data/BarcodePlateStats.csv")

#by subsetting into ok==true, we now only have data for passing tests, and by using the $chromatagram line
#we get the file names off all the tests where ok was true
QCpass=subset(QC, Ok==TRUE)
QCpass=QCpass$Chromatogram

#this creates a test string that will search for any of the trials that had ok set to true
Test=paste(QCpass, collapse = "|")

#list.files creates a list of all files with a file name ending in ab1
#path chooses the file the files come from. pattern forces only files with a name that ends in .ab1
#this allows looping through all the files in a folder through the use of lapply
files=list.files(path="data", pattern="*.\\.ab1", full.names=TRUE, recursive=FALSE)

#lapply applies a function to everything in a list, we can use it to extract all the file names along with
#all of the file sequences by running two different functions.

#the first run of lapply simply checks to see if the file we're looking at is one of the ones where ok==T
#if yes it returns that file's name, else it returns a null
PrimaryNames=lapply (files, function(x){
  Pass=grepl(Test,basename(x) ) 
  
  if(Pass==TRUE){ ReadFile=read.abif(x)
  Readable=sangerseq(ReadFile)
  Seq1=paste(basename(x))
  }
  
})

#the second run of lapply simply also checks to see if the file we're looking at is one of the ones where ok==T
#if yes it returns the file's primary sequence, else it returns a null
PrimarySeq=lapply (files, function(x){
  Pass=grepl(Test,basename(x) ) 
  
  if(Pass==TRUE){ ReadFile=read.abif(x)
  Readable=sangerseq(ReadFile)
  Seq1=paste(Readable@primarySeq)
  }
})

#the above setup returns 2 lists of 38 values, but 5 of them are null as their dna test was not ok==true
#we can remove the null slots from the lists with the following commands.
NoNullNames=PrimaryNames[-which(sapply(PrimaryNames, is.null))]
NoNullSeq=PrimarySeq[-which(sapply(PrimarySeq, is.null))]


#now that we have an list of names and sequences we can instal seqinr for a fasta conversion
library(seqinr)
write.fasta(NoNullSeq,NoNullNames,"Barcode.Fasta",as.string = TRUE)

