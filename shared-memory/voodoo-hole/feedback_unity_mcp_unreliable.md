---
name: feedback-unity-mcp-unreliable
description: "Unity MCP bridge is broken & deprecated on this machine; avoid relying on it, NEVER retry on connection failure, defer Editor checks to the user"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b7f47596-3ec2-4b4a-935b-d1ce39309f07
---

The Unity MCP bridge (`com.akiojin.unity-mcp-server`) frequently fails to connect on Alger's machine, and the package is **deprecated/unmaintained** upstream with this bug never fixed.

**Why:** The bridge starts its TCP listener (port 6401) from an `[InitializeOnLoad]` static constructor with **no batch-mode guard**, so headless `AssetImportWorker` processes race the main Editor for the port. On Alger's 24-logical-core / 12-core machine Unity spawns ~11 import workers; during reimport-heavy work (e.g. the localization migration) a worker grabs 6401 in the domain-reload window, the Editor then hits `AddressAlreadyInUse` and can't bind, and the MCP server reports `Connection closed` / `ECONNREFUSED`. Colleagues mostly don't see it because they don't use the bridge (and have fewer cores → fewer workers). The durable fix — embed the package locally and add `if (Application.isBatchMode) return;` — is a **structural repo change on hold pending team sign-off**. Possible long-term replacement: Unity's official MCP server (team decision pending).

**How to apply:**
- **Prefer NOT to use Unity MCP tools.** For straightforward Editor tasks — "does it compile?", entering Play Mode, inspecting the hierarchy/components — **ask the user to do it in the Editor**; they can do it faster than a flaky MCP round-trip.
- **Never retry on MCP connection failure.** On the first `unity_connection_failed` / `ECONNREFUSED` / `Connection closed`, stop. Do NOT retry, and do NOT auto-diagnose or kill processes. Report once and fall back to the user or to offline tools (`Read`/`Grep`/`Glob`, and the offline code-index tools the bridge exposes: `get_symbols`, `find_symbol`, `find_refs`, `search`, `read`).
- The recovery (kill the `AssetImportWorker` holding 6401, then focus Unity to force a domain-reload rebind) is known and documented, but only do it **at the user's explicit request**.

Related: [[feedback-no-unity-reimport-all]]
