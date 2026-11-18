"""Build the release zip in dist/ from the repo root.   python tools/package.py [version]"""
import os
import sys
import zipfile

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
FILES = ["Install PDA sounds.cmd", "Restore my old sounds.cmd", "Uninstall.cmd", "windows-scheme.ps1", "LICENSE"]


def main():
    ver = sys.argv[1] if len(sys.argv) > 1 else "dev"
    name = "STALKER-PDA-Sounds-Windows"
    os.makedirs(os.path.join(ROOT, "dist"), exist_ok=True)
    zpath = os.path.join(ROOT, "dist", f"{name}-{ver}.zip")
    with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED) as z:
        for f in FILES:
            z.write(os.path.join(ROOT, f), f"{name}/{f}")
        readme = open(os.path.join(ROOT, "tools", "README.txt"), encoding="ascii").read()
        z.writestr(f"{name}/README.txt", readme.replace("\r\n", "\n").replace("\n", "\r\n"))
        for f in sorted(os.listdir(os.path.join(ROOT, "sounds"))):
            z.write(os.path.join(ROOT, "sounds", f), f"{name}/sounds/{f}")
    print(f"{zpath}  ({os.path.getsize(zpath) // 1024} KB)")


if __name__ == "__main__":
    main()
