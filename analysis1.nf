//define parameters (can be seen like keys from python dictionaries)
//you can afterwards change the parameters when running the command
params.out = "${projectDir}/output" //this parameter defines the output directory by default
params.temp = "${projectDir}/downloads"
params.downloadURL = "https://tinyurl.com/cqbatch1" //this one defines a downloadURL by default


// code the processes
process downloadFile {
	// storeDir is a temporary folder where you store  
	storeDir params.temp
	// publishDir is the directory where the output has to be saved, you can create a directory "output" beforehand
	// usually use always absolute paths 
	// you can use projectDir, which is the working folder
	// if you want to use this variable "projectDir" you have to write it like this:
	// publishDir "${projectDir}/output/", mode: "copy", overwrite: true
	// publishDir "/home/muellerlui/abi_2025_nextflow/output/", mode: "copy", overwrite: true
	// publishDir params.out, mode: "copy", overwrite: true

	// define the output, if you want to save it somewhere
	output:
		path "batch1.fasta" // this is what is important for others

	// What should the worker do?
	// download a file from the downloadURL and name it batch1.fasta
	""" 
	wget ${params.downloadURL} -O batch1.fasta 	
	"""
}
process countSeqs {
	//publishDir "/home/muellerlui/abi_2025_nextflow/output/", mode: "copy", overwrite: true
	publishDir params.out, mode: "copy", overwrite: true

	input: //Where does the worker before me put their things
		path fastafile
	
	// define the output, if you want to save it somewhere
	output:
		path "numseqs.txt"
	
	// What should the worker do?
	// takes the fastafile from input count the lines and put it into numseqs.txt
	"""
	grep ">" ${fastafile} | wc -l > numseqs.txt
	"""
}
process splitFasta {
	publishDir params.out, mode: "copy", overwrite:true

	input:
		path fastafile
	
	output:
		path "seq_*.fasta"
	
	"""
	 split --lines=2 -d --additional-suffix=.fasta ${fastafile} "seq_"
	"""

	
}

//here define the workflow
workflow {
	downloadChannel = downloadFile()
	countSeqs(downloadChannel)
	splitFasta(downloadChannel)
	// you can also write it in pipes: downloadFile | countSeqs
	// pipes only work if you do not need the output of one process for more than 1 other process as input
}
