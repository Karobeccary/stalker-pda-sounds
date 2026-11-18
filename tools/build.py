"""Rebuild ../sounds/*.wav from the original game oggs in src/.

Peak-normalises everything to -1 dB (the detector beeps are very quiet in-game) and adds
a short gap after the looping ones (incoming call, alarm) so they breathe between repeats.
Needs ffmpeg on PATH.   python tools/build.py

src/ holds the untouched files from S.T.A.L.K.E.R.: Call of Pripyat
(gamedata/sounds/device, sounds/detectors, sounds/interface).
"""
import os
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "src")
OUT = os.path.join(HERE, "..", "sounds")
GAP = {"radio_call": 1.4, "pda_alarm": 0.5}


def peak(path):
    r = subprocess.run(["ffmpeg", "-hide_banner", "-i", path, "-af", "volumedetect", "-f", "null", "-"],
                       capture_output=True, text=True)
    for line in r.stderr.splitlines():
        if "max_volume:" in line:
            return float(line.split("max_volume:")[1].split()[0])
    return 0.0


def main():
    os.makedirs(OUT, exist_ok=True)
    for f in sorted(os.listdir(SRC)):
        stem, ext = os.path.splitext(f)
        if ext.lower() != ".ogg":
            continue
        src = os.path.join(SRC, f)
        af = f"volume={-1.0 - peak(src):.1f}dB"
        if stem in GAP:
            af += f",apad=pad_dur={GAP[stem]}"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", src, "-af", af,
                        "-c:a", "pcm_s16le", "-ar", "44100", os.path.join(OUT, stem + ".wav")], check=True)
        print("  " + stem)


if __name__ == "__main__":
    main()
