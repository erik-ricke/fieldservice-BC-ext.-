# Object Name Length

## Rule
Object names must not be longer than **30 characters, including the affix and the space after it**.

## Explanation
- **Why:** Business Central limits object names to 30 characters. The compiler rejects longer names.
- **Budget:** With the affix `DEF FS ` (7 characters), 23 characters remain for the actual name.
- **Renaming the affix later:** If the official affix is longer than `DEF`, the remaining budget shrinks. Keep names short enough to leave room.

## Examples

### ✅ Correct
```al
table 50100 "DEF FS Work Order Header"      // 24 characters
page 50119 "DEF FS Job Completion Dialog"   // 28 characters
codeunit 50116 "DEF FS Work Order Item Mgt" // 26 characters
```

### ❌ Incorrect
```al
table 50100 "DEF FS Work Order Header Configuration"   // 38 characters
page 50101 "DEF FS Customer Master Data Management"    // 38 characters
```

## Best Practices
- Use common abbreviations: `Mgt`, `Setup`, `Entry`, `Line`, `Templ.`.
- Leave out words that repeat the object type, such as "Table", "Page" or "Codeunit".
- Prefer clarity over completeness.
