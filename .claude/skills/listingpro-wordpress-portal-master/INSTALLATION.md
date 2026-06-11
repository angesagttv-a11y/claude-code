# Installation: listingpro-wordpress-portal-master

## Quickstart (Install-Skript)

```bash
# 1) Skill-Repo holen (einmalig)
git clone https://github.com/angesagttv-a11y/claude-code.git ~/Downloads/claude-code-skill
cd ~/Downloads/claude-code-skill

# 2) Skill personal installieren (landet in ~/.claude/skills/)
chmod +x install-listingpro-skill.sh
./install-listingpro-skill.sh

# 3) In dein Campus-Sparbuch-Projekt wechseln und Claude Code starten
cd "/Users/jessenikoi/Local Sites/campus-sparbuch-dev/app/public"
claude
```

`install-listingpro-skill.sh` kopiert den Skill standardmäßig nach `~/.claude/skills/listingpro-wordpress-portal-master`. Für eine projektbezogene Installation kann ein abweichendes Zielverzeichnis als erstes Argument übergeben werden:

```bash
./install-listingpro-skill.sh "/Users/jessenikoi/Local Sites/campus-sparbuch-dev/app/public/.claude/skills/listingpro-wordpress-portal-master"
```

## Persönliche Installation in Claude Code (manuell)

Kopiere den Ordner `listingpro-wordpress-portal-master` nach:

```bash
~/.claude/skills/listingpro-wordpress-portal-master
```

Claude Code kann den Skill danach für persönliche Aufgaben nutzen.

## Projektbezogene Installation

Für ein Repository oder Projekt kopiere den Ordner nach:

```bash
.claude/skills/listingpro-wordpress-portal-master
```

Diese Variante ist sinnvoll, wenn das Campus-Sparbuch-Projekt direkt im Repository mit seinem Skill-Kontext ausgeliefert werden soll.

## Prüfung

Der Skill wurde mit dem lokalen Skill-Validator geprüft und ist strukturell gültig. Enthalten sind:

| Datei | Zweck |
|---|---|
| `SKILL.md` | Hauptanweisung und Triggerlogik |
| `references/project-context.md` | Campus-Sparbuch-Projektstand, Roadmap, Entscheidungen |
| `references/listingpro-theme-operations.md` | ListingPro-Funktionen, Monetarisierung, Import, Claims, Reviews |
| `references/wp-cli-local-wrapper.md` | Local-WP-CLI-Wrapper und Skriptstandards |
| `references/editorial-standards.md` | Stop-Slop-Schreibregeln |
| `templates/handoff-brief.md` | Übergabevorlage für Claude Cowork |
