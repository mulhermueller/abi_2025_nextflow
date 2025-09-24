process downloadFile {
	// publishDir is the directory where the output has to be saved, you can create a directory "output" beforehand
	// usually use always absolute paths 
	// you can use projectDir, which is the working folder
	// if you want to use this variable "projectDir" you have to write it like this:
	// publishDir "${projectDir}/output/", mode: "copy", overwrite: true
	publishDir "/home/muellerlui/abi_2025_nextflow/output/", mode: "copy", overwrite: true
	output:
		path "batch1.fasta" // this is what is important for others
	// What should the worker do?
	""" 
	wget https://tinyurl.com/cqbatch1 -O batch1.fasta 	
	"""
}
process countSeqs {
	// count the lines and put it into a file (numseq.txt)
	publishDir "/home/muellerlui/abi_2025_nextflow/output/", mode: "copy", overwrite: true
	input: //Where does the worker before me put their things?
		path fastafile
	output:
		path "numseqs.txt"
	"""
	grep ">" ${fastafile} | wc -l > numseqs.txt
	"""
}

workflow {
	downloadChannel = downloadFile()
	countSeqs(downloadChannel)
}
