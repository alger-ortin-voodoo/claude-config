# Code Generation Rules (detail)

> Overrides the project's Section 4. Read this before writing or editing any C#.
> The slim checklist in `CLAUDE.md` lists the rules; this file carries the full detail + examples.

* **Styling:** Follow code style conventions as established in the project's `.editorconfig` file.
* **Column Limit:** Don't exceed column 100 if possible, but don't break the line for just a couple of words, specially for code instructions! It is a soft limit, not a hard rule. Break a line only when it meaningfully aids readability — long method chains, multiline conditions, or string concatenations are good candidates. Never break a single instruction that runs just a few characters over; keeping it on one line is clearer.
* **Multi-line signatures and calls:** When a method signature or call doesn't fit on one line, put one parameter per line and place the closing parenthesis on its own line (aligned with the opening keyword). Never split parameters arbitrarily across lines. Example:
  ```csharp
  private void MyMethod(
      ParamTypeA paramA,
      ParamTypeB paramB
  )
  ```
* **Naming:** Favor writing clean, human-readable code with descriptive variable and method names.
   * Abstract base classes: Do not use the Base suffix on abstract classes. Follow .NET conventions: name the abstract class after what it is (e.g. Perk, not PerkBase). The IFoo/Foo pattern (interface + abstract class) is idiomatic and preferred.
   * Async methods: Suffix async methods with `Async` following the .NET Task-based Asynchronous Pattern (TAP) convention (e.g. `RunExpiryDelayAsync`). Exception: event handlers (e.g. `OnApplicationPause`) are exempt.
   * Constants: Use PascalCase for `const` and `static readonly` fields, following .NET conventions (e.g. `PersistentDataKey`, not `PERSISTENT_DATA_KEY`).
* **Comments:** Be verbose with comments, writing a brief line before every block of instructions explaining its purpose. As general rule, wherever you would put an empty line to separate blocks of logic, a comment explaining the next block is welcome. Always include an empty line before an inline comment, unless the previous line is an opening brace.
   * Category inline comments (the ones grouping members inside a region, e.g. `// Serialized Fields`, `// Public Properties`, `// External Dependencies`) must be followed **immediately** by the first declaration — **no blank line between the comment and the member it labels**. The blank line goes *before* the category comment to separate it from the previous group, not after. The category comment belongs to the group below it.
     ```csharp
     // ❌ WRONG — redundant blank line between the label and the member it groups
     // Public Properties

     public int Foo { get; }

     // ✅ RIGHT — label sits flush against the group it labels
     // Public Properties
     public int Foo { get; }
     ```
* **XML Headers:** Always add XML Headers to types and methods, but don't include the params, only the summary. Make use of cref when referencing other types, and inheritdoc for inheritances, overrides or multiple signatures of the same method.
   * **Single-line `<summary>` format** (`/// <summary>text</summary>`) is acceptable only for public properties (where a column of short one-liners aids scannability). For types and methods, always use the multi-line form even when the text fits on one line:
     ```csharp
     // ✅ Types and methods — always multi-line
     /// <summary>
     /// Does the thing.
     /// </summary>

     // ✅ Public properties — single-line OK
     /// <summary>Current score.</summary>
     public int Score { get; }
     ```
* Always include `using` statements only for namespaces actually required.
* Wrap code in our project's designated namespace (detect the namespace from surrounding files).
* **Braces on control flow (ZERO TOLERANCE):** Every `if`, `else`, `for`, `foreach`, `while`, `using`, etc. whose body is on the **next line** MUST use braces. No exceptions, no "it's just one statement", no "it's clearer this way". The **only** brace-free form allowed is when the condition and the action fit on the **same line** — typically early returns. It is ok to go **a bit** beyond the column limit to keep them on the same line.

  ```csharp
  // ❌ WRONG — body on next line without braces. Never do this.
  if (data.Rewards.Count > 0)
      m_rewardView.Initialize(data.Rewards[0]);

  // ✅ RIGHT — same line, no braces needed (early-return style).
  if (data.Rewards.Count > 0) m_rewardView.Initialize(data.Rewards[0]);

  // ✅ RIGHT — body on next line, braces required.
  if (data.Rewards.Count > 0)
  {
      m_rewardView.Initialize(data.Rewards[0]);
  }
  ```

  This rule applies to `else`, `else if`, `for`, `foreach`, `while`, and `using` identically. If you catch yourself writing a control-flow keyword followed by `)` at end-of-line and the next line is not `{`, stop and add braces before continuing.

  **Chain consistency:** In an `if` / `else if` / `else` chain, braces are all-or-nothing. If *any* branch needs braces (because its body is on the next line / spans multiple statements), then *every* branch in that chain must use braces too — even the ones whose body would fit on the same line. Never mix braced and brace-free branches within one chain.

  ```csharp
  // ❌ WRONG — mixed: first/last branches brace-free, middle braced. Jarring to read.
  if (reward is RewardCurrency currency) sb.Append(currency.Amount);
  else if (reward is RewardSkin skin)
  {
      string skinId = skin.Skin != null ? skin.Skin.id : "?";
      sb.Append(skinId);
  }
  else sb.Append(reward.GetType().Name);

  // ✅ RIGHT — one branch needs braces, so all branches get braces.
  if (reward is RewardCurrency currency)
  {
      sb.Append(currency.Amount);
  }
  else if (reward is RewardSkin skin)
  {
      string skinId = skin.Skin != null ? skin.Skin.id : "?";
      sb.Append(skinId);
  }
  else
  {
      sb.Append(reward.GetType().Name);
  }
  ```
* **Editor-only literals — do NOT extract to constants (any type):** A value that appears exactly once in Editor-only code (`CustomEditor`, `EditorWindow`, property drawers, `[MenuItem]` utilities) and only drives inspector presentation must stay inline — regardless of its type (string, int, float, `Color`, enum, etc.) and regardless of how "semantic" it feels. The test is **reuse, not meaning**: promote to a `const`/`static readonly` only when the value appears at 2+ call sites, or when it is a genuine shared tunable that multiple parts of the same class read.

  Common false positives — these are all single-use and must stay inline:
  - Per-state label strings (`"Normal"`, `"★"`, `"★★"`)
  - Per-rarity/tier display colors (`new Color(0.35f, 0.65f, 1f)`)
  - Layout sizes used in one place (`GUILayout.Width(40)`, `EditorGUI.indentLevel = 0`)
  - Tooltip / `HelpBox` / `[Header]` text

  "It has a meaningful name" and "sibling values happen to be consts" are explicitly not grounds to extract. If you find yourself writing a `const` for a value that only appears in one `case` branch or one `if` block, stop and leave it inline.

* Always use tabs for indentation.
* **Regions:**
  * Group scripts content in the following regions, whenever it makes sense and following this order: CONSTANTS, AUX TYPES, FIELDS AND PROPERTIES, INITIALIZATION/FINALIZATION, UNITY EVENTS, GETTERS/SETTERS, INTERNAL METHODS, CALLBACKS, DEBUG.
  * Use GETTERS/SETTERS only when the class has multiple simple accessors to group together. Otherwise, group any getter or setter with its related methods in a dedicated, descriptively named region instead.
  * Custom regions should go between GETTERS/SETTERS and CALLBACKS.
  * Unity's Awake, Start, OnEnable, OnDisable and OnDestroy events go in the INITIALIZATION/FINALIZATION region.
  * All regions should be in FULL CAPS and fill the line until column 100 with dashes `-----`.
  * Don't insert empty line between the #region and #endregion tags and the region's content.
  * Inside the FIELDS AND PROPERTIES region, group fields in the following categories (when they make sense), by this order and separated by a single line comment with the category name:
    * Public Properties
    * Serialized Fields — use `[Header("UI Elements (Mandatory)")]` (and similar headers) to label Inspector groups. In subclasses that already inherit serialized fields from a parent, prefix inherited-group headers with **"Additional"** (e.g. `[Header("Additional UI Elements (Mandatory)")]`) to avoid duplicate header labels in the Inspector.
    * Events
    * External Dependencies
    * Internal Collections
    * Internal Vars
  * **Custom thematic category labels are allowed and welcome** when a group of 2+ related fields is significant enough to warrant its own label (e.g. `// Persistence`, `// Cooldowns`, `// Streak Tracking`, `// Debug`). Use them when they aid readability — the standard categories are defaults, not a closed list. A custom label should still slot naturally into the standard order (e.g. a `// Persistence` group of internal vars sits at the end with Internal Vars; a `// Debug` group typically sits last). Avoid one-field "categories" — fold those into a standard category instead.
  * Method placement: Assign methods to regions based on their role, not just their visibility. Private helpers belong in INITIALIZATION/FINALIZATION if they are exclusively called from the constructor or Dispose (e.g. RegisterPerk, ToggleListeners). Use INTERNAL METHODS only for private helpers called from multiple contexts (public API, callbacks, debug). If a group of private methods shares a strong thematic cohesion (e.g. expiry scheduling and cancellation), extract them into their own named region rather than lumping them into INTERNAL METHODS.
* Minimize usage of `var`, prefer explicit type, except when the type is very long or it's already displayed within the same line (e.g. var myService = ServiceLocator.Global.Get<MyService>).
* Always include explicit `private` keyword.
* Always add braces in `case` blocks with more than one line.
* **Reserve `=>` for properties and lambdas, not methods.** Avoid expression-bodied *methods*; prefer a block body with an explicit `return`. Expression-bodied **properties** (`public int Foo => m_foo;`) and lambdas are fine and encouraged. This matters most when the expression is non-trivial (e.g. a `switch` expression): keep the method's `{ ... return x switch { ... }; }` braces — don't collapse the whole method to `=> x switch { ... };`. Trivial one-line proxy methods may use `=>` sparingly, but when in doubt, use a block body.
* **Editor scope pairs:** Any Unity Editor API that uses a `Begin`/`End` scope pattern must have its content wrapped in braces, treating the pair visually like a block. Place `Begin*()` before the opening brace and `End*()` after the closing brace. This applies to — but is not limited to:
  - `EditorGUI.BeginChangeCheck()` / `EndChangeCheck()` — result capture goes after `}`
  - `EditorGUILayout.BeginHorizontal()` / `EndHorizontal()`
  - `EditorGUILayout.BeginVertical()` / `EndVertical()`
  - `EditorGUI.BeginDisabledGroup()` / `EndDisabledGroup()`

  ```csharp
  EditorGUI.BeginChangeCheck();
  {
      // fields drawn here
  }
  bool changed = EditorGUI.EndChangeCheck();

  EditorGUILayout.BeginHorizontal();
  {
      // elements drawn here
  }
  EditorGUILayout.EndHorizontal();

  EditorGUI.BeginDisabledGroup(!isEnabled);
  {
      // controls drawn here
  }
  EditorGUI.EndDisabledGroup();
  ```
  If the result of `EndChangeCheck()` is used outside the block (e.g. in a subsequent `if`), declare the variable before `BeginChangeCheck()` and assign it at `EndChangeCheck()`.

* **UGUI Prefab Single Responsibility:** Each `GameObject` in a UGUI prefab should have one
  responsibility. The prefab root carries only the main script and `RectTransform`. Visual
  components (`TMP_Text`, `Image`, etc.) must live on dedicated child `GameObject`s — never on
  the same object as the prefab root or another component.
