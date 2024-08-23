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

    string public BADGE_1;
    string public BADGE_10;
    string public BADGE_100;
    string public BADGE_1000;

    mapping(bytes32 => uint8) badgeToLevel;

    constructor(address resolver_, string[] memory _baseURI) ScrollBadge(resolver_) {
        defaultBadgeURI = _baseURI[0];
        BADGE_1 = _baseURI[1];
        BADGE_10 = _baseURI[2];
        BADGE_100 = _baseURI[3];
        BADGE_1000 = _baseURI[4];
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

    function levelUp(bytes32 _uid) external returns (bool success) {}

    /// @inheritdoc ScrollBadge
    function badgeTokenURI(bytes32 uid) public view override returns (string memory badgeURI) {
        uint8 level = badgeToLevel[uid];

        if (level == 4) return BADGE_1000;
        if (level == 3) return BADGE_100;
        if (level == 2) return BADGE_10;

        if (level == 1) return BADGE_1;
        /// @dev default badge
        if (level == 0) return defaultBadgeURI;
    }

    /// @inheritdoc ScrollBadgeEligibilityCheck
    function isEligible(address recipient) external view override returns (bool) {
        /// @dev check if greater than 0.1 LP tokens
        return NURIETH.balanceOf(recipient) >= (1 * 1e17);
    }

    /// @notice updates the user's level at the time
    /// @param _uid the uid of the badge
    /// @return _lvl their level
    function update(bytes32 _uid) public returns (uint8 _lvl) {
        Attestation memory payload = getAndValidateBadge(_uid);
        require(msg.sender == payload.recipient || tx.origin == payload.recipient);
        uint256 balance = NURIETH.balanceOf(payload.recipient);
        uint8 lvlTracker = 0;
        /// @dev lvl 0
        if (balance <= 1 * 1e17) {
            require(badgeToLevel[_uid] <= lvlTracker);
            badgeToLevel[_uid] = lvlTracker;
            return lvlTracker;
        }
        /// @dev lvl 1
        if (balance >= 1 * 1e18) ++lvlTracker;
        /// @dev lvl 2
        if (balance >= 10 * 1e18) ++lvlTracker;
        /// @dev lvl 3
        if (balance >= 100 * 1e18) ++lvlTracker;
        /// @dev lvl 4
        if (balance >= 1000 * 1e18) ++lvlTracker;
        require(badgeToLevel[_uid] < lvlTracker);
        badgeToLevel[_uid] = lvlTracker;
        return lvlTracker;
    }
}
