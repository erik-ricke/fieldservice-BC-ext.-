# AL Coding Standards

## 1. File Naming
CodeCop rule AA0215 expects the **full object name without spaces or special characters**, followed by the object type: `<ObjectNameWithoutSpaces>.<ObjectType>.al`.

| Object | File name |
| :--- | :--- |
| `table 50100 "DEF FS Work Order Header"` | `DEFFSWorkOrderHeader.Table.al` |
| `page 50103 "DEF FS Mobile Order Card"` | `DEFFSMobileOrderCard.Page.al` |
| `codeunit 50126 "DEF FS Status Mgt"` | `DEFFSStatusMgt.Codeunit.al` |
| `enum 50101 "DEF FS Order Status"` | `DEFFSOrderStatus.Enum.al` |
| `tableextension 50130 "DEF FS Item"` | `DEFFSItem.TableExt.al` |
| `pageextension 50131 "DEF FS Item Card"` | `DEFFSItemCard.PageExt.al` |
| `permissionset 50111 "DEF FS MOBILE"` | `DEFFSMOBILE.PermissionSet.al` |

## 2. Mandatory Properties
- **ApplicationArea:** Set `ApplicationArea = All;` on every visible page field, part and action, even when the page also sets it. `#All` is not valid AL syntax.
- **ToolTip:** Mandatory for all page fields and actions. Format: "Specifies ..." for fields, a verb for actions ("Opens ...", "Creates ...").
- **DataClassification:** Set on all normal table fields (default `CustomerContent`, technical fields `SystemMetadata`). Not allowed on FlowFields and FlowFilters.
- **Caption:** Never empty. Do not use the legacy `CaptionML` property.

## 3. Syntax Rules
- **No implicit with:** Always qualify fields (`Rec.Status`, never `Status`).
- **Enums, not Options:** Also for page variables (e.g. a dialog's result).
- **No magic numbers:** Do not pass enum ordinals around as integers; use the enum type.
- **Actions:** Use `area(Promoted)` with `actionref`. The `Promoted`, `PromotedCategory`, `PromotedOnly` and `PromotedActionCategories` properties are deprecated.
- **Variable order:** Declare Record, Report, Codeunit, XmlPort, Page, Query variables first, in that order (AA0021).

## 4. Labels and Translation
- Every user-facing text in `Message`, `Error`, `Confirm` and `StrSubstNo` is a `Label`, never a string literal.
- Labels with placeholders need a `Comment` that explains every placeholder: `Comment = '%1 = work order number, %2 = status'`.
- Technical strings that must not be translated (keys, codes, file names, format strings) are labels with `Locked = true`.
- Write source texts in **English**. German comes from the translation file.
- The `TranslationFile` feature is enabled. The compiler writes `Translations/<app name>.g.xlf` (git-ignored) on every build.
- Maintain `Translations/<app name>.de-DE.xlf` and `Translations/<app name>.en-US.xlf`. **Never write XLIFF files by hand:** Business Central matches them by the hashed IDs from the `.g.xlf` (e.g. `Table 2746494384 - Property 2879900210`). Use the "XLIFF Sync" or "NAB AL Tools" extension to sync after text changes.

## 5. Permissions and Lifecycle
- Every object is covered by an assignable `permissionset` object. Current sets:
  - `DEF FS MOBILE`: technicians (work through orders, add material).
  - `DEF FS ADMIN`: office staff and administrators (includes `DEF FS MOBILE`, plus setup and demo data).
- When you add an object, add it to the right permission set in the same change.
- **Install codeunit:** creates the configuration a company needs. No demo or tenant data.
- **Upgrade codeunit:** guard each data migration with an upgrade tag (`codeunit "Upgrade Tag"`) and register the tag in `OnGetPerCompanyUpgradeTags`.
- **New companies:** subscribe to `OnCompanyInitialize` so companies created after the install are set up too.
- Install and upgrade code must be idempotent (safe to run more than once).
