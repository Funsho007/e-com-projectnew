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
exports.ToggleTreeItem = exports.CallTraceLogItem = exports.LineTraceLogItem = exports.TraceLogItem = exports.RecordLogItem = exports.ThreadIdItem = exports.RootLogItem = exports.OmittedItem = exports.BaseLogItem = exports.RdbgTreeItem = void 0;
const vscode = require("vscode");
const utils_1 = require("./utils");
class RdbgTreeItem extends vscode.TreeItem {
    constructor(label, opts = {}) {
        super(label, opts.collapsibleState);
        this.id = opts.id;
        this.iconPath = opts.iconPath;
        this.tooltip = opts.tooltip;
        this.description = opts.description;
        this.resourceUri = opts.resourceUri;
        if (opts.command) {
            const command = "rdbg." + opts.command.command;
            this.command = { title: command, command, arguments: opts.command.arguments };
        }
    }
}
exports.RdbgTreeItem = RdbgTreeItem;
class BaseLogItem extends RdbgTreeItem {
    constructor(label, index, depth, location, opts = {}) {
        super(label, opts);
        this.index = index;
        this.depth = depth;
        this.location = location;
    }
}
exports.BaseLogItem = BaseLogItem;
class OmittedItem extends RdbgTreeItem {
    constructor(offset, depth, threadId) {
        super("..", { collapsibleState: vscode.TreeItemCollapsibleState.Collapsed });
        this.offset = offset;
        this.depth = depth;
        this.threadId = threadId;
    }
}
exports.OmittedItem = OmittedItem;
class RootLogItem extends RdbgTreeItem {
    constructor(kind) {
        super(kind + " Logs", { collapsibleState: vscode.TreeItemCollapsibleState.Expanded });
    }
}
exports.RootLogItem = RootLogItem;
class ThreadIdItem extends RdbgTreeItem {
    constructor(threadId) {
        super("Thread ID: " + threadId.toString(), { collapsibleState: vscode.TreeItemCollapsibleState.Collapsed });
        this.threadId = threadId;
    }
}
exports.ThreadIdItem = ThreadIdItem;
function createToolTipValue(log) {
    const tooltip = new vscode.MarkdownString();
    if (log.returnValue) {
        tooltip.appendCodeblock(log.name || "");
        tooltip.appendCodeblock(`#=> ${truncateString(log.returnValue)}`);
        tooltip.appendText(`@${log.location.path}:${log.location.line}`);
    }
    else {
        tooltip.appendCodeblock(log.name || "");
        if (log.parameters && log.parameters.length > 0) {
            if (log.parameters.length > 1) {
                tooltip.appendCodeblock("(");
                for (const param of log.parameters) {
                    tooltip.appendCodeblock(`  ${param.name} = ${truncateString(param.value)},`);
                }
                tooltip.appendCodeblock(")");
            }
            else {
                tooltip.appendCodeblock(`(${log.parameters[0].name} = ${log.parameters[0].value})`);
            }
        }
        tooltip.appendText(`@${log.location.path}:${log.location.line}`);
    }
    return tooltip;
}
function truncateString(str) {
    if (str.length > 256) {
        return str.substring(0, 256) + "...";
    }
    return str;
}
class RecordLogItem extends BaseLogItem {
    constructor(label, log, index, state) {
        log.location.path = (0, utils_1.fullPath)(log.location.path, vscode.debug.activeDebugSession);
        const description = prettyPath(log.location.path) + ":" + log.location.line;
        const opts = { collapsibleState: state };
        opts.collapsibleState = state;
        opts.description = description;
        super(label, index, log.depth, log.location, opts);
        this.index = index;
        this.id = index.toString();
        this.tooltip = createToolTipValue(log);
        this.parameters = log.parameters;
    }
}
exports.RecordLogItem = RecordLogItem;
function prettyPath(path) {
    const relative = vscode.workspace.asRelativePath(path);
    const home = process.env.HOME;
    if (home) {
        return relative.replace(home, "~");
    }
    return relative;
}
class TraceLogItem extends BaseLogItem {
    constructor(label, index, depth, location, threadId, opts = {}) {
        super(label, index, depth, location, opts);
        this.index = index;
        this.depth = depth;
        this.location = location;
        this.threadId = threadId;
    }
}
exports.TraceLogItem = TraceLogItem;
const locationIcon = new vscode.ThemeIcon("location");
class LineTraceLogItem extends TraceLogItem {
    constructor(log, idx, state) {
        log.location.path = (0, utils_1.fullPath)(log.location.path, vscode.debug.activeDebugSession);
        const label = prettyPath(log.location.path) + ":" + log.location.line.toString();
        const tooltip = log.location.path;
        const opts = { iconPath: locationIcon, collapsibleState: state, tooltip };
        super(label, idx, log.depth, log.location, log.threadId, opts);
    }
}
exports.LineTraceLogItem = LineTraceLogItem;
const arrowCircleRight = new vscode.ThemeIcon("arrow-circle-right");
const arrowCircleLeft = new vscode.ThemeIcon("arrow-circle-left");
class CallTraceLogItem extends TraceLogItem {
    constructor(log, idx, state) {
        log.location.path = (0, utils_1.fullPath)(log.location.path, vscode.debug.activeDebugSession);
        let iconPath;
        if (log.returnValue) {
            iconPath = arrowCircleLeft;
        }
        else {
            iconPath = arrowCircleRight;
        }
        const description = prettyPath(log.location.path) + ":" + log.location.line;
        const opts = { iconPath: iconPath, collapsibleState: state, description };
        super(log.name || "Unknown frame name", idx, log.depth, log.location, log.threadId, opts);
        this.returnValue = log.returnValue;
        this.parameters = log.parameters;
        this.tooltip = createToolTipValue(log);
    }
}
exports.CallTraceLogItem = CallTraceLogItem;
const playCircleIcon = new vscode.ThemeIcon("play-circle");
const stopCircleIcon = new vscode.ThemeIcon("stop-circle");
class ToggleTreeItem extends RdbgTreeItem {
    constructor(config) {
        super("Enable Trace", {
            command: { command: "inspector.toggle" },
            collapsibleState: vscode.TreeItemCollapsibleState.None,
            iconPath: playCircleIcon,
        });
        this.config = config;
        this._enabled = false;
    }
    get enabled() {
        return this._enabled;
    }
    toggle() {
        return __awaiter(this, void 0, void 0, function* () {
            const session = vscode.debug.activeDebugSession;
            if (this._enabled) {
                this.disable(session);
            }
            else {
                this.enable(session);
            }
        });
    }
    enable(session) {
        return __awaiter(this, void 0, void 0, function* () {
            this.iconPath = stopCircleIcon;
            this._enabled = true;
            this.label = "Disable Trace";
            if (session === undefined) {
                return;
            }
            const events = [];
            let args;
            const maxLogSize = vscode.workspace.getConfiguration("rdbg").get("maxTraceLogSize") || 50000;
            if (this.config.recordAndReplay) {
                this._enabledCommand = "record";
                args = {
                    command: this._enabledCommand,
                    subCommand: "enable",
                    maxLogSize: maxLogSize,
                };
            }
            else {
                this._enabledCommand = "trace";
                if (this.config.traceCall) {
                    events.push("traceCall");
                    const traceReturn = vscode.workspace.getConfiguration("rdbg").get("enableTraceReturnValue");
                    if (traceReturn) {
                        events.push("traceReturn");
                        if (this.config.traceClanguageCall) {
                            events.push("traceClanguageReturn");
                        }
                    }
                    const traceParams = vscode.workspace.getConfiguration("rdbg").get("enableTraceParameters");
                    if (traceParams) {
                        events.push("traceParams");
                    }
                }
                if (this.config.traceLine) {
                    events.push("traceLine");
                }
                if (this.config.traceClanguageCall) {
                    events.push("traceClanguageCall");
                }
                args = {
                    command: this._enabledCommand,
                    subCommand: "enable",
                    events,
                    maxLogSize: maxLogSize,
                };
            }
            if (this.config.filterRegExp) {
                args.filterRegExp = this.config.filterRegExp;
            }
            yield (0, utils_1.customRequest)(session, "rdbgTraceInspector", args);
        });
    }
    resetView() {
        return __awaiter(this, void 0, void 0, function* () {
            this._enabled = false;
            this.iconPath = playCircleIcon;
            this.label = "Enable Trace";
        });
    }
    disable(session) {
        return __awaiter(this, void 0, void 0, function* () {
            this.resetView();
            if (session === undefined || this._enabledCommand === undefined) {
                return;
            }
            const args = {
                command: this._enabledCommand,
                subCommand: "disable",
            };
            yield (0, utils_1.customRequest)(session, "rdbgTraceInspector", args);
            this._enabledCommand = undefined;
        });
    }
}
exports.ToggleTreeItem = ToggleTreeItem;
//# sourceMappingURL=rdbgTreeItem.js.map