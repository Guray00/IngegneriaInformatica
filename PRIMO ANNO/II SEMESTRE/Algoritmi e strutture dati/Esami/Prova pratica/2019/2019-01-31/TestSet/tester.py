#!/usr/bin/python3


'''
**********************************************************************

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

	If you want to use windows, i raccoment to use WSL
	(Windows' Subsystem for Linux)
                                                   Marco Lampis 2020
********************************************************************

'''



import glob, os, sys
import subprocess

failed = []
program = sys.argv[1]

os.chdir("./")
for file in glob.glob("*.txt"):
	if ("input" in file):
		output = file.replace("input", "output")

		print("==== Testing "+ file, end='');
		os.system("{} < {} | diff - {} > .check.txt".format(program, file, output))
		
		f = open(".check.txt","r")
		check = f.read()
		
		if (check == ''):
			print(" => \033[92mPASSED\033[0m")
		
		else:
			print(" => \033[91mFAILED\033[0m")
			failed.append([file, output])

		os.remove(".check.txt")


	
if (len(failed) != 0):
	print("\n\nYou should check with:")

	for f in failed:
		print(program + ' < ' + f[0] + '| diff - ' + f[1])


