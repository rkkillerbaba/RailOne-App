# irctc — Android mod workspace

Ye folder **Cline** (VS Code AI agent) ke saath Android APK / mod kaam ke liye set up kiya gaya hai.
Setup ke waqt folder khaali tha — abhi yahan koi app source ya Gradle project nahi hai.

## Quick start

1. VS Code mein ye folder kholo (`/sdcard/My Mod Apk/irctc`)
2. Cline panel → **⚙️ Settings** → **API Provider = `Cline`** → **Sign In** → **`FREE` tag** wala model chuno
3. Agent ko chhota task do, e.g.
   *"`bash scripts/check-env.sh` chalao aur batao kaun se tools missing hain"*

## Commands (yaad rakhne layak)

| Kaam | Command |
|---|---|
| Tools ka status | `bash '/sdcard/My Mod Apk/irctc/scripts/check-env.sh'` |
| Command + reliable output capture | `bash '/sdcard/My Mod Apk/irctc/scripts/agent-cmd.sh' 'ls -la' list-files` |
| Upar wale command ka log | `/tmp/cline-out/last.txt` (aur `/tmp/cline-out/<label>.txt`) |

> `/sdcard` par exec bit reliable nahi hota, isliye scripts ko `./x.sh` ki jagah **`bash x.sh`** se chalao.

## Kya-kyun (files)

| File | Kaam |
|---|---|
| `.vscode/settings.json` | Terminal reliability tuning; APK/DEX/JAR search+explorer se bahar |
| `.vscode/extensions.json` | `saoudrizwan.claude-dev` (Cline) + Gradle extension recommend |
| `.clineignore` | Binaries + secrets Cline ke context se bahar |
| `.clinerules/` | Project/environment, terminal quirks, workflow, safety rules |
| `scripts/agent-cmd.sh` | Output-capture helper (flaky shell integration ka workaround) |
| `scripts/check-env.sh` | Available/missing tools ka read-only report |
| `.gitignore` | APK/keystore/build output git se bahar |

## Abhi jo missing hai

`node`, `npm`, `apktool`, `jadx`, `zipalign`, `apksigner`, `adb` — install commands (verified)
aur poora setup guide: **[CLINE-SETUP.md](CLINE-SETUP.md)**.
