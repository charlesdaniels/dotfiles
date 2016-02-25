#!/usr/bin/osascript
display dialog "Your Administrator Password:" default answer "" with hidden answer
set PWD to text returned of the result
do shell script "sudo kextunload /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext; sudo kextload /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext" user name "your name" password PWD with administrator privileges


