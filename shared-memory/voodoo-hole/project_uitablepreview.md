---
name: Project: UITable System
description: Current state of the UITable system (branch samba/tech/ui/ui-table), what works and what's pending
type: project
---

UITable is a data-driven UGUI scrollable/sortable table with reflection-based binding and virtualized scrolling. Implementation is complete and tested.

**Current state (2026-04-02):**
- All features implemented and committed. Docs up to date.
- Branch: `samba/tech/ui/ui-table`
- Last work: Preview data refactor + UITableEditor split into partial class files.

**Typed cell architecture:**
- `IUITableCell` — non-generic pipeline contract; `SetValue(object value)`.
- `UITableCell<T>` — abstract generic base; explicit interface impl hides `object`; cell authors implement `SetValue(T)`.
- `UITableTextCell<T>` — generic text base (renders via `ToString()`); `UITableTextCell` is the non-generic string alias.
- `UITableRankCell : UITableTextCell<int>` — receives typed int; medal icon logic on top.
- `UITableTeamBadgeCell : UITableCell<TeamBadge>` — demonstrates non-primitive composite type; renders emblem + colored name. `TeamBadge` is a `[Serializable]` struct (Name, Emblem, Color).
- `UITableBooleanCell : UITableCell<bool>`, `UITableImageCell : UITableCell<Sprite>`.

**Sample data (`UITableSampleData`):** Rank, PlayerName, Team (TeamBadge), Score, IsOnline, Avatar. `[Serializable]` class.

**Preview system (refactored):**
- `[SerializeReference] List<object>` stores actual data type instances per row (not per-cell UITableCellValue).
- Requires data type to be a `[Serializable]` class; structs fall back to non-editable placeholders.
- `UITableEditor` Preview section uses `PropertyField` per column member — composite types (TeamBadge) draw as foldouts automatically.
- `UITablePlaceholder.CreateInstance(Type, int)` generates whole instances with placeholder fields.
- `UITableCellValue.cs` and `UITablePreviewRow.cs` deleted.

**UITableEditor split (partial class):**
- `UITableEditor.cs` — core: fields, init, OnInspectorGUI, change dispatch, column detection (~300 lines)
- `UITableEditor.Preview.cs` — DrawPreviewSection, DrawPreviewRow
- `UITableEditor.RuntimeData.cs` — DrawRuntimeDataSection, DrawRuntimeCellField
- `UITableEditor.Helpers.cs` — DrawFoldout, DrawPaginatedRows, GetRowStyle, DrawTwoFieldRow, DrawSpacingRow

**Verified working:**
- Sorting, Edit Mode preview, padding, column width normalization, column spacing, row/column separators, virtualized scrolling (1000 rows), editable preview data (via PropertyField), runtime data Inspector editing, Inspector foldouts, alternating Inspector row backgrounds, TeamBadge composite cell.

**Architecture highlights:**
- `UITableLayoutUtils` — shared static helpers: `PositionRow`, `ComputeContentHeight`, `SetLayerRecursively`.
- `UITablePreview.SyncPreviewData` — no longer needs columns param; syncs data type instances to current row count.
- `UITableEditor` holds `SerializedObject m_previewSO` to draw preview data from UITable's Inspector.
- `DrawPaginatedRows(total, ref page, ref foldouts, Action<int> drawRow)` — shared pagination helper in Helpers file.

**Known limitation:**
- Minor visual misalignment between pagination nav buttons and control buttons in the Inspector — confirmed Unity IMGUI limitation. Accepted as-is.

**Why:** HOL ticket (UITable system), branch `samba/tech/ui/ui-table`.
**How to apply:** Read the plan doc before making changes. Key files: UITable.cs, UITableDataView.cs, UITableRow.cs, UITableHeader.cs, UITablePreview.cs, UITableEditor.cs (+.Preview.cs, .RuntimeData.cs, .Helpers.cs), UITableLayoutUtils.cs, UITablePlaceholder.cs, UITableCell.cs.
