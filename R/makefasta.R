makefasta<-function(data){
	colnames(data)<-c("names","seqs")
	fasta_obj <- apply(data, 1, function(row) {
  		paste(">", row["names"], "\n", row["seqs"], sep = "")
	})
	fasta_text <- paste(fasta_obj, collapse = "\n")
	temp_file <- tempfile()
	writeLines(fasta_text, temp_file)
	fasta_obj <- read.FASTA(temp_file)
	return(fasta_obj)
}
