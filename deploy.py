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
catagoryModeRules.append(['tmux'  ,'overwrite'])
catagoryModeRules.append(['lib'   ,'overwrite'])
catagoryModeRules.append(['bin'   ,'overwrite'])
catagoryModeRules.append(['config','overwrite'])

# file path rules 
filePathRules = [] # [catagory, path under $HOME, dir or file]
filePathRules.append(['lib'   ,'lib'       ,'dir' ])
filePathRules.append(['bin'	  ,'bin'       ,'dir' ])
filePathRules.append(['bashrc','.bashrc'   ,'file'])
filePathRules.append(['tmux'  ,'.tmux.conf','file'])

modules = []
userInput = ''
files = [] 

print("building file listing...")
for root, directories, filenames in os.walk("./"): # generate file listing
	for directory in directories:
		pass # we dont care about directories
	for filename in filenames:
		if '.git' not in filename: # prevent a whole pile of warnings of deploy was installed from git
			if '.git' not in root:
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
	
	home = os.getenv('HOME')

	# make backups of existing files
	print("backing up existing files...")
	for rule in filePathRules:
		if rule[2] == 'file':
			if os.path.isfile(os.path.join(home,rule[1])):
				print("found existing file",rule[1])
				try:
					shutil.copy(os.path.join(home,rule[1]), os.path.join(home,'.'+rule[1]+'.bak'))
				except FileExistsError:
					os.remove(os.path.join(home,'.'+rule[1]+'.bak'))
					shutil.copy(os.path.join(home,rule[1]), os.path.join(home,'.'+rule[1]+'.bak'))
		else:
			if os.path.isdir(os.path.join(home,rule[1])):
				print("found existing dir",rule[1])
				try:
					shutil.copytree(os.path.join(home,rule[1]), os.path.join(home,'.'+rule[1]+'.bak'))
				except FileExistsError:
					shutil.rmtree(os.path.join(home,'.'+rule[1]+'.bak'))
					shutil.copytree(os.path.join(home,rule[1]), os.path.join(home,'.'+rule[1]+'.bak'))
			else:
				os.mkdir(os.path.join(home,rule[1]))
	print("done")
	for module in modules:
		if module['install'] == 'yes':
			print(module['name'], "marked for installation")
			rule = 'nil'
			for r in filePathRules:
				if r[0] == module['catagory']:
					rule = r
			if rule[2] == 'file':
				if module['mode'] == 'append':
					targetFile = open(os.path.join(home,rule[1]), 'a')
					sourceFile = open(module['path'])
					targetFile.write("# generated during dotfile deployment\n")
					for line in sourceFile:
						targetFile.write(line)
					targetFile.write('\n')
					targetFile.close() 
					sourceFile.close()
				else:
					try:
						os.remove(os.path.join(home,rule[1]))
					except FileNotFoundError:
						pass 
					shutil.copy(module['path'], os.path.join(home, rule[1]))
			elif rule[2] == 'dir':
				if module['mode'] == 'append':
					targetFile = os.path.join(home,rule[1],module['name'])
					sourceFile = open(module['path'])
					targetFile.write("# generated during dotfile deployment\n") 
					for line in sourceFile:
						targetFile.write(line)
					target.write('\n')
					targetFile.close()
					sourceFile.close()
				else:
					try:
						os.remove(os.path.join(home,rule[1],module['name']))
					except FileNotFoundError:
						pass
					shutil.copy(module['path'],os.path.join(home,rule[1]))
	print("commit finished")

# main interface loop	
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
	
