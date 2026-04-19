# Learning: VPS vs Mac Capabilities

**Date**: 2026-04-19
**Context**: I incorrectly claimed the VPS version of OpenClaw had voice correction and token reporting capabilities. The user (Coach) pointed out the discrepancy with the actual VPS setup.
**What happened**: I confused the capabilities of my current environment (Mac mini, which has `exec`, `session_status`, and background script support) with the VPS environment (which is text-only, isolated, and limited to conversational/commercial advice and Seabiscuit rules).
**What to do differently**: Always strictly differentiate between the Mac mini "muscle" version and the VPS "soul" version. Never promise Mac-specific tools (`exec`, `session_status`, voice correction) for the VPS version. The VPS version's capabilities are strictly limited to the whitelist: chat, business advice, and Seabiscuit rules.
