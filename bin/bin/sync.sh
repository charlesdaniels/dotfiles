#!/bin/bash
SYNCCOMMAND="unison -auto"
SOLPATH='ssh://cad@cad.noip.me/'
LOCALTANK='/tank'

$SYNCCOMMAND /tank/cad/Documents            /home/cad/Documents
$SYNCCOMMAND /tank/cad/Audio                /home/cad/Audio
$SYNCCOMMAND /tank/cad/Images               /home/cad/Images
$SYNCCOMMAND /tank/cad/Literature           /home/cad/Literature
$SYNCCOMMAND /tank/cad/Videos               /home/cad/Videos
$SYNCCOMMAND $SOLPATH/cad/Documents         /home/cad/Documents 
$SYNCCOMMAND $SOLPATH/cad/Audio             /home/cad/Audio 
$SYNCCOMMAND $SOLPATH/cad/Images            /home/cad/Images 
$SYNCCOMMAND $SOLPATH/cad/Literature        /home/cad/Literature
$SYNCCOMMAND $SOLPATH/cad/Videos            /home/cad/Videos 
$SYNCCOMMAND $SOLPATH/cad                   $LOCALTANK/cad
$SYNCCOMMAND $SOLPATH/Archive/Backups       $LOCALTANK/Archive/Backups
$SYNCCOMMAND $SOLPATH/Archive/Distros       $LOCALTANK/Archive/Distros
$SYNCCOMMAND $SOLPATH/Archive/Landing       $LOCALTANK/Archive/Landing
$SYNCCOMMAND $SOLPATH/Archive/Software      $LOCALTANK/Archive/Software
$SYNCCOMMAND $SOLPATH/Archive/Stuff         $LOCALTANK/Archive/Stuff
$SYNCCOMMAND $SOLPATH/Archive/toolkit       $LOCALTANK/Archive/toolkit 
$SYNCCOMMAND $SOLPATH/video/Movies          $LOCALTANK/plex/Movies
$SYNCCOMMAND $SOLPATH/video/Music           $LOCALTANK/plex/Music
$SYNCCOMMAND $SOLPATH/video/TV              $LOCALTANK/plex/TV
