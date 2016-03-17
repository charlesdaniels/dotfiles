#!/bin/bash
SYNC="unison -auto"

$SYNC /tank/cad/Documents 	/home/cad/Documents
$SYNC /tank/cad/Audio 	  	/home/cad/Audio
$SYNC /tank/cad/Images		/home/cad/Images
$SYNC /tank/cad/Literature	/home/cad/Literature
$SYNC /tank/cad/Videos 	    /home/cad/Videos
sshfs -o Port=22 cad@cad.noip.me:/ /ds
$SYNC /ds/cad/ /tank/cad 
sudo umount /ds
