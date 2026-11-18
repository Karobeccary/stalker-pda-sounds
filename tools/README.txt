S.T.A.L.K.E.R. PDA SOUNDS FOR WINDOWS 10 / 11
==============================================

Your PC beeps like a Zone PDA. Notifications get the "new message" chirp, warnings
get the objective ping, errors get the SOS, plugging in a USB stick sounds like
dropping something in your backpack, and so on. The sounds come from
S.T.A.L.K.E.R.: Call of Pripyat.

Project page: https://github.com/Karobeccary/stalker-pda-sounds


HOW TO USE
----------
  Install PDA sounds.cmd      switches Windows to the PDA sounds
  Restore my old sounds.cmd   switches back to what you had before
  Uninstall.cmd               switches back and removes everything

The installer first saves your current sounds as a scheme called "My sounds
(before PDA)", then adds "S.T.A.L.K.E.R. PDA" as a scheme that keeps any sound it
doesn't replace. You can also switch between the two in Control Panel > Sound >
Sounds > Sound Scheme, and change single sounds there.

It needs no admin rights. It only touches your own user's sound settings, and it
copies the sounds to %USERPROFILE%\Media\STALKER PDA, so you can delete this
folder after installing.

If Windows shows "Windows protected your PC" when you run a .cmd file, click
"More info" > "Run anyway". The scripts are plain text if you want to read them
first: windows-scheme.ps1 does all the work.


WHAT PLAYS WHERE
----------------
  Notifications, mail, IM, SMS ............ PDA news
  Default beep, info, question ............ PDA tip
  Warning (exclamation), reminders ........ PDA objective
  Error (critical stop), critical battery . PDA SOS
  Alarm, low battery ...................... PDA alarm  (Alarm 2: bomb timer)
  Incoming call ........................... radio call
  Device connected / removed / failed ..... inventory slot / drop / locked door
  UAC prompt .............................. power switch
  Proximity, nudge ........................ anomaly detector contact
  Print complete .......................... multiplayer reward

The "sounds" folder also has a few spare Zone sounds (Geiger click, artefact
detector beep, inventory open/close and so on) that you can set yourself in the
Sound control panel.


CREDITS
-------
Fan-made, not affiliated with GSC Game World; S.T.A.L.K.E.R. (c) GSC Game World.
Free, non-commercial. Sounds are from the original game.
Scripts are MIT licensed (see LICENSE); the sounds belong to GSC Game World.

Get the game, it's great:
  GOG    https://www.gog.com/en/game/stalker_call_of_pripyat
  Steam  https://store.steampowered.com/app/41700/
