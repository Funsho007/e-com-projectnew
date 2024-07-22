"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.registerInspectorView = void 0;
const vscode = require("vscode");
const rdbgTreeItem_1 = require("./rdbgTreeItem");
const treeItemProxy_1 = require("./treeItemProxy");
function registerInspectorView(emitter, versionChecker) {
    const config = {
        traceLine: true,
        traceCall: true,
        traceClanguageCall: true,
        recordAndReplay: true,
    };
    const treeProvider = new RdbgTraceInspectorTreeProvider(config);
    const view = vscode.window.createTreeView("rdbg.inspector", { treeDataProvider: treeProvider });
    const inlayHintsProvider = new RdbgCodeLensProvider(view);
    const disposables = [];
    let traceInspectorEnabled;
    // Since it takes time to get vscode.debug.activeDebugSession,
    // we holds the session obtained in DebugAdapterDescriptorFactory#createDebugAdapterDescriptor.
    let activeSession;
    disposables.push(vscode.languages.registerCodeLensProvider([
        {
            language: "ruby",
        },
        {
            language: "haml",
        },
        {
            language: "slim",
        },
    ], inlayHintsProvider), emitter.event((message) => __awaiter(this, void 0, void 0, function* () {
        switch (true) {
            case message.event === "stopped":
                while (traceInspectorEnabled === undefined) {
                    yield new Promise((resolve) => setTimeout(resolve, 10));
                }
                if (!traceInspectorEnabled) {
                    return;
                }
                const evt = message;
                treeProvider.updateTraceLogs(evt.body.threadId);
                break;
            case treeProvider.toggleTreeItem.enabled &&
                (message.command === "launch" || message.command === "attach"):
                while (traceInspectorEnabled === undefined) {
                    yield new Promise((resolve) => setTimeout(resolve, 1));
                }
                if (!traceInspectorEnabled) {
                    return;
                }
                yield treeProvider.toggleTreeItem.enable(activeSession);
                break;
        }
    })), vscode.debug.onDidTerminateDebugSession(() => __awaiter(this, void 0, void 0, function* () {
        traceInspectorEnabled = undefined;
        treeProvider.cleanUp();
    })), 
    // rdbg.inspector.startDebugSession is defined to check the version of debug.gem. To send the request to enable Trace Inspector as soon as possible, we need to finish checking the version of debug.gem in advance.
    vscode.commands.registerCommand("rdbg.inspector.startDebugSession", (session) => __awaiter(this, void 0, void 0, function* () {
        const traceEnabled = vscode.workspace.getConfiguration("rdbg").get("enableTraceInspector");
        if (!traceEnabled) {
            if (treeProvider.toggleTreeItem.enabled) {
                vscode.window.showErrorMessage("Trace Inspector failed to start because enableTraceInspector field is false. Please set it to true");
                yield treeProvider.toggleTreeItem.resetView();
                treeProvider.refresh();
            }
            traceInspectorEnabled = false;
            return;
        }
        activeSession = session;
        const config = session.configuration;
        traceInspectorEnabled = yield validVersion(config, versionChecker, treeProvider);
    })), vscode.commands.registerCommand("rdbg.inspector.openPrevLog", () => __awaiter(this, void 0, void 0, function* () {
        switch (true) {
            case view.selection.length < 1:
            case view.selection[0] instanceof rdbgTreeItem_1.ToggleTreeItem:
            case view.selection[0] instanceof rdbgTreeItem_1.RootLogItem:
                return;
        }
        const log = yield treeProvider.getPrevLogItem(view.selection[0]);
        if (log !== undefined) {
            yield view.reveal(log, { select: true });
        }
    })), vscode.commands.registerCommand("rdbg.inspector.openNextLog", () => __awaiter(this, void 0, void 0, function* () {
        switch (true) {
            case view.selection.length < 1:
            case view.selection[0] instanceof rdbgTreeItem_1.ToggleTreeItem:
            case view.selection[0] instanceof rdbgTreeItem_1.RootLogItem:
                return;
        }
        const log = yield treeProvider.getNextLogItem(view.selection[0]);
        if (log !== undefined) {
            yield view.reveal(log, { select: true });
        }
    })), vscode.commands.registerCommand("rdbg.inspector.toggle", () => __awaiter(this, void 0, void 0, function* () {
        // When traceInspectorEnabled is undefined, debug session is not started. We can enable trace inspector in this case.
        if (traceInspectorEnabled === false) {
            vscode.window.showErrorMessage("Trace Inspector failed to start because of the version of debug.gem was less than 1.8.0. Please update the version.");
            return;
        }
        const item = treeProvider.toggleTreeItem;
        yield item.toggle();
        if (item.enabled) {
            if (config.recordAndReplay) {
                treeProvider.providerProxy = new treeItemProxy_1.RecordTreeItemProviderProxy(item);
            }
            else {
                treeProvider.providerProxy = new treeItemProxy_1.TraceTreeItemProviderProxy(item);
            }
        }
        treeProvider.refresh();
    })), vscode.commands.registerCommand("rdbg.inspector.disableTraceLine", () => {
        config.traceLine = false;
        vscode.commands.executeCommand("setContext", "traceLineEnabled", false);
        vscode.commands.executeCommand("rdbg.inspector.disableRecordAndReplay");
    }), vscode.commands.registerCommand("rdbg.inspector.enableTraceLine", () => {
        config.traceLine = true;
        vscode.commands.executeCommand("setContext", "traceLineEnabled", true);
    }), vscode.commands.registerCommand("rdbg.inspector.disableTraceCall", () => {
        config.traceCall = false;
        vscode.commands.executeCommand("setContext", "traceCallEnabled", false);
    }), vscode.commands.registerCommand("rdbg.inspector.enableTraceCall", () => {
        config.traceCall = true;
        vscode.commands.executeCommand("setContext", "traceCallEnabled", true);
    }), vscode.commands.registerCommand("rdbg.inspector.disableRecordAndReplay", () => {
        config.recordAndReplay = false;
        vscode.commands.executeCommand("setContext", "recordAndReplayEnabled", false);
    }), vscode.commands.registerCommand("rdbg.inspector.enableRecordAndReplay", () => {
        config.recordAndReplay = true;
        vscode.commands.executeCommand("setContext", "recordAndReplayEnabled", true);
    }), vscode.commands.registerCommand("rdbg.inspector.enableTraceClanguageCall", () => {
        config.traceClanguageCall = true;
        vscode.commands.executeCommand("setContext", "traceClanguageCallEnabled", true);
    }), vscode.commands.registerCommand("rdbg.inspector.disableTraceClanguageCall", () => {
        config.traceClanguageCall = false;
        vscode.commands.executeCommand("setContext", "traceClanguageCallEnabled", false);
    }), vscode.commands.registerCommand("rdbg.inspector.enterFilter", () => __awaiter(this, void 0, void 0, function* () {
        const opts = {
            placeHolder: "e.g. foobar.*",
        };
        if (config.filterRegExp) {
            opts.value = config.filterRegExp;
        }
        const input = yield vscode.window.showInputBox(opts);
        if (input === undefined || input.length < 1) {
            vscode.commands.executeCommand("setContext", "filterEntered", false);
            config.filterRegExp = undefined;
            return;
        }
        const result = input.match(/^\/(.+)\/$/);
        if (result && result.length === 2) {
            config.filterRegExp = result[1];
        }
        else {
            config.filterRegExp = input;
        }
        vscode.commands.executeCommand("setContext", "filterEntered", true);
    })), vscode.commands.registerCommand("rdbg.inspector.reenterFilter", () => {
        vscode.commands.executeCommand("rdbg.inspector.enterFilter");
    }), view.onDidChangeSelection((e) => {
        if (e.selection.length < 1) {
            return;
        }
        if (e.selection[0] instanceof rdbgTreeItem_1.BaseLogItem) {
            treeProvider.selectLog(e.selection[0]);
            inlayHintsProvider.refresh();
        }
    }), vscode.commands.registerCommand("rdbg.inspector.copyLog", (log) => {
        const fields = getLogFields(log);
        const json = JSON.stringify(fields);
        vscode.env.clipboard.writeText(json);
    }));
    vscode.commands.executeCommand("setContext", "traceInspectorEnabled", true);
    vscode.commands.executeCommand("rdbg.inspector.disableRecordAndReplay");
    vscode.commands.executeCommand("rdbg.inspector.disableTraceClanguageCall");
    vscode.commands.executeCommand("rdbg.inspector.enableTraceLine");
    vscode.commands.executeCommand("rdbg.inspector.enableTraceCall");
    vscode.commands.executeCommand("setContext", "filterEntered", false);
    return disposables;
}
exports.registerInspectorView = registerInspectorView;
function validVersion(config, versionChecker, treeProvider) {
    return __awaiter(this, void 0, void 0, function* () {
        const str = yield versionChecker.getVersion(config);
        if (str === null) {
            vscode.window.showErrorMessage("Trace Inspector failed to start because of failing to check version");
            return false;
        }
        const version = versionChecker.vernum(str);
        // checks the version of debug.gem is 1.8.0 or higher.
        if (version < 1008000) {
            if (treeProvider.toggleTreeItem.enabled) {
                yield treeProvider.toggleTreeItem.resetView();
                treeProvider.refresh();
                vscode.window.showErrorMessage("Trace Inspector failed to start because of the version of debug.gem was less than 1.8.0. Please update the version.");
            }
            return false;
        }
        return true;
    });
}
function getLogFields(log) {
    switch (true) {
        case log instanceof rdbgTreeItem_1.CallTraceLogItem:
            const call = log;
            return {
                method: call.label,
                location: call.location,
                returnValue: call.returnValue,
                parameters: call.parameters,
            };
        case log instanceof rdbgTreeItem_1.LineTraceLogItem:
            return {
                location: log.location,
            };
        case log instanceof rdbgTreeItem_1.RecordLogItem:
            const record = log;
            return {
                method: record.label,
                location: log.location,
                parameters: record.parameters,
            };
        default:
            throw new Error("Invalid log type");
    }
}
class RdbgTraceInspectorTreeProvider {
    constructor(config) {
        this._onDidChangeTreeData = new vscode.EventEmitter();
        this.onDidChangeTreeData = this._onDidChangeTreeData.event;
        this._toggleItem = new rdbgTreeItem_1.ToggleTreeItem(config);
        this.refresh();
    }
    cleanUp() {
        var _a;
        (_a = this.providerProxy) === null || _a === void 0 ? void 0 : _a.cleanUp();
        this.providerProxy = undefined;
        if (this._toggleItem.enabled) {
            this._toggleItem.toggle();
        }
        this.refresh();
    }
    get toggleTreeItem() {
        return this._toggleItem;
    }
    refresh() {
        this._onDidChangeTreeData.fire();
    }
    updateTraceLogs(threadId) {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            yield ((_a = this.providerProxy) === null || _a === void 0 ? void 0 : _a.updateTraceLogs(threadId));
            this.refresh();
        });
    }
    getPrevLogItem(selected) {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            return (_a = this.providerProxy) === null || _a === void 0 ? void 0 : _a.getPrevLogItem(selected);
        });
    }
    getNextLogItem(selected) {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            return (_a = this.providerProxy) === null || _a === void 0 ? void 0 : _a.getNextLogItem(selected);
        });
    }
    selectLog(selected) {
        var _a;
        (_a = this.providerProxy) === null || _a === void 0 ? void 0 : _a.selectLog(selected);
    }
    getTreeItem(element) {
        return element;
    }
    getChildren(element) {
        return __awaiter(this, void 0, void 0, function* () {
            const session = vscode.debug.activeDebugSession;
            if (session === undefined || this.providerProxy === undefined)
                return [this.toggleTreeItem];
            if (element) {
                return element.children;
            }
            // Do not await
            return this.providerProxy.createTree();
        });
    }
    getParent(element) {
        return __awaiter(this, void 0, void 0, function* () {
            const session = vscode.debug.activeDebugSession;
            if (session === undefined)
                return void 0;
            return element.parent;
        });
    }
}
class RdbgCodeLensProvider {
    constructor(_treeView) {
        this._treeView = _treeView;
        this._singleSpace = " ";
        this._arrow = "#=>";
        this._onDidChangeCodeLenses = new vscode.EventEmitter();
        this.onDidChangeCodeLenses = this._onDidChangeCodeLenses.event;
    }
    provideCodeLenses(document, _token) {
        const codeLenses = [];
        if (this._treeView.selection.length < 1) {
            return codeLenses;
        }
        const codeLens = this.getCodeLens(this._treeView.selection[0], document);
        if (codeLens) {
            codeLenses.push(codeLens);
        }
        return codeLenses;
    }
    getCodeLens(item, document) {
        switch (true) {
            case item instanceof rdbgTreeItem_1.CallTraceLogItem:
                const call = item;
                if (call.returnValue !== undefined) {
                    return this.newCodeLens(call, document);
                }
                if (call.parameters !== undefined) {
                    return this.newCodeLens(call, document);
                }
            case item instanceof rdbgTreeItem_1.RecordLogItem:
                const record = item;
                if (record.parameters !== undefined) {
                    return this.newCodeLens(record, document);
                }
        }
    }
    newCodeLens(item, document) {
        const line = item.location.line - 1;
        const text = document.lineAt(line);
        this.curItem = item;
        return new vscode.CodeLens(text.range);
    }
    resolveCodeLens(codeLens, _token) {
        const item = this.curItem;
        if (item === undefined) {
            return null;
        }
        if (item instanceof rdbgTreeItem_1.CallTraceLogItem) {
            if (item.returnValue !== undefined) {
                const label = item.label + this._singleSpace + this._arrow + this._singleSpace + item.returnValue;
                codeLens.command = {
                    title: this.truncateString(label),
                    command: "",
                    tooltip: label,
                    arguments: [item, codeLens.range],
                };
            }
            if (item.parameters) {
                const label = this.createCallEventTitle(item);
                codeLens.command = {
                    title: this.truncateString(label),
                    tooltip: label,
                    command: "",
                    arguments: [item, codeLens.range],
                };
            }
        }
        else if (item instanceof rdbgTreeItem_1.RecordLogItem) {
            if (item.parameters) {
                const label = this.createCallEventTitle(item);
                codeLens.command = {
                    title: this.truncateString(label),
                    tooltip: label,
                    command: "",
                    arguments: [item, codeLens.range],
                };
            }
        }
        return codeLens;
    }
    createCallEventTitle(item) {
        if (item.parameters === undefined) {
            throw new Error("");
        }
        let params = "";
        for (const param of item.parameters) {
            params += `${param.name} = ${param.value}, `;
        }
        let methodName = item.label;
        if (item.label instanceof Object) {
            methodName = item.label.label;
        }
        return `${methodName}(${params.slice(0, params.length - 2)})`;
    }
    truncateString(str) {
        if (str.length > 99) {
            return str.substring(0, 99) + "...";
        }
        return str;
    }
    refresh() {
        this._onDidChangeCodeLenses.fire();
    }
}
//# sourceMappingURL=inspector.js.map