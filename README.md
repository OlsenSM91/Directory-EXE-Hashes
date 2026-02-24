# Directory EXEs to SHA256 Hash

<img width="835" height="785" alt="Screenshot 2026-02-24 093104" src="https://github.com/user-attachments/assets/299fa042-c6fc-478d-a6a4-bfe39e7ef578" />

A small PowerShell terminal tool that scans a directory for `.exe` files, calculates SHA256 hashes, prints the hashes one per line, and can optionally copy the results to your clipboard.

- Company: Computer Networking Solutions Inc.
- Author: Steven Olsen
- GitHub: https://github.com/OlsenSM91
- Version: 0.1

---

## What it does

- Prompts you to enter a target directory (press Enter to use the current directory).
- Optionally includes subfolders.
- Calculates SHA256 for every `.exe` it finds.
- Outputs only the hash values, separated by normal line breaks.
- Optionally copies the hash list to clipboard as CRLF-separated text.

---

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- `Get-FileHash` available (built-in)
- Clipboard copy requires a Windows host with `Set-Clipboard` available

---

## Usage

### Run locally

1. Save the script as `exehashes.ps1`
2. Run it:

```powershell
.\exehashes.ps1
````

You will be prompted for:

* Directory path
* Include subfolders (y/N)
* Copy to clipboard (y/N)

---

### Run remotely (one-liner)

Host `exehashes.ps1` somewhere accessible over HTTPS, then run:

```powershell
irm https://pathto.script/exehashes.ps1 | iex
```

Notes:

* Using `irm | iex` will execute whatever is returned from that URL.
* Only do this from a source you control and trust.

---

## Output format

The script prints hashes only:

```text
E2277FC72ADF717CD0E5CB0BCC4B45DB8944468A46FDD9B2DCE77A16C394C57F
B51F7BD66C6EA7E21255D78EFB530F360AD8357AF804B498B9927893474D3B44
...
```

If clipboard copy is enabled, the hashes are copied as a CRLF-separated list, ready to paste into tickets, emails, or IoC lists.

---

## Common use cases

* Verifying binary integrity across systems
* Building allow/deny lists
* Comparing vendor drop folders during installs/upgrades
* Quick triage when you suspect tampering

---

## Security note

This script hashes files, it does not execute them. Still:

* Treat directories with untrusted binaries carefully.
* If you use `irm | iex`, host the script on infrastructure you control and use HTTPS.

---

## Troubleshooting

### “Path not found”

* Ensure the folder exists and you have access.
* If the path contains special characters, paste it as-is. The script uses `-LiteralPath`.

### Clipboard copy didn’t work

* `Set-Clipboard` may not be available in non-Windows environments.
* Disable clipboard copy when prompted, or run on a Windows host.

---

## License

Internal tool - set a license if you plan to distribute publicly.
