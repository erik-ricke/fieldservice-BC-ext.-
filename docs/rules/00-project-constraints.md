# Critical Project Constraints

These rules keep the app ready for AppSource from day one. Rework after the fact is expensive, so follow them on every change.

## 1. Affix
* **Current affix:** `DEF` (placeholder). The official affix is reserved with Microsoft for the publisher. When it is assigned, rename all objects in one go and update `AppSourceCop.json`.
* **Rule:** Every object name starts with the affix followed by a space and the feature short name, e.g. `DEF FS Work Order Header`.
* **Also prefix:** fields added in table extensions, controls and actions added in page extensions, enum values added in enum extensions, permission sets and profiles.
* **Enforcement:** `AppSourceCop.json` contains `"mandatoryAffixes": ["DEF"]`, so a missing affix is a build error.
* ✅ `codeunit 50116 "DEF FS Work Order Item Mgt"`
* ❌ `codeunit 50116 "Work Order Item Mgt"`, ❌ `"DEF_FS Work Order Item Mgt"`

## 2. Object IDs
* **Main app:** `50100` to `50189` (as in `app.json`).
* **Test app:** `50190` to `50200`.
* Per-tenant extensions must stay in `50000..99999`. An AppSource app needs its own range from Microsoft (1,000,000+), which means renumbering before submission.
* Before creating an object, check the existing files so the ID is not taken in either app.

## 3. Code Analyzers
* `al.codeAnalyzers` in `.vscode/settings.json` contains `${CodeCop}`, `${UICop}`, `${PerTenantExtensionCop}` and `${AppSourceCop}`.
* Everything AppSourceCop reports would make AppSource validation fail. Fix it; do not hide it.
* The only exception is `fieldservice.ruleset.json`: it downgrades the AppSource listing rules (AS0051, AS0052, AS0084, AS0092) to **Warning** so per-tenant builds work. Never set a rule to `None`, and do not add rules to the ruleset without a written justification.
* The build must finish with **0 errors and no new warnings**.

## 4. No Hardcoded Values
* No customer names, company names (e.g. `'06 LP Holding'`), project numbers, URLs or tenant-specific values in AL code.
* Configurable values go into a setup table (`DEF FS Setup`). Default values written once by install code are allowed if they can be changed in setup afterwards (e.g. the default No. Series `FS-WO`).
* Demo or sample data lives in resource files (`resources/*.json`), never in code.

## 5. Secrets
* Never store credentials, tokens or API keys in table fields.
* Use `IsolatedStorage` (scope `Company` or `Module`) and the `SecretText` type, as for the TimeTrack credentials.

## 6. Extending Business Central
* Extend standard behavior only through published events and event subscribers.
* Do not copy or replace standard procedures. When inserting, modifying or deleting standard records, run their triggers (`Insert(true)`, `Modify(true)`, `Delete(true)`).
* Publish your own `IntegrationEvent`s at decision points so other apps can extend this one (e.g. `OnBeforeIsTransitionAllowed`).

## 7. Dependencies
* The main app may depend on Microsoft apps only.
* A dependency on another per-tenant extension blocks AppSource. Only the test app may depend on the main app.

## 8. Environment
* **Target:** Business Central 27.0 or later, runtime `16.0`.
* Open `fieldservice-BC-ext/al.code-workspace`, not a parent folder. Put the cursor in a file of the main app before pressing F5.
