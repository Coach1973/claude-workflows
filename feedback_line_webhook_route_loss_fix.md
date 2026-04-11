---
name: LINE webhook route loss fix (openclaw gateway)
description: Root cause and fix for LINE webhook only responding to first message, not subsequent ones
type: project
---

## Root cause
After the first LINE message is processed, `loadOpenClawPlugins` is called asynchronously during agent processing. This fires the LINE provider's abort signal, triggering `stopHandler()` → `unregisterHttp()` which **splices** `/line/webhook` from `registry.httpRoutes` in-place. The second message arrives during this window with an empty route registry.

## Fix applied (working as of 2026-03-16)
Patched `/opt/homebrew/lib/node_modules/openclaw/dist/registry-DtTKJfN8.js` in `setActivePluginRegistry` to write known routes to `globalThis[Symbol.for("openclaw.persistentHttpRoutes")]`.

The gateway handler in `gateway-cli-CuZs0RlJ.js` (`createGatewayPluginRequestHandler`) already merges `persistentHttpRoutes` from globalThis into the registry lookup. Now that `setActivePluginRegistry` populates that store, even when `regRoutes=0` after cleanup, `persistRoutes=1` keeps the route alive.

**Why:** The `registerPluginHttpRoute` cleanup function (in plugin-sdk's Jiti-loaded CJS module instance) removes the route in-place from `registry.httpRoutes` but does NOT go through `setActivePluginRegistry`. Patches to `http-registry-7Lsnrxx9.js` and `thread-bindings-SYAnWHuW.js` don't take effect in the Jiti-loaded path. Only `registry-DtTKJfN8.js` changes reliably work.

**How to apply:** If openclaw is updated, re-apply the patch to `registry-DtTKJfN8.js`'s `setActivePluginRegistry` and `gateway-cli-CuZs0RlJ.js`'s `createGatewayPluginRequestHandler`.
