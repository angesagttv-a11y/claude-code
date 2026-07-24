# Workplace-Setup-Toolkit (Graphify + Obsidian + Claude Code)

Ausführbares, anonymisiertes Toolkit, um die in
[`../workplace-graphify-obsidian-setup.md`](../workplace-graphify-obsidian-setup.md)
beschriebene Struktur lokal aufzusetzen.

> **Wichtig:** Dieses Repo ist ein Backup-/Sync-Mechanismus. Das Skript läuft
> **lokal auf deinem Rechner** gegen deinen echten Workplace - nicht hier in
> der Sandbox. Alle echten Pfade gibst du als Flags an; nichts davon wird ins
> Repo committet.

## Inhalt

| Datei | Zweck |
|---|---|
| `../../scripts/setup-graphify-workplace.sh` | Idempotenter Bootstrap (graphify + obsidian-skills + Templates) |
| `templates/graphifyignore.template` | Vorlage für `.graphifyignore` in einem Code-Root |
| `templates/PROJEKT.md` | Vorlage für den Projektanker in `10_AKTIV/<Projekt_X>/` |
| `templates/projekt-uebersicht.md` | Vorlage für die Vault-Übersichtsnotiz in `10_PROJEKTE/<Projekt_X>/` |

## Voraussetzungen

- `uv` ([Installation](https://docs.astral.sh/uv/))
- `git`
- Obsidian-Vault einmal in Obsidian geöffnet (damit `.obsidian/` existiert),
  bevor du Vault-Skills installierst.

## Verwendung

Repo lokal klonen/pullen, dann z.B.:

```bash
# Erst ansehen, was passieren würde (schreibt nichts):
./scripts/setup-graphify-workplace.sh \
    --vault     "$HOME/Workplace/Obsidian" \
    --code-root "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/mein-projekt" \
    --platform claude --platform codex \
    --dry-run

# Dann echt ausführen (--dry-run weglassen):
./scripts/setup-graphify-workplace.sh \
    --vault     "$HOME/Workplace/Obsidian" \
    --code-root "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/mein-projekt" \
    --platform claude --platform codex
```

Danach im Code-Root den Graphen erzeugen:

```bash
cd "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/mein-projekt"
/graphify .
```

## Sicherheits-Leitplanken (im Skript erzwungen)

- Pfade mit `30_PRIVAT` / `PRIVAT` werden abgelehnt.
- Bestehende Dateien werden nie überschrieben (idempotent, "skip if exists").
- Obsidian-Skills landen **nur** vault-lokal (`<vault>/.claude/skills/`),
  nicht global.
- Graphify zeigt immer auf einen einzelnen Code-Root, nie auf den ganzen
  Workplace.

## Flags

| Flag | Bedeutung |
|---|---|
| `--vault <pfad>` | Wurzel des Obsidian-Vaults |
| `--code-root <pfad>` | Code-Root für Graphify (`.graphifyignore` + `graphify-out/`) |
| `--platform <name>` | Agenten-Plattform (mehrfach: `claude`, `codex`, `gemini`, ...) |
| `--skip-graphify` | graphify-Installation überspringen |
| `--skip-obsidian-skills` | Obsidian-Skills nicht installieren |
| `--dry-run` | Nur anzeigen, nichts schreiben |
