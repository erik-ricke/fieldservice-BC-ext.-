# Architecture & Folder Structure

## 1. Repository Layout (AL-Go)
```
fieldservice-BC-ext/
├── al.code-workspace          ← open this in VS Code
├── .AL-Go/settings.json       ← appFolders / testFolders for CI
├── docs/rules/                ← these project rules
├── fieldservice BC app/       ← main app
│   ├── app.json
│   ├── AppSourceCop.json
│   ├── fieldservice.ruleset.json
│   ├── resources/             ← JSON resource files (e.g. demo data)
│   ├── src/<Feature>/         ← AL objects, grouped by feature
│   └── Translations/
└── fieldservice BC app.Test/  ← test app
    ├── app.json
    └── src/
```

## 2. Namespace Strategy
- Every AL file declares a `namespace` at the top.
- The namespace follows the folder: a file in `src/WorkOrders/` uses `namespace DEF.FieldService.WorkOrders;`.
- Test objects use `namespace DEF.FieldService.Test;`.
- Reference standard objects with `using` statements (e.g. `using Microsoft.Inventory.Item;`).

## 3. Folder Organization (Feature-Based)
- **Don't:** group files by object type (`src/Tables/`, `src/Pages/`).
- **Do:** group files by feature or domain. `src/WorkOrders/` contains the tables, pages and codeunits for work orders.

## 4. Separation of Concerns
- **Tables:** data, field validation, and record-level behavior (number series, cascade delete).
- **Pages:** display only. Actions call one codeunit procedure, then `CurrPage.Update(false)`.
- **Codeunits:** all business logic, one responsibility each. Example: every status change goes through `DEF FS Status Mgt`, never `Rec.Status := ...` in a page.
- **Dialogs:** a `StandardDialog` page collects input and returns it through getter procedures. The calling codeunit validates and applies it.

## 5. Extending Business Central
- Integrate with standard behavior through published events and event subscribers.
- Keep subscribers small and delegate to focused codeunits.
- Do not replace standard posting routines or change standard behavior directly.
