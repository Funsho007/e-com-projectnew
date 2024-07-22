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
exports.fullPath = exports.customRequest = void 0;
const path = require("path");
const fs = require("fs");
function customRequest(session, command, args) {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            return yield session.customRequest(command, args);
        }
        catch (error) {
            console.error(error);
            return undefined;
        }
    });
}
exports.customRequest = customRequest;
;
function fullPath(p, session) {
    if (path.isAbsolute(p)) {
        return p;
    }
    const workspace = session === null || session === void 0 ? void 0 : session.workspaceFolder;
    if (workspace === undefined) {
        return p;
    }
    const fullPath = path.join(workspace.uri.fsPath, p);
    if (fs.existsSync(fullPath)) {
        return fullPath;
    }
    return p;
}
exports.fullPath = fullPath;
//# sourceMappingURL=utils.js.map