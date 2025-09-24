process downloadFile {
	// publishDir is the directory where the output has to be saved, you can create a directory "output" beforehand
	publishDir "/home/muellerlui/abi_2025_nextflow/output/", mode: "copy", overwrite: true
	output:
		path "batch1.fasta" // this is what is important for others
	// What should the worker do?
	""" 
	wget https://tinyurl.com/cqbatch1 -O batch1.fasta 	
	"""
}
workflow {
downloadFile()
}
