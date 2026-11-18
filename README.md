# S.T.A.L.K.E.R. PDA Sounds for Windows

Make Windows chirp like a PDA from the Zone. New notifications get the *"new message"* beep, warnings get the objective ping and errors get the SOS. Plug in a USB stick and it sounds like something landing in your backpack.

**[⬇ Download the latest release](../../releases/latest)** (about 1 MB, Windows 10 and 11)

> [!NOTE]
> **This is not a program.** It's a Windows sound scheme: a folder of `.wav` files plus a short script that points Windows' own sound settings at them. Nothing runs in the background and nothing gets installed into Windows. It needs no admin rights, collects nothing and has no network access. If you'd rather not run a script at all, you can [set it up by hand](#doing-it-by-hand) in a couple of minutes.

## Using it

1. Download `STALKER-PDA-Sounds-Windows-*.zip` from [Releases](../../releases/latest) and unzip it anywhere.
2. Double-click **`Install PDA sounds.cmd`**.

| File | What it does |
|---|---|
| `Install PDA sounds.cmd` | Saves your current sounds, then switches to the PDA ones |
| `Restore my old sounds.cmd` | Switches back to exactly what you had before |
| `Uninstall.cmd` | Switches back and removes everything it added |

After installing, you can delete the unzipped folder, because the sounds have been copied to `%USERPROFILE%\Media\STALKER PDA`.

Both **S.T.A.L.K.E.R. PDA** and **My sounds (before PDA)** also show up as schemes in Windows' Sound dialog, so you can switch there or swap single sounds whenever you like.

> [!TIP]
> If Windows shows **"Windows protected your PC"**, click **More info** > **Run anyway**. Windows shows this for any script downloaded from the internet. The `.cmd` files are one line each, and all the work happens in [`windows-scheme.ps1`](windows-scheme.ps1), which is about 100 commented lines. Have a read first if you like.

## What plays where

| Windows event (as named in the Sound dialog) | Sound | File |
|---|---|---|
| Notification, System Notification, Instant Message, New Mail, New Text Message, Desktop Mail | PDA news | `pda_news.wav` |
| Default Beep, Asterisk, Question | PDA tip | `pda_tip.wav` |
| Exclamation, Calendar Reminder | PDA objective | `pda_objective.wav` |
| Critical Stop, Critical Battery Alarm | PDA SOS | `pda_sos.wav` |
| Alarm 1, Low Battery Alarm | PDA alarm | `pda_alarm.wav` |
| Alarm 2 | Bomb timer | `bomb_timer.wav` |
| Incoming Call | Radio call | `radio_call.wav` |
| Device Connect / Disconnect / Failed to Connect | Inventory slot / drop / locked door | `inv_slot.wav` / `inv_drop.wav` / `door_locked.wav` |
| Windows User Account Control | Power switch | `power_switch.wav` |
| NFP Completion, NFP Connection, Message Nudge | Anomaly detector contact | `contact_1.wav` |
| Print Complete | Multiplayer reward | `mp_reward.wav` |

Every other event keeps the sound you already had.

The `sounds` folder also has a few spares you can set yourself: a Geiger click (`geiger_3`), artefact detector beeps (`art_beep1`, `da-2_beep1`), and inventory open, close and item-info sounds (`inv_open`, `inv_close`, `inv_properties`).

## Doing it by hand

This is all the script does, and Windows has a built-in dialog for it:

1. Copy the `sounds` folder somewhere it can stay, for example `Documents\STALKER PDA`. Windows plays the files from wherever you put them.
2. Open the Sound dialog. Press <kbd>Win</kbd>+<kbd>R</kbd>, type `mmsys.cpl` and press Enter, then open the **Sounds** tab.
   - Windows 11: Settings > System > Sound > **More sound settings** > **Sounds**.
   - Windows 10: Settings > System > Sound > **Sound Control Panel** > **Sounds**.
3. Pick an event under **Program Events**, click **Browse…**, choose a `.wav` from the table above and click **Test** to hear it.
4. Repeat for as many events as you like, then click **Save As…** to keep the result as a named scheme. Click **OK**.

To undo it, pick your old scheme (or **Windows Default**) from the **Sound Scheme** list.

## For the curious

- The script works only under `HKEY_CURRENT_USER\AppEvents\Schemes`, which is where Windows keeps sound schemes. It adds two schemes there and changes nothing else.
- The original game sounds are in [`tools/src`](tools/src). [`tools/build.py`](tools/build.py) turns them into the wavs: it evens out the volume, because the detector beeps are very quiet in-game, and adds a short pause after the call and alarm sounds so they don't loop back to back. It needs ffmpeg.
- [`tools/package.py`](tools/package.py) builds the release zip.
- You can change which sound goes where by editing `$map` near the top of `windows-scheme.ps1` and running the install again. Pull requests with better mappings are welcome.

## Credits

All sounds are from **S.T.A.L.K.E.R.: Call of Pripyat** by GSC Game World. If you haven't played it, go and do that:
[GOG](https://www.gog.com/en/game/stalker_call_of_pripyat) · [Steam](https://store.steampowered.com/app/41700/)

**Fan-made, not affiliated with GSC Game World. S.T.A.L.K.E.R. © GSC Game World.** This is free, non-commercial and will stay that way.

## License

The scripts are [MIT](LICENSE). The sounds belong to GSC Game World and are not covered by that license. They're shared here as non-commercial fan content.
