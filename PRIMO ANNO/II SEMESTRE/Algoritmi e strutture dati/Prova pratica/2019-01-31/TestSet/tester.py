#!/usr/bin/python3


'''
*************************************************************************

	INFO:
	With this script you will be able to run fast all the scripts of 
	a testset for "Algoritmi e Strutture dati" at University of Pisa


	USAGE:
	Put this script and the program you made in cpp inside
	the testset folder and run:

	python3 tester.py ./nameOfYourScript
	(where tester.py is the name of this script)

	HOW IT WORKS:
	It runs for every input in the folder:

	./yourScript < input.txt | diff - output.txt

	IMPORTANT:
	Make sure you have installed python3 on your machine,
	for Ubuntu or debian you can do this with:

	sudo apt get install python3

*********************************************************************

'''



import glob, os, sys

os.chdir("./")
for file in glob.glob("*.txt"):
	if ("input" in file):
		output = file.replace("input", "output")
		program = sys.argv[1]
		os.system("{} < {} | diff - {}".format(program, file, output))
