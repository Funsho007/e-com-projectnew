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
exports.deactivate = exports.activate = void 0;
const child_process = require("child_process");
const fs = require("fs");
const path = require("path");
const vscode = require("vscode");
const util_1 = require("util");
const vscode_1 = require("vscode");
const inspector_1 = require("./inspector");
const utils_1 = require("./utils");
const asyncExec = (0, util_1.promisify)(child_process.exec);
var VersionManager;
(function (VersionManager) {
    VersionManager["Asdf"] = "asdf";
    VersionManager["Chruby"] = "chruby";
    VersionManager["Rbenv"] = "rbenv";
    VersionManager["Rvm"] = "rvm";
    VersionManager["Shadowenv"] = "shadowenv";
    VersionManager["None"] = "none";
})(VersionManager || (VersionManager = {}));
let outputChannel;
const outputTerminals = new Map();
let lastExecCommand;
let lastProgram;
const terminalName = "Ruby Debug Terminal";
function workspaceFolder() {
    if (vscode.workspace.workspaceFolders) {
        for (const ws of vscode.workspace.workspaceFolders) {
            return ws.uri.fsPath;
        }
    }
}
function customPath(workingDirectory) {
    if (path.isAbsolute(workingDirectory)) {
        return workingDirectory;
    }
    else {
        const wspath = workspaceFolder();
        if (wspath) {
            return path.join(wspath, workingDirectory);
        }
        else {
            return workingDirectory;
        }
    }
}
function pp(obj) {
    outputChannel.appendLine(JSON.stringify(obj));
}
function exportBreakpoints() {
    if (vscode.workspace.getConfiguration("rdbg").get("saveBreakpoints")) {
        const wspath = workspaceFolder();
        if (wspath) {
            var bpLines = "";
            for (const bp of vscode.debug.breakpoints) {
                if (bp instanceof vscode.SourceBreakpoint && bp.enabled) {
                    // outputChannel.appendLine(JSON.stringify(bp));
                    const startLine = bp.location.range.start.line + 1;
                    const path = bp.location.uri.path;
                    bpLines = bpLines + "break " + path + ":" + startLine + "\n";
                }
            }
            const bpPath = path.join(wspath, ".rdbgrc.breakpoints");
            fs.writeFile(bpPath, bpLines, () => { });
            outputChannel.appendLine("Written: " + bpPath);
        }
    }
}
function activate(context) {
    outputChannel = vscode.window.createOutputChannel("rdbg");
    const adapterDescriptorFactory = new RdbgAdapterDescriptorFactory(context);
    const DAPTrackQueue = new vscode_1.EventEmitter();
    context.subscriptions.push(vscode.debug.registerDebugConfigurationProvider("rdbg", new RdbgInitialConfigurationProvider()));
    context.subscriptions.push(vscode.debug.registerDebugAdapterDescriptorFactory("rdbg", adapterDescriptorFactory));
    context.subscriptions.push(vscode.debug.registerDebugAdapterTrackerFactory("rdbg", new RdbgDebugAdapterTrackerFactory(DAPTrackQueue)));
    //
    context.subscriptions.push(vscode.debug.onDidChangeBreakpoints(() => {
        exportBreakpoints();
    }));
    context.subscriptions.push(vscode.debug.onDidStartDebugSession((session) => __awaiter(this, void 0, void 0, function* () {
        const config = session.configuration;
        if (config.request !== "launch" || config.useTerminal || config.noDebug)
            return;
        const args = {
            expression: ",eval $stdout.sync=true",
            context: "repl"
        };
        try {
            yield session.customRequest("evaluate", args);
        }
        catch (err) {
            // We need to ignore the error because this request will be failed if the version of rdbg is older than 1.7. The `,command` API is introduced from version 1.7.
            pp(err);
        }
    })));
    const folders = vscode.workspace.workspaceFolders;
    if (folders !== undefined && folders.length > 0) {
        const autoAttachConfigP = (c) => {
            if (c.type === "rdbg" && c.request === "attach" && c.autoAttach) {
                if (c.autoAttach === process.env.RUBY_DEBUG_AUTOATTACH) {
                    return true;
                }
                vscode.window.showErrorMessage(".vscode/rdbg_autoattach.json contains unexpected contents. Please check integrity.");
            }
            return false;
        };
        const jsonPath = path.join(folders[0].uri.fsPath, ".vscode/rdbg_autoattach.json");
        if (fs.existsSync(jsonPath)) {
            const c = JSON.parse(fs.readFileSync(jsonPath, "utf8"));
            if (autoAttachConfigP(c)) {
                fs.unlinkSync(jsonPath);
                vscode.debug.startDebugging(folders[0], c);
                return;
            }
        }
    }
    const disp = (0, inspector_1.registerInspectorView)(DAPTrackQueue, adapterDescriptorFactory);
    context.subscriptions.concat(disp);
}
exports.activate = activate;
function deactivate() {
}
exports.deactivate = deactivate;
class RdbgDebugAdapterTrackerFactory {
    constructor(_emitter) {
        this._emitter = _emitter;
    }
    createDebugAdapterTracker(session) {
        const self = this;
        const tracker = {
            onWillStartSession() {
                outputChannel.appendLine("[Start session]\n" + JSON.stringify(session));
            },
            onWillStopSession() {
                const outputTerminal = outputTerminals.get(session.id);
                if (outputTerminal) {
                    outputTerminal.show();
                    outputTerminals.delete(session.id);
                }
            },
            onError(e) {
                outputChannel.appendLine("[Error on session]\n" + e.name + ": " + e.message + "\ne: " + JSON.stringify(e));
            }
        };
        if (session.configuration.showProtocolLog) {
            tracker.onDidSendMessage = (message) => {
                self.publishMessage(message);
                outputChannel.appendLine("[DA->VSCode] " + JSON.stringify(message));
            };
            tracker.onWillReceiveMessage = (message) => {
                outputChannel.appendLine("[VSCode->DA] " + JSON.stringify(message));
            };
        }
        else {
            tracker.onDidSendMessage = (message) => {
                self.publishMessage(message);
            };
        }
        return tracker;
    }
    publishMessage(message) {
        this._emitter.fire(message);
    }
}
class RdbgInitialConfigurationProvider {
    resolveDebugConfiguration(_folder, config, _token) {
        var _a;
        const extensions = [];
        const traceEnabled = vscode.workspace.getConfiguration("rdbg").get("enableTraceInspector");
        if (traceEnabled) {
            extensions.push("traceInspector");
        }
        config.rdbgExtensions = extensions;
        config.rdbgInitialScripts = []; // for future extension
        if (config.script || config.request === "attach") {
            return config;
        }
        if (Object.keys(config).length > 0 && !config.script)
            return vscode.window.showInformationMessage("Cannot find a program to debug").then(_ => {
                return null;
            });
        // launch without configuration
        if (((_a = vscode.window.activeTextEditor) === null || _a === void 0 ? void 0 : _a.document.languageId) !== "ruby")
            return vscode.window.showInformationMessage("Select a ruby file to debug").then(_ => {
                return null;
            });
        return {
            type: "rdbg",
            name: "Launch",
            request: "launch",
            script: "${file}",
            askParameters: true,
        };
    }
    ;
    provideDebugConfigurations(_folder) {
        return [
            {
                type: "rdbg",
                name: "Debug current file with rdbg",
                request: "launch",
                script: "${file}",
                args: [],
                askParameters: true,
            },
            {
                type: "rdbg",
                name: "Attach with rdbg",
                request: "attach",
            }
        ];
    }
    ;
}
class StopDebugAdapter {
    constructor() {
        this.sendMessage = new vscode.EventEmitter();
        this.onDidSendMessage = this.sendMessage.event;
    }
    handleMessage() {
        const ev = {
            type: "event",
            seq: 1,
            event: "terminated",
        };
        this.sendMessage.fire(ev);
    }
    dispose() {
    }
}
const findRDBGTerminal = () => {
    let terminal;
    const currentTerminals = Array.from(outputTerminals.values());
    for (const t of vscode.window.terminals) {
        if (t.name === terminalName && !t.exitStatus && !currentTerminals.includes(t)) {
            terminal = t;
            break;
        }
    }
    return terminal;
};
class RdbgAdapterDescriptorFactory {
    constructor(context) {
        this.unixDomainRegex = /DEBUGGER:\sDebugger\scan\sattach\svia\s.+\((.+)\)/;
        this.colors = {
            red: 31,
            blue: 34
        };
        this.TCPRegex = /DEBUGGER:\sDebugger\scan\sattach\svia\s.+\((.+):(\d+)\)/;
        this.context = context;
        this.rubyActivated = false;
    }
    createDebugAdapterDescriptor(session, _executable) {
        return __awaiter(this, void 0, void 0, function* () {
            // session.configuration.internalConsoleOptions = "neverOpen"; // TODO: doesn't affect...
            const c = session.configuration;
            const cwd = c.cwd ? customPath(c.cwd) : workspaceFolder();
            yield this.activateRuby(cwd);
            // Reactivate the Ruby environment in case .ruby-version, Gemfile or Gemfile.lock changes
            if (cwd) {
                const watcher = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(cwd, "{.ruby-version,Gemfile,Gemfile.lock}"));
                this.context.subscriptions.push(watcher);
                watcher.onDidChange(() => this.activateRuby(cwd));
                watcher.onDidCreate(() => this.activateRuby(cwd));
                watcher.onDidDelete(() => this.activateRuby(cwd));
            }
            vscode.commands.executeCommand("rdbg.inspector.startDebugSession", session);
            if (c.request === "attach") {
                return this.attach(session);
            }
            else {
                // launch
                if (c.useTerminal || c.noDebug) {
                    return this.launchOnTerminal(session);
                }
                else {
                    return this.launchOnConsole(session);
                }
            }
        });
    }
    showError(msg) {
        outputChannel.appendLine("Error: " + msg);
        outputChannel.appendLine("Make sure to install rdbg command (`gem install debug`).\n" +
            "If you are using bundler, write `gem 'debug'` in your Gemfile.");
        outputChannel.show();
    }
    supportLogin(shell) {
        if (shell && (shell.endsWith("bash") || shell.endsWith("zsh") || shell.endsWith("fish"))) {
            return true;
        }
        else {
            return false;
        }
    }
    needShell(shell) {
        return !this.rubyActivated && this.supportLogin(shell);
    }
    makeShellCommand(cmd) {
        const shell = process.env.SHELL;
        if (this.needShell(shell)) {
            return shell + " -lic '" + cmd + "'";
        }
        else {
            return cmd;
        }
    }
    // Activate the Ruby environment variables using a version manager
    activateRuby(cwd) {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            this.rubyActivated = false;
            const manager = vscode.workspace.getConfiguration("rdbg").get("rubyVersionManager");
            let command;
            const rubyEnvCommand = ' -rjson -e "printf(%{RUBY_ENV_ACTIVATE%sRUBY_ENV_ACTIVATE}, JSON.dump(ENV.to_h))"';
            try {
                switch (manager) {
                    case VersionManager.Asdf:
                        command = this.makeShellCommand('asdf exec ruby' + rubyEnvCommand);
                        yield this.injectRubyEnvironment(command, cwd);
                        break;
                    case VersionManager.Rbenv:
                        command = this.makeShellCommand('rbenv exec ruby' + rubyEnvCommand);
                        yield this.injectRubyEnvironment(command, cwd);
                        break;
                    case VersionManager.Rvm:
                        command = this.makeShellCommand('rvm-auto-ruby' + rubyEnvCommand);
                        yield this.injectRubyEnvironment(command, cwd);
                        break;
                    case VersionManager.Chruby:
                        const rubyVersion = fs.readFileSync(path.join(cwd, ".ruby-version"), "utf8").trim();
                        command = this.makeShellCommand(`chruby-exec "${rubyVersion}" -- ruby` + rubyEnvCommand);
                        yield this.injectRubyEnvironment(command, cwd);
                        break;
                    case VersionManager.Shadowenv:
                        yield ((_a = vscode.extensions
                            .getExtension("shopify.vscode-shadowenv")) === null || _a === void 0 ? void 0 : _a.activate());
                        yield this.sleepMs(500);
                        break;
                    default:
                        return;
                }
                this.rubyActivated = true;
            }
            catch (error) {
                this.showError(`Failed to activate Ruby environment using ${manager}. Error: ${error}`);
            }
        });
    }
    injectRubyEnvironment(command, cwd) {
        return __awaiter(this, void 0, void 0, function* () {
            // Print the current environment after activating it with a version manager, so that we can inject it into the node
            // process. We wrap the environment JSON in `RUBY_ENV_ACTIVATE` to make sure we extract only the JSON since some
            // terminal/shell combinations may print extra characters in interactive mode
            const result = yield asyncExec(command, {
                cwd,
                env: process.env
            });
            const envJson = result.stdout.match(/RUBY_ENV_ACTIVATE(.*)RUBY_ENV_ACTIVATE/)[1];
            process.env = JSON.parse(envJson);
        });
    }
    getSockList(config) {
        return __awaiter(this, void 0, void 0, function* () {
            const cmd = this.makeShellCommand(this.rdbgBin(config) + " --util=list-socks");
            return new Promise((resolve, reject) => {
                child_process.exec(cmd, {
                    cwd: config.cwd ? customPath(config.cwd) : workspaceFolder(),
                    env: Object.assign(Object.assign({}, process.env), config.env)
                }, (err, stdout, stderr) => {
                    if (err) {
                        reject(err);
                    }
                    if (stderr) {
                        pp(stderr);
                    }
                    if (stdout) {
                        const socks = [];
                        if (stdout.length > 0) {
                            for (const line of stdout.split("\n")) {
                                if (line.length > 0) {
                                    socks.push(line);
                                }
                            }
                        }
                        resolve(socks);
                    }
                    resolve([]);
                });
            });
        });
    }
    parsePort(port) {
        var m;
        if (port.match(/^\d+$/)) {
            return ["localhost", parseInt(port), undefined];
        }
        else if ((m = port.match(/^(.+):(\d+)$/))) {
            return [m[1], parseInt(m[2]), undefined];
        }
        else {
            return [undefined, undefined, port];
        }
    }
    simplifySockList(list) {
        return list.map(sockPath => {
            return path.basename(sockPath);
        });
    }
    attach(session) {
        return __awaiter(this, void 0, void 0, function* () {
            const config = session.configuration;
            let port;
            let host;
            let sockPath;
            if (config.noDebug) {
                vscode.window.showErrorMessage("Can not attach \"Without debugging\".");
                return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
            }
            if (config.debugPort) {
                [host, port, sockPath] = this.parsePort(config.debugPort);
            }
            else {
                const list = yield this.getSockList(config);
                outputChannel.appendLine(JSON.stringify(list));
                switch (list.length) {
                    case 0:
                        vscode.window.showErrorMessage("Can not find attachable Ruby process.");
                        return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                    case 1:
                        sockPath = list[0];
                        break;
                    default:
                        const simplifiedList = this.simplifySockList(list);
                        const sock = yield vscode.window.showQuickPick(simplifiedList, {
                            title: "debug ports in " + path.dirname(list[0])
                        });
                        if (sock) {
                            const index = simplifiedList.indexOf(sock);
                            sockPath = list[index];
                        }
                        else {
                            return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                        }
                }
            }
            if (sockPath) {
                return new vscode_1.DebugAdapterNamedPipeServer((0, utils_1.fullPath)(sockPath, session));
            }
            else if (port) {
                return new vscode.DebugAdapterServer(port, host);
            }
            else {
                vscode.window.showErrorMessage("Unrechable.");
                return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
            }
        });
    }
    rdbgBin(config) {
        const rdbg = config.rdbgPath || "rdbg";
        return rdbg;
    }
    getSockPath(config) {
        return new Promise((resolve) => {
            var _a, _b;
            const command = this.makeShellCommand(this.rdbgBin(config) + " --util=gen-sockpath");
            const p = child_process.exec(command, {
                cwd: config.cwd ? customPath(config.cwd) : workspaceFolder(),
                env: Object.assign(Object.assign({}, process.env), config.env)
            });
            let path;
            p.on("error", e => {
                this.showError(e.message);
                resolve(undefined);
            });
            p.on("exit", (code) => {
                if (code !== 0) {
                    this.showError("exit code is " + code);
                    resolve(undefined);
                }
                else {
                    resolve(path);
                }
            });
            (_a = p.stderr) === null || _a === void 0 ? void 0 : _a.on("data", err => {
                outputChannel.appendLine(err);
            });
            (_b = p.stdout) === null || _b === void 0 ? void 0 : _b.on("data", out => {
                path = out.trim();
            });
        });
    }
    getTcpPortFile(config) {
        return new Promise((resolve) => {
            var _a, _b;
            const command = this.makeShellCommand(this.rdbgBin(config) + " --util=gen-portpath");
            const p = child_process.exec(command, {
                cwd: config.cwd ? customPath(config.cwd) : workspaceFolder(),
                env: Object.assign(Object.assign({}, process.env), config.env)
            });
            let path;
            p.on("error", () => {
                resolve(undefined);
            });
            p.on("exit", () => {
                resolve(path);
            });
            (_a = p.stderr) === null || _a === void 0 ? void 0 : _a.on("data", err => {
                outputChannel.appendLine(err);
            });
            (_b = p.stdout) === null || _b === void 0 ? void 0 : _b.on("data", out => {
                path = out.trim();
            });
        });
    }
    getVersion(config) {
        return new Promise((resolve) => {
            var _a, _b;
            const command = this.makeShellCommand(this.rdbgBin(config) + " --version");
            const p = child_process.exec(command, {
                cwd: config.cwd ? customPath(config.cwd) : workspaceFolder(),
                env: Object.assign(Object.assign({}, process.env), config.env)
            });
            let version;
            p.on("error", e => {
                this.showError(e.message);
                resolve(null);
            });
            p.on("exit", (code) => {
                if (code !== 0) {
                    this.showError(command + ": exit code is " + code);
                    resolve(null);
                }
                else {
                    resolve(version);
                }
            });
            (_a = p.stderr) === null || _a === void 0 ? void 0 : _a.on("data", err => {
                outputChannel.appendLine(err);
            });
            (_b = p.stdout) === null || _b === void 0 ? void 0 : _b.on("data", out => {
                version = out.trim();
            });
        });
    }
    vernum(version) {
        const vers = /rdbg (\d+)\.(\d+)\.(\d+)/.exec(version);
        if (vers) {
            return Number(vers[1]) * 1000 * 1000 + Number(vers[2]) * 1000 + Number(vers[3]);
        }
        else {
            return 0;
        }
    }
    envPrefix(env) {
        if (env) {
            let prefix = "";
            if (process.platform === "win32") {
                for (const key in env) {
                    prefix += "$Env:" + key + "='" + env[key] + "'; ";
                }
            }
            else {
                for (const key in env) {
                    prefix += key + "='" + env[key] + "' ";
                }
            }
            return prefix;
        }
        else {
            return "";
        }
    }
    sleepMs(waitMs) {
        return new Promise((resolve) => setTimeout(resolve, waitMs));
    }
    waitTcpPortFile(path, waitMs) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.waitUntil(() => {
                return fs.existsSync(path) && fs.readFileSync(path).toString().length > 0;
            }, waitMs);
        });
    }
    waitFile(path, waitMs) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.waitUntil(() => {
                return fs.existsSync(path);
            }, waitMs);
        });
    }
    waitUntil(condition, waitMs) {
        return __awaiter(this, void 0, void 0, function* () {
            let iterations = 50;
            if (waitMs) {
                iterations = waitMs / 100;
            }
            const startTime = Date.now();
            let i = 0;
            while (true) {
                i++;
                if (i > iterations) {
                    vscode.window.showErrorMessage("Couldn't start debug session (wait for " + (Date.now() - startTime) + " ms). Please install debug.gem.");
                    return false;
                }
                if (condition()) {
                    return true;
                }
                yield this.sleepMs(100);
            }
        });
    }
    // On Windows, generating `getTcpPortFile` method is always failed if the version of the debug.gem is less than 1.7.1.
    // `invalidRdbgVersion` method checks the version of the debug.gem.
    // FYI: https://github.com/ruby/debug/pull/937
    invalidRdbgVersion(config) {
        return __awaiter(this, void 0, void 0, function* () {
            const version = yield this.getVersion(config);
            if (version === null) {
                return false;
            }
            const vernum = this.vernum(version);
            return vernum < 1007002;
        });
    }
    launchOnTerminal(session) {
        return __awaiter(this, void 0, void 0, function* () {
            const config = session.configuration;
            // outputChannel.appendLine(JSON.stringify(session));
            // setup debugPort
            let sockPath;
            let tcpHost;
            let tcpPort;
            let tcpPortFile;
            if (config.debugPort) {
                [tcpHost, tcpPort, sockPath] = this.parsePort(config.debugPort);
                if (process.platform === "win32" && tcpPort === 0) {
                    const invalid = yield this.invalidRdbgVersion(config);
                    if (invalid) {
                        vscode.window.showErrorMessage("Please update the version of debug.gem to 1.7.2 or higher");
                        return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                    }
                    tcpPortFile = yield this.getTcpPortFile(config);
                }
                else if (tcpPort !== undefined) {
                    tcpPortFile = yield this.getTcpPortFile(config);
                }
            }
            else if (process.platform === "win32") {
                const invalid = yield this.invalidRdbgVersion(config);
                if (invalid) {
                    vscode.window.showErrorMessage("Please update the version of debug.gem to 1.7.2 or higher");
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
                // default
                tcpHost = "localhost";
                tcpPort = 0;
                tcpPortFile = yield this.getTcpPortFile(config);
            }
            else {
                sockPath = yield this.getSockPath(config);
                if (!sockPath) {
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
                if (fs.existsSync(sockPath)) {
                    vscode.window.showErrorMessage("already exists: " + sockPath);
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
                outputChannel.appendLine("sock-path: <" + sockPath + ">");
            }
            // setup terminal
            let outputTerminal = findRDBGTerminal();
            if (!outputTerminal) {
                const shell = process.env.SHELL;
                const shellArgs = this.supportLogin(shell) ? ["-l"] : undefined;
                outputTerminal = vscode.window.createTerminal({
                    name: terminalName,
                    shellPath: shell,
                    shellArgs: shellArgs,
                    message: `Created by vscode-rdbg at ${new Date()}`,
                    iconPath: new vscode_1.ThemeIcon("ruby")
                });
            }
            outputTerminals.set(session.id, outputTerminal);
            let execCommand = "";
            try {
                execCommand = yield this.getExecCommands(config);
            }
            catch (error) {
                if (error instanceof InvalidExecCommandError) {
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
                throw error;
            }
            let cmdline = this.envPrefix(config.env);
            if (config.noDebug) {
                cmdline += execCommand;
            }
            else {
                let rdbgArgs;
                if (tcpHost !== undefined && tcpPort !== undefined) {
                    rdbgArgs = this.getTCPRdbgArgs(execCommand, tcpHost, tcpPort, tcpPortFile);
                }
                else {
                    rdbgArgs = this.getUnixRdbgArgs(execCommand, sockPath);
                }
                cmdline += this.rdbgBin(config) + " " + rdbgArgs.join(" ");
            }
            if (outputTerminal) {
                outputTerminal.show(false);
                if (config.cwd) {
                    // Ensure we are in the requested working directory
                    const cdCommand = "cd " + customPath(config.cwd);
                    outputTerminal.sendText(cdCommand);
                }
                outputTerminal.sendText(cmdline);
            }
            if (config.noDebug) {
                return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
            }
            // use NamedPipe
            if (sockPath) {
                if (yield this.waitFile(sockPath, config.waitLaunchTime)) {
                    return new vscode_1.DebugAdapterNamedPipeServer(sockPath);
                }
                else {
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
            }
            else if (tcpPort !== undefined) {
                if (tcpPortFile) {
                    if (yield this.waitTcpPortFile(tcpPortFile, config.waitLaunchTime)) {
                        const portStr = fs.readFileSync(tcpPortFile);
                        tcpPort = parseInt(portStr.toString());
                    }
                    else {
                        return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                    }
                }
                else {
                    const waitMs = config.waitLaunchTime ? config.waitLaunchTime : 5000 /* 5 sec */;
                    yield this.sleepMs(waitMs);
                }
                return new vscode.DebugAdapterServer(tcpPort, tcpHost);
            }
            // failed
            return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
        });
    }
    useBundler(config) {
        const useBundlerFlag = (config.useBundler !== undefined) ? config.useBundler : vscode.workspace.getConfiguration("rdbg").get("useBundler");
        const useBundler = useBundlerFlag && fs.existsSync(workspaceFolder() + "/Gemfile");
        return useBundler;
    }
    getExecCommands(config) {
        return __awaiter(this, void 0, void 0, function* () {
            const rubyCommand = config.command ? config.command : (this.useBundler(config) ? "bundle exec ruby" : "ruby");
            const execArgs = config.script + " " + (config.args ? config.args.join(" ") : "");
            let execCommand = rubyCommand + " " + execArgs;
            if (config.askParameters) {
                if (lastExecCommand && lastProgram === config.script) {
                    execCommand = lastExecCommand;
                }
                execCommand = yield vscode.window.showInputBox({
                    "title": "Debug command line",
                    "value": execCommand
                });
            }
            if (execCommand === undefined || execCommand.length <= 0) {
                throw new InvalidExecCommandError();
            }
            // Save the history of command and script to use next time in `config.askParameters`.
            lastExecCommand = execCommand;
            lastProgram = config.script;
            return execCommand;
        });
    }
    getTCPRdbgArgs(execCommand, host, port, portPath) {
        const rdbgArgs = [];
        rdbgArgs.push("--command", "--open", "--stop-at-load");
        rdbgArgs.push("--host=" + host);
        let portArg = port.toString();
        if (portPath) {
            portArg += ":" + portPath;
        }
        rdbgArgs.push("--port=" + portArg);
        rdbgArgs.push("--");
        rdbgArgs.push(...execCommand.trim().split(" "));
        return rdbgArgs;
    }
    getUnixRdbgArgs(execCommand, sockPath) {
        const rdbgArgs = [];
        rdbgArgs.push("--command", "--open", "--stop-at-load");
        if (sockPath) {
            rdbgArgs.push("--sock-path=" + sockPath);
        }
        rdbgArgs.push("--");
        rdbgArgs.push(...execCommand.trim().split(" "));
        return rdbgArgs;
    }
    launchOnConsole(session) {
        return __awaiter(this, void 0, void 0, function* () {
            const config = session.configuration;
            const debugConsole = vscode.debug.activeDebugConsole;
            // outputChannel.appendLine(JSON.stringify(session));
            let execCommand = "";
            try {
                execCommand = yield this.getExecCommands(config);
            }
            catch (error) {
                if (error instanceof InvalidExecCommandError) {
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
                throw error;
            }
            const options = {
                env: Object.assign(Object.assign({}, process.env), config.env),
                cwd: customPath(config.cwd || ""),
            };
            if (process.platform === "win32")
                options.shell = "powershell";
            let sockPath = undefined;
            let tcpHost = undefined;
            let tcpPort = undefined;
            if (config.debugPort) {
                [tcpHost, tcpPort, sockPath] = this.parsePort(config.debugPort);
            }
            else if (process.platform === "win32") {
                // default
                tcpHost = "localhost";
                tcpPort = 0;
            }
            if (tcpHost !== undefined && tcpPort !== undefined) {
                const rdbgArgs = this.getTCPRdbgArgs(execCommand, tcpHost, tcpPort);
                try {
                    [, tcpPort] = yield this.runDebuggeeWithTCP(debugConsole, this.rdbgBin(config), rdbgArgs, options);
                }
                catch (error) {
                    vscode.window.showErrorMessage(error.message);
                    return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
                }
                return new vscode.DebugAdapterServer(tcpPort, tcpHost);
            }
            const rdbgArgs = this.getUnixRdbgArgs(execCommand, sockPath);
            try {
                sockPath = yield this.runDebuggeeWithUnix(debugConsole, this.rdbgBin(config), rdbgArgs, options);
            }
            catch (error) {
                vscode.window.showErrorMessage(error.message);
                return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
            }
            if (yield this.waitFile(sockPath, config.waitLaunchTime)) {
                return new vscode_1.DebugAdapterNamedPipeServer(sockPath);
            }
            // failed
            return new vscode_1.DebugAdapterInlineImplementation(new StopDebugAdapter);
        });
    }
    colorMessage(message, colorCode) {
        return `\u001b[${colorCode}m${message}\u001b[0m`;
    }
    getSpawnCommand(rdbg) {
        const shell = process.env.SHELL;
        if (shell && this.needShell(shell)) {
            return shell;
        }
        return rdbg;
    }
    getSpawnArgs(rdbg, args) {
        const shell = process.env.SHELL;
        if (this.needShell(shell)) {
            return ['-lic', rdbg + ' ' + args.join(' ')];
        }
        return args;
    }
    runDebuggeeWithUnix(debugConsole, rdbg, rdbgArgs, options) {
        const cmd = this.getSpawnCommand(rdbg);
        const args = this.getSpawnArgs(rdbg, rdbgArgs);
        pp(`Running: ${cmd} ${args === null || args === void 0 ? void 0 : args.join(" ")}`);
        let connectionReady = false;
        let sockPath = "";
        let stderr = "";
        return new Promise((resolve, reject) => {
            const debugProcess = child_process.spawn(cmd, args, options);
            debugProcess.stderr.on("data", (chunk) => {
                const msg = chunk.toString();
                stderr += msg;
                if (stderr.includes("Error")) {
                    reject(new Error(stderr));
                }
                if (stderr.includes("DEBUGGER: wait for debugger connection...")) {
                    connectionReady = true;
                }
                const found = stderr.match(this.unixDomainRegex);
                if (found !== null && found.length === 2) {
                    sockPath = found[1];
                }
                debugConsole.append(this.colorMessage(msg, this.colors.red));
                if (sockPath.length > 0 && connectionReady) {
                    resolve(sockPath);
                }
            });
            debugProcess.stdout.on("data", (chunk) => {
                debugConsole.append(this.colorMessage(chunk.toString(), this.colors.blue));
            });
            debugProcess.on("error", (err) => {
                debugConsole.append(err.message);
                reject(err);
            });
            debugProcess.on("exit", (code) => {
                reject(new Error(`Couldn't start debug session. The debuggee process exited with code ${code}`));
            });
        });
    }
    runDebuggeeWithTCP(debugConsole, rdbg, rdbgArgs, options) {
        const cmd = this.getSpawnCommand(rdbg);
        const args = this.getSpawnArgs(rdbg, rdbgArgs);
        pp(`Running: ${cmd} ${args === null || args === void 0 ? void 0 : args.join(" ")}`);
        let connectionReady = false;
        let host = "";
        let port = -1;
        let stderr = "";
        return new Promise((resolve, reject) => {
            const debugProcess = child_process.spawn(cmd, args, options);
            debugProcess.stderr.on("data", (chunk) => {
                const msg = chunk.toString();
                stderr += msg;
                if (stderr.includes("Error")) {
                    reject(new Error(stderr));
                }
                if (stderr.includes("DEBUGGER: wait for debugger connection...")) {
                    connectionReady = true;
                }
                const found = stderr.match(this.TCPRegex);
                if (found !== null && found.length === 3) {
                    host = found[1];
                    port = parseInt(found[2]);
                }
                debugConsole.append(this.colorMessage(msg, this.colors.red));
                if (host.length > 0 && port !== -1 && connectionReady) {
                    resolve([host, port]);
                }
            });
            debugProcess.stdout.on("data", (chunk) => {
                debugConsole.append(this.colorMessage(chunk.toString(), this.colors.blue));
            });
            debugProcess.on("error", (err) => {
                debugConsole.append(err.message);
                reject(err);
            });
            debugProcess.on("exit", (code) => {
                reject(new Error(`Couldn't start debug session. The debuggee process exited with code ${code}`));
            });
        });
    }
}
class InvalidExecCommandError extends Error {
}
//# sourceMappingURL=extension.js.map