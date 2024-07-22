# vscode-ruby-lsp-v0.7.14
## ✨ Enhancements

- Add support for running Rails generators from the UI (https://github.com/Shopify/ruby-lsp/pull/2257) by @vinistock
- Add create Minitest file operation (https://github.com/Shopify/ruby-lsp/pull/2316) by @vinistock

## 🐛 Bug Fixes

- Use URI object when invoking vscode.open (https://github.com/Shopify/ruby-lsp/pull/2318) by @vinistock
- Allow turning off ERB support through setting (https://github.com/Shopify/ruby-lsp/pull/2311) by @vinistock
- Only show file operations in the explorer view (https://github.com/Shopify/ruby-lsp/pull/2321) by @vinistock



# vscode-ruby-lsp-v0.7.13
## ✨ Enhancements

- Accept multiple URIs for the open file command (https://github.com/Shopify/ruby-lsp/pull/2312) by @vinistock

## 📦 Other Changes

- Add note about Mise version manager (https://github.com/Shopify/ruby-lsp/pull/2172) by @andyw8



# vscode-ruby-lsp-v0.7.12
## 🐛 Bug Fixes

- Check if error data is present before using it (https://github.com/Shopify/ruby-lsp/pull/2293) by @vinistock
- Eagerly activate workspaces for opened files (https://github.com/Shopify/ruby-lsp/pull/2283) by @vinistock

## 📦 Other Changes

- Sanitize backtrace and mark as telemetry trusted (https://github.com/Shopify/ruby-lsp/pull/2285) by @vinistock
- Add extension and server version to telemetry (https://github.com/Shopify/ruby-lsp/pull/2289) by @vinistock
- Turn off telemetry for unhandled errors (https://github.com/Shopify/ruby-lsp/pull/2298) by @vinistock



# vscode-ruby-lsp-v0.7.11
## ✨ Enhancements

- Remove ? and ! from editor.wordSeparators (https://github.com/Shopify/ruby-lsp/pull/2272) by @andyw8
- Provide code navigation features to erb files (https://github.com/Shopify/ruby-lsp/pull/2235) by @st0012

## 🐛 Bug Fixes

- Return early when fetching dependencies if client is not running (https://github.com/Shopify/ruby-lsp/pull/2276) by @vinistock
- Ensure test group exists before trying to add examples (https://github.com/Shopify/ruby-lsp/pull/2275) by @vinistock



# vscode-ruby-lsp-v0.7.10
## ✨ Enhancements

- Save untitled files with `.rb` extension by default (https://github.com/Shopify/ruby-lsp/pull/2262) by @Earlopain
- Add file open support for route lookup (https://github.com/Shopify/ruby-lsp/pull/2232) by @gmcgibbon
- Use new telemetry API (https://github.com/Shopify/ruby-lsp/pull/2259) by @vinistock
- Add default ruby configuration for visual studio code (https://github.com/Shopify/ruby-lsp/pull/1958) by @jenenliu

## 🐛 Bug Fixes

- Make the first workspace the main one even when lazy (https://github.com/Shopify/ruby-lsp/pull/2268) by @vinistock
- Require space for class keyword match (https://github.com/Shopify/ruby-lsp/pull/2270) by @vinistock
- Require space after module keyword (https://github.com/Shopify/ruby-lsp/pull/2271) by @vinistock



# vscode-ruby-lsp-v0.7.8
## 🐛 Bug Fixes

- Upgrade esbuild to v0.23 (https://github.com/Shopify/ruby-lsp/pull/2261) by @vinistock



# vscode-ruby-lsp-v0.7.6
## ✨ Enhancements

- Add configuration options for third-party formatters (https://github.com/Shopify/ruby-lsp/pull/2092) by @andyw8
- Add run task command (https://github.com/Shopify/ruby-lsp/pull/2231) by @vinistock
- Add better initialization error handling (https://github.com/Shopify/ruby-lsp/pull/2241) by @vinistock

## 🐛 Bug Fixes

- Fix chruby release candidate ordering (https://github.com/Shopify/ruby-lsp/pull/2212) by @vinistock
- Push disposables to subscriptions (https://github.com/Shopify/ruby-lsp/pull/2254) by @vinistock
- Simplify class and module grammar for more consistency (https://github.com/Shopify/ruby-lsp/pull/2242) by @vinistock



# vscode-ruby-lsp-v0.7.5
## ✨ Enhancements

- Display addons status in the control panel (https://github.com/Shopify/ruby-lsp/pull/2180) by @st0012
- Use quickpick UI to display addons list (https://github.com/Shopify/ruby-lsp/pull/2205) by @st0012

## 🐛 Bug Fixes

- Display warning when launching with no workspaces (https://github.com/Shopify/ruby-lsp/pull/2155) by @vinistock
- Avoid overriding the start function of Client (https://github.com/Shopify/ruby-lsp/pull/2163) by @st0012



# vscode-ruby-lsp-v0.7.4
## ✨ Enhancements

- Add `case` statement to VS Code snippets (https://github.com/Shopify/ruby-lsp/pull/2129) by @SimonBrazell

## 🐛 Bug Fixes

- Continue searching if directory is missing for omitted chruby patch version (https://github.com/Shopify/ruby-lsp/pull/2143) by @vinistock
- Standardize version manager script execution (https://github.com/Shopify/ruby-lsp/pull/2133) by @vinistock
- Ensure update server gem command updates the locked server (https://github.com/Shopify/ruby-lsp/pull/2145) by @vinistock



# vscode-ruby-lsp-v0.7.2
## 🐛 Bug Fixes

- Ensure default gems are part of the document selector (https://github.com/Shopify/ruby-lsp/pull/2127) by @vinistock
- Handle unsaved files in main language server client (https://github.com/Shopify/ruby-lsp/pull/2124) by @vinistock



# vscode-ruby-lsp-v0.7.1
## 🐛 Bug Fixes

- Fix duplicate LSP features appearing in multiroot workspaces (https://github.com/Shopify/ruby-lsp/pull/2101) by @andyw8
- Search for asdf.fish when the shell is fish (https://github.com/Shopify/ruby-lsp/pull/2111) by @vinistock



# vscode-ruby-lsp-v0.7.0
## ✨ Enhancements

- Allow omitting patch in .ruby-version (https://github.com/Shopify/ruby-lsp/pull/2004) by @vinistock

## 🐛 Bug Fixes

- Fix false positive in gem list matching (https://github.com/Shopify/ruby-lsp/pull/2012) by @vinistock
- Improve client integration tests (https://github.com/Shopify/ruby-lsp/pull/2033) by @vinistock
- Set shell and env for ASDF activation (https://github.com/Shopify/ruby-lsp/pull/2006) by @vinistock

## 📦 Other Changes

- Mention that bundleGemfile is not intended for multiroot workspaces (https://github.com/Shopify/ruby-lsp/pull/2011) by @vinistock
- Set dependabot `open-pull-requests-limit` to 100 (https://github.com/Shopify/ruby-lsp/pull/2059) by @egiurleo



# vscode-ruby-lsp-v0.5.21
## ✨ Enhancements

- Add manual Ruby configuration (https://github.com/Shopify/ruby-lsp/pull/1967) by @vinistock
- Allow configuring extra chruby paths (https://github.com/Shopify/ruby-lsp/pull/1976) by @vinistock
- Log invalid JSON environment (https://github.com/Shopify/ruby-lsp/pull/2000) by @vinistock



# vscode-ruby-lsp-v0.5.20
## ✨ Enhancements

- Implement ASDF as a manager object (https://github.com/Shopify/ruby-lsp/pull/1845) by @vinistock

## 🐛 Bug Fixes

- Fix logging manager on activation failure (https://github.com/Shopify/ruby-lsp/pull/1952) by @Earlopain
- Avoid redirecting gem list output to stderr (https://github.com/Shopify/ruby-lsp/pull/1964) by @vinistock
- Avoid setting GEM_HOME and GEM_PATH for rbenv (https://github.com/Shopify/ruby-lsp/pull/1966) by @vinistock



# vscode-ruby-lsp-v0.5.19
## 🐛 Bug Fixes

- Fix the discovered version manager logging as `[object Object]` (https://github.com/Shopify/ruby-lsp/pull/1920) by @Earlopain
- Migrate manager config before activating (https://github.com/Shopify/ruby-lsp/pull/1923) by @vinistock


