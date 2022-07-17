"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TenXBank__factory = exports.ContextUpgradeable__factory = exports.IERC20Upgradeable__factory = exports.IERC20PermitUpgradeable__factory = exports.ReentrancyGuardUpgradeable__factory = exports.Initializable__factory = exports.OwnableUpgradeable__factory = exports.factories = void 0;
exports.factories = __importStar(require("./factories"));
var OwnableUpgradeable__factory_1 = require("./factories/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable__factory");
Object.defineProperty(exports, "OwnableUpgradeable__factory", { enumerable: true, get: function () { return OwnableUpgradeable__factory_1.OwnableUpgradeable__factory; } });
var Initializable__factory_1 = require("./factories/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable__factory");
Object.defineProperty(exports, "Initializable__factory", { enumerable: true, get: function () { return Initializable__factory_1.Initializable__factory; } });
var ReentrancyGuardUpgradeable__factory_1 = require("./factories/@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable__factory");
Object.defineProperty(exports, "ReentrancyGuardUpgradeable__factory", { enumerable: true, get: function () { return ReentrancyGuardUpgradeable__factory_1.ReentrancyGuardUpgradeable__factory; } });
var IERC20PermitUpgradeable__factory_1 = require("./factories/@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol/IERC20PermitUpgradeable__factory");
Object.defineProperty(exports, "IERC20PermitUpgradeable__factory", { enumerable: true, get: function () { return IERC20PermitUpgradeable__factory_1.IERC20PermitUpgradeable__factory; } });
var IERC20Upgradeable__factory_1 = require("./factories/@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable__factory");
Object.defineProperty(exports, "IERC20Upgradeable__factory", { enumerable: true, get: function () { return IERC20Upgradeable__factory_1.IERC20Upgradeable__factory; } });
var ContextUpgradeable__factory_1 = require("./factories/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable__factory");
Object.defineProperty(exports, "ContextUpgradeable__factory", { enumerable: true, get: function () { return ContextUpgradeable__factory_1.ContextUpgradeable__factory; } });
var TenXBank__factory_1 = require("./factories/contracts/TenXBank__factory");
Object.defineProperty(exports, "TenXBank__factory", { enumerable: true, get: function () { return TenXBank__factory_1.TenXBank__factory; } });
