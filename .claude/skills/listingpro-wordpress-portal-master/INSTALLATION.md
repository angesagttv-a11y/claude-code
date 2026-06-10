# Installation: listingpro-wordpress-portal-master

## Persönliche Installation in Claude Code

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
