# Project instructions

## Git workflow
- Changes go to `main`. When a task is done, commit it, merge it into `main` (fast-forward if possible) and push `main`.
- If you have to work in a worktree or feature branch, merge it into `main` at the end and push. Do not leave feature branches or open pull requests behind unless asked.
- Build both apps (main app with all analyzers, test app) before merging. Never force-push.

## Feature workflow
- Build one feature at a time. When several features are requested, do not start the next one on your own.
- After each feature (built, committed and merged into `main`), write to the user in German:
  1. **What changed and how:** the new and changed objects (fields, pages, codeunits, permissions, translations) and the reasoning behind important decisions and behavior changes.
  2. **Step-by-step test guide in Business Central:** which page to open (search term or role center), what to set up first (e.g. setup, resources, users), which actions to click and which values to enter, and what result to expect at each step, including the error cases.
- Then stop and wait for the user's OK. Only start the next feature after the user has confirmed it.
- Stay on the current feature until the user says "weiter". Keep messages short: a few bullets for the explanation, and the test guide in small parts (one part per message, a few steps each). Wait for the user's feedback before sending the next part.
- The user tests on a Windows PC (browser), an iPad and an Android smartphone (Business Central app). Say which device a step is meant for, and mention where things look different on tablet and phone (e.g. actions behind "…", fewer columns in lists).

## Project rules
Read the relevant files in `docs/rules/` before changing AL code (affix, object IDs, coding standards, translations, tests).
