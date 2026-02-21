# How to Use as a Central Framework

The `_New_Book_Starter_Kit` is a central "library" that your book projects link to. When you update a module, **all** linked projects automatically get the improvement.

## Quick Start: New Project

```bash
mkdir MyNewBook && cd MyNewBook
bash /mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/init_book.sh
```

This creates your project with:
- **Symlinks** for `modules/` and `.vale/` (auto-updating from the kit)
- **Copies** of template files you'll customize (CLAUDE.md, GEMINI.md, etc.)
- **Infrastructure files** that stay synced to the kit
- A **manifest** (`.sync/manifest.json`) tracking everything

## Updating an Existing Project

```bash
cd MyExistingBook
bash update_book.sh
```

The update script:
1. Verifies symlinks are intact
2. Auto-updates infrastructure files (PROJECT_COMPENDIUM.md, review prompts, reference docs)
3. Shows diffs for project-owned files so you can merge changes manually
4. Detects new files added to the kit
5. Updates the manifest with the new kit version

## File Classification

Every file falls into one of these categories:

### Linked (auto-updating)
These are symlinks pointing to the kit. Changes to the kit are instantly visible.
- `modules/` — All writing constraint modules
- `.vale/` — Vale linting styles

**Project-specific modules** (like `_PROJECT_RULES.md`) should go in the project root or a `local_modules/` directory, not inside the symlinked `modules/` folder.

### Sync-Always (infrastructure)
These are copies that `update_book.sh` overwrites automatically. They contain no project-specific content.
- `PROJECT_COMPENDIUM.md`
- `MASTER_BOOK_REVIEW_PROMPT.md`
- `CONTINUITY_AUDIT_PROMPT.md`
- `GEMINI_REVIEW.md`
- `reference/collaboration_workflow.md`
- `reference/CENTRAL_FRAMEWORK_SETUP.md`
- `reference/MODEL_SELECTION_GUIDE.md`
- `reference/art_brief.md`
- `reference/KDP_BOOK_FORMATTING_SKILL.md`

### Project-Owned (yours to customize)
These start as copies of kit templates but become project-specific. `update_book.sh` will **never overwrite** them automatically — it shows diffs and asks.
- `CLAUDE.md` — Writer role, active modules, project-specific rules
- `GEMINI.md` — QA role, thesis, session history
- `PROJECT_IDENTITY.md` — Title, genre, tone, audience
- `TODO.md` — Project task tracking
- `README.md` — Project onboarding
- `CHANGELOG.md` — Project history
- `.gitignore` — Project ignore rules
- `.claude/settings.local.json` — Claude permissions
- `.gemini/settings.json` — Gemini settings
- `context/` — Facts sheet, writer voice
- `manuscript/` — All content
- `output/` — Compiled outputs
- `research/` — Sources and reviews
- `visuals/` — Diagrams, figures, generated art

## The Manifest

Every project has `.sync/manifest.json` which records:
- `kit_version` — Which kit version the project was created from / last synced to
- `kit_path` — Where the kit lives on disk
- `project_id` — Unique project identifier
- `created` / `last_sync` — Timestamps
- `files` — Classification of every file

## Retrofitting an Existing Project

If you have a project that was created before this system:

1. Create `.sync/manifest.json` (copy from kit, fill in project_id and dates)
2. Replace your `modules/` directory with a symlink:
   ```bash
   # Back up any project-specific modules first!
   mv modules/_PROJECT_RULES.md ./local_modules/_PROJECT_RULES.md
   rm -rf modules
   ln -s /mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/modules ./modules
   ```
3. Copy `update_book.sh` from the kit
4. Run `bash update_book.sh` to verify everything
