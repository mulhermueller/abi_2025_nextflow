//define parameters (can be seen like keys from python dictionaries)
//you can afterwards change the parameters when running the command
params.out = "${projectDir}/output" //this parameter defines the output directory by default
params.temp = "${projectDir}/downloads"
params.downloadURL = "https://tinyurl.com/cqbatch1" //this one defines a downloadURL by default


// code the processes
process downloadFile {
	// storeDir is a temporary folder where you store  
	storeDir params.temp
	output:
		path "batch1.fasta" // this is what is important for others
	// What should the worker do?
	// download a file from the downloadURL and name it batch1.fasta
	""" 
	wget ${params.downloadURL} -O batch1.fasta 	
	"""
}

process splitSeqs {
	//publishDir params.out, mode: "copy", overwrite:true
	input:
		path fastafile
	output:
		path "seq_*.fasta"
	"""
	 split --lines=2 -d --additional-suffix=.fasta ${fastafile} "seq_"
	"""
}

process countRepeats{
	//publishDir params.out, mode: "copy", overwrite:true
	input:
		path fastafile
	output:
		path "${fastafile.getSimpleName()}_repeatcount.txt"
		// .getSimpleName() removes the extension of a file
	"""
	grep -o "GCCGCG" ${fastafile} | wc -l > ${fastafile.getSimpleName()}_repeatcount.txt
	"""
}

process makeSummary {
	publishDir params.out, mode: "copy", overwrite:true
	input:
		path inputfile
	output:
		path "summary.csv"
	"""
	for f in \$(ls seq*count.txt); do echo -n "\$f, "; cat \$f; done >summary.csv
	"""
}

//here define the workflow
workflow {
	downloadFile | splitSeqs | flatten | countRepeats | collect | makeSummary
}
