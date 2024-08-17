// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Attestation} from "@eas/contracts/IEAS.sol";

import {ScrollBadge} from "./ScrollBadge.sol";
import {ScrollBadgeEligibilityCheck} from "./extensions/ScrollBadgeEligibilityCheck.sol";
import {Unauthorized} from "../Errors.sol";

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract NuriNativeLP is ScrollBadge, ScrollBadgeEligibilityCheck {
    /// @notice NURI_ETH LP address
    IERC20 public constant NURIETH = IERC20(0x8aE1C699C9c62fac468a1E253e15B571b69a7ffe);

    /// @notice badge uri
    string public defaultBadgeURI;

    constructor(address resolver_, string memory _baseURI) ScrollBadge(resolver_) {
        defaultBadgeURI = _baseURI;
    }

    /// @inheritdoc ScrollBadge
    function onIssueBadge(Attestation calldata attestation) internal override returns (bool) {
        if (!super.onIssueBadge(attestation)) {
            return false;
        }
        return true;
    }

    /// @inheritdoc ScrollBadge
    function onRevokeBadge(Attestation calldata attestation) internal override returns (bool) {
        if (!super.onRevokeBadge(attestation)) {
            return false;
        }

        return true;
    }

    /// @inheritdoc ScrollBadge
    function badgeTokenURI(bytes32) public view override returns (string memory) {
        return defaultBadgeURI;
    }

    /// @inheritdoc ScrollBadgeEligibilityCheck
    function isEligible(address recipient) external view override returns (bool) {
        /// @dev check if greater than 0.1 LP tokens
        return NURIETH.balanceOf(recipient) >= (1 * 1e17);
    }
}
