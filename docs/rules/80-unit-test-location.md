# Unit Test Location

## Rule
Write tests for all business logic and put them in the test app `fieldservice BC app.Test`, next to the main app folder. The test app is registered in `.AL-Go/settings.json` under `testFolders` so CI runs it.

## Structure
```
fieldservice BC app.Test/
├── app.json
└── src/
    ├── DEFFSTestLibrary.Codeunit.al        ← asserts and test data helpers
    ├── DEFFSStatusMgtTests.Codeunit.al
    ├── DEFFSWorkOrderTests.Codeunit.al
    ├── DEFFSDemoDataTests.Codeunit.al
    ├── DEFFSTechnicianTests.Codeunit.al
    └── DEFFSWorkTimeTests.Codeunit.al
```

## Naming Conventions
- **Test codeunit:** `"DEF FS <Area> Tests"`, file `DEFFS<Area>Tests.Codeunit.al` (CodeCop AA0215).
- **IDs:** `50190` to `50200`.
- **Test procedures:** `[MethodName]_[Scenario]_[ExpectedResult]`, e.g. `SetStatus_OpenToDone_ThrowsError`.

## Test Codeunit Example
```al
codeunit 50190 "DEF FS Status Mgt Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";
        StatusMgt: Codeunit "DEF FS Status Mgt";

    [Test]
    procedure SetStatus_OpenToDone_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        // Arrange
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);

        // Act
        asserterror StatusMgt.SetStatus(WorkOrderHeader, WorkOrderHeader.Status::Done);

        // Assert
        TestLibrary.ExpectedError('cannot change from status');
    end;
}
```

## Test App Configuration (app.json)
```json
{
  "name": "fieldservice BC app Test",
  "publisher": "erik",
  "dependencies": [
    {
      "id": "0610ff26-67ba-4c2a-8848-fb13b643466a",
      "name": "fieldservice BC app",
      "publisher": "erik",
      "version": "1.3.0.0"
    }
  ],
  "idRanges": [ { "from": 50190, "to": 50200 } ]
}
```
The old `"test": "x.x.x.x"` property is obsolete; do not use it.

## Guidelines
- **Separation:** The main app never references the test app. The test app is never deployed to production.
- **Independence:** Each test creates its own data and does not rely on other tests or on the company's setup (e.g. `UseNewWorkOrderNoSeries` creates a dedicated number series).
- **Asserts:** The test app uses its own `DEF FS Test Library`, so it compiles without the Test Toolkit symbols. Microsoft's `Library Assert` may be used instead once the toolkit symbols are available.
- **Coverage:** Focus on codeunits with decisions, calculations and validations. Every bug fix gets a test that would have caught it.
- **Language:** Error-text assertions compare English texts, so tests run in an `en-US` environment (the AL-Go default).
