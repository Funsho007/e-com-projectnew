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
exports.TraceTreeItemProviderProxy = exports.RecordTreeItemProviderProxy = void 0;
const rdbgTreeItem_1 = require("./rdbgTreeItem");
const vscode = require("vscode");
const utils_1 = require("./utils");
const treeItemProvider_1 = require("./treeItemProvider");
class RecordTreeItemProviderProxy {
    constructor(_toggleItem) {
        this._toggleItem = _toggleItem;
    }
    cleanUp() { }
    updateTraceLogs(threadId) {
        return __awaiter(this, void 0, void 0, function* () {
            const session = vscode.debug.activeDebugSession;
            if (session === undefined || threadId === undefined)
                return void 0;
            this.curThreadId = threadId;
            const args = {
                command: "record",
                subCommand: "collect",
                threadId: threadId,
            };
            const resp = yield (0, utils_1.customRequest)(session, rdbgTraceInspectorCmd, args);
            if (resp === undefined || resp.logs.length < 1) {
                return void 0;
            }
            this.curStoppedIndex = resp.stoppedIndex;
            if (resp.logs[this.curStoppedIndex]) {
                resp.logs[this.curStoppedIndex].stopped = true;
            }
            this._recordTree = new RecordLogTreeProvider(resp.logs);
        });
    }
    selectLog(selected) {
        return __awaiter(this, void 0, void 0, function* () {
            const session = vscode.debug.activeDebugSession;
            if (session === undefined || this.curThreadId === undefined || this.curStoppedIndex === undefined)
                return;
            let count = this.curStoppedIndex - selected.index;
            let command;
            if (count > 0) {
                command = "stepBack";
            }
            else {
                command = "step";
                count = Math.abs(count);
            }
            const args = {
                subCommand: command,
                count,
                threadId: this.curThreadId,
                command: "record",
            };
            (0, utils_1.customRequest)(session, rdbgTraceInspectorCmd, args);
        });
    }
    getPrevLogItem(selected) {
        var _a, _b;
        return __awaiter(this, void 0, void 0, function* () {
            if (!(selected instanceof rdbgTreeItem_1.OmittedItem) && this.curStoppedIndex) {
                selected = this._recordTree.getLogItem(this.curStoppedIndex);
            }
            if (selected instanceof rdbgTreeItem_1.RecordLogItem || selected instanceof rdbgTreeItem_1.OmittedItem) {
                return (_a = this._recordTree) === null || _a === void 0 ? void 0 : _a.getPrevLogItem(selected);
            }
            return (_b = this._recordTree) === null || _b === void 0 ? void 0 : _b.getBottomLogItem();
        });
    }
    getNextLogItem(selected) {
        var _a, _b;
        return __awaiter(this, void 0, void 0, function* () {
            if (!(selected instanceof rdbgTreeItem_1.OmittedItem) && this.curStoppedIndex) {
                selected = this._recordTree.getLogItem(this.curStoppedIndex);
            }
            if (selected instanceof rdbgTreeItem_1.RecordLogItem || selected instanceof rdbgTreeItem_1.OmittedItem) {
                return (_a = this._recordTree) === null || _a === void 0 ? void 0 : _a.getNextLogItem(selected);
            }
            return (_b = this._recordTree) === null || _b === void 0 ? void 0 : _b.getBottomLogItem();
        });
    }
    createTree() {
        return __awaiter(this, void 0, void 0, function* () {
            const items = [];
            if (this._toggleItem !== undefined) {
                items.push(this._toggleItem);
            }
            if (this._recordTree === undefined) {
                return items;
            }
            const root = new rdbgTreeItem_1.RootLogItem("Record");
            items.push(root);
            if (this._recordTree === undefined) {
                return [];
            }
            const tree = yield this._recordTree.createTree();
            this.setParentChild(tree, root);
            return items;
        });
    }
    setParentChild(children, parent) {
        return __awaiter(this, void 0, void 0, function* () {
            parent.children = children;
            for (const child of children) {
                child.parent = parent;
            }
        });
    }
}
exports.RecordTreeItemProviderProxy = RecordTreeItemProviderProxy;
class RecordLogTreeProvider extends treeItemProvider_1.TreeItemProvider {
    newLogItem(log, idx, state) {
        const record = log;
        let label = record.name;
        if (record.stopped) {
            const name = "(Stopped): " + label;
            label = { label: name, highlights: [[0, name.length]] };
        }
        return new rdbgTreeItem_1.RecordLogItem(label, record, idx, state);
    }
}
const rdbgTraceInspectorCmd = "rdbgTraceInspector";
class TraceTreeItemProviderProxy {
    cleanUp() {
        this.decorationType.dispose();
    }
    constructor(_toggleItem) {
        this._toggleItem = _toggleItem;
        this._traceTreeMap = new Map();
        this.decorationType = vscode.window.createTextEditorDecorationType({
            isWholeLine: true,
            backgroundColor: new vscode.ThemeColor("editorInlayHint.background"),
        });
    }
    updateTraceLogs(threadId) {
        return __awaiter(this, void 0, void 0, function* () {
            const session = vscode.debug.activeDebugSession;
            if (session === undefined)
                return void 0;
            if (threadId !== undefined) {
                this.curThreadId = threadId;
            }
            const args = {
                command: "trace",
                subCommand: "collect",
            };
            const resp = yield (0, utils_1.customRequest)(session, rdbgTraceInspectorCmd, args);
            if (resp === undefined || resp.logs.length < 1) {
                return void 0;
            }
            this._traceTreeMap = this.toTraceTreeMap(resp.logs);
        });
    }
    toTraceTreeMap(logs) {
        const treeMap = new Map();
        const logMap = this.toTraceLogMap(logs);
        logMap.forEach((logs, threadId) => {
            treeMap.set(threadId, new TraceLogTreeProvider(logs, threadId));
        });
        return new Map([...treeMap].sort((a, b) => a[0] - b[0]));
    }
    toTraceLogMap(logs) {
        const map = new Map();
        for (const log of logs) {
            const value = map.get(log.threadId);
            if (value === undefined) {
                map.set(log.threadId, [log]);
            }
            else {
                value.push(log);
                map.set(log.threadId, value);
            }
        }
        return map;
    }
    selectLog(selected) {
        return __awaiter(this, void 0, void 0, function* () {
            const location = selected.location;
            const range = new vscode.Range(location.line - 1, 0, location.line - 1, 0);
            const opts = {
                selection: range,
                preserveFocus: true,
            };
            yield vscode.commands.executeCommand("vscode.open", vscode.Uri.file(location.path), opts);
            if (vscode.window.activeTextEditor) {
                vscode.window.activeTextEditor.setDecorations(this.decorationType, [range]);
            }
        });
    }
    getPrevLogItem(selected) {
        return __awaiter(this, void 0, void 0, function* () {
            if ("threadId" in selected && typeof selected.threadId === "number") {
                const provider = this._traceTreeMap.get(selected.threadId);
                return provider === null || provider === void 0 ? void 0 : provider.getPrevLogItem(selected);
            }
        });
    }
    getNextLogItem(selected) {
        return __awaiter(this, void 0, void 0, function* () {
            if ("threadId" in selected && typeof selected.threadId === "number") {
                const provider = this._traceTreeMap.get(selected.threadId);
                return provider === null || provider === void 0 ? void 0 : provider.getNextLogItem(selected);
            }
        });
    }
    createTree() {
        return __awaiter(this, void 0, void 0, function* () {
            const items = [];
            if (this._toggleItem !== undefined) {
                items.push(this._toggleItem);
            }
            if (this._traceTreeMap.size > 0) {
                const root = new rdbgTreeItem_1.RootLogItem("Trace");
                items.push(root);
            }
            const stack = items.concat();
            while (true) {
                const item = stack.pop();
                if (item === undefined) {
                    break;
                }
                let children = [];
                switch (true) {
                    case item instanceof rdbgTreeItem_1.ThreadIdItem:
                        const tIdItem = item;
                        const provider = this._traceTreeMap.get(tIdItem.threadId);
                        if (provider === undefined) {
                            return [];
                        }
                        const tree = yield provider.createTree();
                        children = tree;
                        this.setParentChild(children, item);
                        break;
                    case item instanceof rdbgTreeItem_1.RootLogItem:
                        for (const threadId of this._traceTreeMap.keys()) {
                            const item = new rdbgTreeItem_1.ThreadIdItem(threadId);
                            children.push(item);
                        }
                        this.setParentChild(children, item);
                        break;
                }
                for (const child of children) {
                    if (child.collapsibleState !== vscode.TreeItemCollapsibleState.None) {
                        stack.push(child);
                    }
                }
            }
            return this.collapseLastItems(items);
        });
    }
    collapseLastItems(items) {
        return __awaiter(this, void 0, void 0, function* () {
            if (items.length === 1) {
                return items;
            }
            const stack = [items[items.length - 1]];
            while (true) {
                const item = stack.pop();
                if (item === undefined) {
                    break;
                }
                if (item.children && item.children.length > 0) {
                    switch (true) {
                        case item instanceof rdbgTreeItem_1.BaseLogItem:
                            item.collapsibleState = vscode.TreeItemCollapsibleState.Expanded;
                            stack.push(...item.children);
                            break;
                        case item instanceof rdbgTreeItem_1.ThreadIdItem:
                            const thread = item;
                            if (thread.threadId === this.curThreadId) {
                                item.collapsibleState = vscode.TreeItemCollapsibleState.Expanded;
                                stack.push(item.children[item.children.length - 1]);
                            }
                            break;
                        default:
                            item.collapsibleState = vscode.TreeItemCollapsibleState.Expanded;
                            stack.push(...item.children);
                            break;
                    }
                }
            }
            return items;
        });
    }
    setParentChild(children, parent) {
        return __awaiter(this, void 0, void 0, function* () {
            parent.children = children;
            for (const child of children) {
                child.parent = parent;
            }
        });
    }
}
exports.TraceTreeItemProviderProxy = TraceTreeItemProviderProxy;
class TraceLogTreeProvider extends treeItemProvider_1.TreeItemProvider {
    newLogItem(log, idx, state) {
        const trace = log;
        if (trace.name) {
            return new rdbgTreeItem_1.CallTraceLogItem(trace, idx, state);
        }
        return new rdbgTreeItem_1.LineTraceLogItem(trace, idx, state);
    }
}
//# sourceMappingURL=treeItemProxy.js.map