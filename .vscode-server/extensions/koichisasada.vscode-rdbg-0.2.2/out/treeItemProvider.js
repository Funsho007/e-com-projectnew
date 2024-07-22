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
exports.TreeItemProvider = void 0;
const vscode = require("vscode");
const rdbgTreeItem_1 = require("./rdbgTreeItem");
const push = Array.prototype.push;
class TreeItemProvider {
    constructor(logs, _threadId) {
        this._threadId = _threadId;
        this._logItems = [];
        this._minDepth = Infinity;
        this._omittedItems = [];
        this._logItems = this.toLogItems(logs);
        this._minDepth = this.getMinDepth(this._logItems);
    }
    clearArray(ary) {
        while (ary.length > 0) {
            ary.pop();
        }
    }
    topItem(idx) {
        return idx === 0;
    }
    getBottomLogItem() {
        return this._logItems[this._logItems.length - 1];
    }
    getLogItem(idx) {
        return this._logItems[idx];
    }
    getNextLogItem(selected) {
        return __awaiter(this, void 0, void 0, function* () {
            let idx;
            let item;
            switch (true) {
                case selected instanceof rdbgTreeItem_1.BaseLogItem:
                    idx = selected.index;
                    item = this.getLogItem(idx + 1);
                    return item;
                case selected instanceof rdbgTreeItem_1.OmittedItem:
                    const omit = selected;
                    item = this.getLogItem(omit.offset);
                    return item;
            }
        });
    }
    getPrevLogItem(selected) {
        return __awaiter(this, void 0, void 0, function* () {
            let idx;
            let item;
            switch (true) {
                case selected instanceof rdbgTreeItem_1.BaseLogItem:
                    const traceItem = selected;
                    idx = traceItem.index;
                    if (this.topItem(idx)) {
                        return;
                    }
                    return this.getLogItem(idx - 1);
                case selected instanceof rdbgTreeItem_1.OmittedItem:
                    item = selected.parent;
                    return item;
            }
        });
    }
    hasChild(logs, index) {
        const target = logs[index];
        return logs[index + 1] && logs[index + 1].depth > target.depth;
    }
    createTree() {
        return __awaiter(this, void 0, void 0, function* () {
            this.clearArray(this._omittedItems);
            const items = [];
            if (this._logItems[0].depth > this._minDepth) {
                const omitted = new rdbgTreeItem_1.OmittedItem(0, this._minDepth, this._threadId);
                this._omittedItems.push(omitted);
                items.push(omitted);
            }
            const traceItem = this.listLogItems(this._logItems, this._minDepth);
            push.apply(items, traceItem);
            const stack = items.concat();
            while (true) {
                const item = stack.pop();
                if (item === undefined) {
                    break;
                }
                const children = [];
                let subArray;
                let childLogs;
                let childEnd;
                let childMinDepth = Infinity;
                let traceItem;
                switch (true) {
                    case item instanceof rdbgTreeItem_1.BaseLogItem:
                        const idx = item.index;
                        subArray = this._logItems.slice(idx + 1);
                        childEnd = subArray.length - 1;
                        for (let i = 0; i < subArray.length; i++) {
                            if (subArray[i].depth <= this._logItems[idx].depth) {
                                childEnd = i;
                                break;
                            }
                        }
                        childLogs = subArray.slice(0, childEnd);
                        childMinDepth = this.getMinDepth(childLogs);
                        if (childLogs[0] && childLogs[0].depth > childMinDepth) {
                            const o = new rdbgTreeItem_1.OmittedItem(childLogs[0].index, childMinDepth, this._threadId);
                            this._omittedItems.push(o);
                            children.push(o);
                        }
                        traceItem = this.listLogItems(childLogs, childMinDepth);
                        push.apply(children, traceItem);
                        // Do not await
                        this.setParentChild(children, item);
                        break;
                    case item instanceof rdbgTreeItem_1.OmittedItem:
                        const omitted = item;
                        subArray = this._logItems.slice(omitted.offset);
                        childEnd = subArray.length - 1;
                        for (let i = 0; i < subArray.length; i++) {
                            if (subArray[i].depth === omitted.depth) {
                                childEnd = i;
                                break;
                            }
                        }
                        childLogs = subArray.slice(0, childEnd);
                        childMinDepth = this.getMinDepth(childLogs);
                        if (childLogs[0].depth > childMinDepth) {
                            const o = new rdbgTreeItem_1.OmittedItem(omitted.offset, childMinDepth, this._threadId);
                            this._omittedItems.push(o);
                            children.push(o);
                        }
                        traceItem = this.listLogItems(childLogs, childMinDepth);
                        push.apply(children, traceItem);
                        // Do not await
                        this.setParentChild(children, item);
                        break;
                }
                for (const child of children) {
                    if (child.collapsibleState !== vscode.TreeItemCollapsibleState.None) {
                        stack.push(child);
                    }
                }
            }
            return items;
        });
    }
    toLogItems(logs) {
        const items = [];
        logs.forEach((log, idx) => {
            let state = vscode.TreeItemCollapsibleState.None;
            if (this.hasChild(logs, idx)) {
                state = vscode.TreeItemCollapsibleState.Collapsed;
            }
            items.push(this.newLogItem(log, idx, state));
        });
        return items;
    }
    listLogItems(logs, depth) {
        const root = [];
        for (const log of logs) {
            if (log.depth === depth) {
                root.push(log);
            }
        }
        return root;
    }
    setParentChild(children, parent) {
        return __awaiter(this, void 0, void 0, function* () {
            parent.children = children;
            for (const child of children) {
                child.parent = parent;
            }
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
    getMinDepth(logs) {
        let min = Infinity;
        for (const log of logs) {
            if (log.depth < min) {
                min = log.depth;
            }
        }
        return min;
    }
}
exports.TreeItemProvider = TreeItemProvider;
//# sourceMappingURL=treeItemProvider.js.map