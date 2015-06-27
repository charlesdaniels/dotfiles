#!/usr/bin/python3

# Charles's handy dotfile deployment script 

import os
import sys
import glob
import readline
import shutil

# configuration section
catagoryModeRules = [] # these are the defaults for each catagory
catagoryModeRules.append(['bashrc','append'   ])
catagoryModeRules.append(['lib'   ,'overwrite'])
catagoryModeRules.append(['bin'   ,'overwrite'])
catagoryModeRules.append(['config','overwrite'])


modules = []
userInput = ''
files = [] 

print("building file listing...")
for root, directories, filenames in os.walk("./"): # generate file listing
	for directory in directories:
		pass # we dont care about directories
	for filename in filenames:
		files.append(os.path.join(root,filename))
print("done")

print("indexing modules...")
for module in files:
	if len(module.split("/")) > 2: # make sure our moduels have catagories 
		if len(module.split("/")) > 3:
			print("WARNING:",module," is nested too deeply, I don't know what to do!")
		else:
			modules.append({'name':module.split("/")[2], 'mode':'unset', 'catagory':module.split("/")[1], 'path':module, 'install':'no'})
print("done")

# set the default installation mode
print("applying default catagory mode rules...")
for module in modules:
	if module['mode'] == 'unset': # they should all be unset, but it never huts to be safe! 
		for rule in catagoryModeRules:
			if rule[0] == module['catagory']:
				module['mode'] = rule[1]

print("done")

def help():
	print("- Charles's Dotfile Deployment Script -")
	print("""\nInstalles selected modules by appending or replacing existing files. Any 
modified files to be modified which already exist will be saved as 
.[filename].bak""")
	print("- commands -")
	print("help - displays this message")
	print("list-modules - lists available modules") 
	print("install-module [module name] - marks module for installation. Run again to")
	print("unmark modules")
	print("set-mode [modules name] [mode name] - set module")
	print("installation mode between overwrite or append") 
	print("exit - exits the program") 
	print("commit - performs installation of marked modules")

def listModules():
	# list all detected modules
	print("module listing -",len(modules),"found")
	print("{0:20} {1:20} {2:20} {3:20}".format("name", "catagory", "mode", "install"))
	print("-" * 75)
	for module in modules:
		print("{0:20} {1:20} {2:20} {3:4}".format(module['name'],module['catagory'],module['mode'],module['install']))

def setMode(moduleName, modeName):
	# used to change the mode of the specified module
	for module in modules:
		if module['name'] == moduleName:
			if modeName in ['append','overwrite']:
				module['mode'] = modeName
			else:
				print("ERROR:",modeName,"is not a valid mode. I don't know what to do!")
				
def installModule(moduleName):
	# marks the specified module for installation
	for module in modules:
		if module['name'] == moduleName:
			if module['install'] == 'no':
				module['install'] = 'yes'
			else:
				module['install'] = 'no'
				
def commit():
	# performs module installation
	
	# make backups of existing files
	homeDirectory = os.getenv("HOME")
	print("saving copies of existing files...")
	if os.path.isfile(os.path.join(homeDirectory, '.bashrc')):
		print("found existing .bashrc")
		shutil.copy(os.path.join(homeDirectory, '.bashrc'), os.path.join(homeDirectory, '.bashrc.bak')) 
	if os.path.isdir(os.path.join(homeDirectory, 'bin')):
		print("found existing bin")
		shutil.copy(os.path.join(homeDirectory, 'bin'), os.path.join(homeDirectory, '.bin.bak')) 
	if os.path.isdir(os.path.join(homeDirectory, 'lib')):
		print("found existing bin")
		shutil.copy(os.path.join(homeDirectory, 'lib'), os.path.join(homeDirectory, '.lib.bak')) 
	else:
		os.mkdir(os.path.join(homeDirectory, 'lib'))
	
	for module in modules:
		if module['install'] == 'yes':
			sourceFile = open(module['path'], 'r')
			if module['catagory'] == 'bashrc':
				if module['mode'] == 'append':
					destFile = open(os.path.join(homeDirectory, '.bashrc'), 'a')
				else:
					destFile = open(os.path.join(homeDirectory, '.bashrc'), 'w')
				destFile.write("#Automatically added by deploy.py")
				for line in sourceFile:
					destFile.write(line)
				destFile.close()
			elif module['catagory'] == 'lib':
				if module['mode'] == 'append':
					destFile = open(os.path.join(homeDirectory, 'lib', module['name']), 'a')
				else:
					destFile = open(os.path.join(homeDirectory, 'lib', module['name']), 'w')
				destFile.write("#Automatically added by deploy.py")
				for line in sourceFile:
					destFile.write(line)
				destFile.close()
			else:
				print("ERROR: no rule defined for catagory:", module['catagory'])
	
while(userInput != 'exit'):
	userInput = input("> ")
	if userInput == 'help':
		help()
	elif userInput == 'list-modules':
		listModules()
	elif userInput.split(' ')[0] == 'set-mode':
		try:													# the rstrips here make sure newlines dont interfere with equality checks
			setMode(userInput.split(' ')[1], userInput.split(' ')[2].rstrip('\n').rstrip('\r'))
		except IndexError:
			print("ERROR: too few arguments to call set-mode, doing nothing")
	elif userInput.split(' ')[0] == 'install-module':
		try:
			installModule(userInput.split(' ')[1].rstrip('\n').rstrip('\r'))
		except IndexError:
			print("ERROR: too few arguments to call install-module, doing nothing")
	elif userInput == 'commit':
		commit()
	else:
		print("ERROR: command not found")
	
