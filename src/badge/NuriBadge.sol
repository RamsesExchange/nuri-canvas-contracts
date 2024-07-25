// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Attestation} from "@eas/contracts/IEAS.sol";

import {ScrollBadge} from "./ScrollBadge.sol";
import {ScrollBadgePermissionless} from "./examples/ScrollBadgePermissionless.sol";
import {ScrollBadgeEligibilityCheck} from "./extensions/ScrollBadgeEligibilityCheck.sol";
import {Unauthorized} from "../Errors.sol";

import {IVotingEscrow} from "../interfaces/IVotingEscrow.sol";

/// @title NuriBadge
/// @notice A badge that shows that the user has a veNFT with > 100 Nuri locked
contract NuriBadge is ScrollBadgePermissionless {
    IVotingEscrow public ve;
    /// @notice minimum veNURI lock to be eligible
    uint256 public constant MIN_LOCK = 10 * 1e18;
    /// @dev makes it so you can't use the same nft over and over
    mapping(uint256 id => bool _used) internal basicSybilCheck;
    constructor(address resolver_, address _ve) ScrollBadgePermissionless(resolver_) {
        ve = IVotingEscrow(_ve);
    }

    /// @inheritdoc ScrollBadge
    function onIssueBadge(Attestation calldata attestation) internal override returns (bool) {
        address _recipient = attestation.recipient;
        if (!super.onIssueBadge(attestation)) {
            return false;
        }

        if (!_hasVe(_recipient) || basicSybilCheck[_largestPosition(_recipient)]) {
            revert Unauthorized();
        }

        basicSybilCheck[_largestPosition(_recipient)] = true;
        return true;
    }

    /// @inheritdoc ScrollBadge
    function onRevokeBadge(Attestation calldata attestation) internal override returns (bool) {
        if (!super.onRevokeBadge(attestation)) {
            return false;
        }

        return true;
    }

    /// @inheritdoc ScrollBadgeEligibilityCheck
    function isEligible(address recipient) external view override returns (bool) {
        bool mintable = !hasBadge(recipient) && _hasVe(recipient);
        bool validLock = false;
        for (uint256 i = 0; i < ve.balanceOf(recipient); ++i) {
            uint256 _id = ve.tokenOfOwnerByIndex(recipient, i);

            _balanceOfLocked(_id) > MIN_LOCK ? validLock = true : validLock = false;
        }
        return mintable && validLock;
    }

    /// @dev internal function for whether the minter has a veNFT or not
    function _hasVe(address _recipient) internal view returns (bool) {
        return ve.balanceOf(_recipient) > 0;
    }

    /// @dev determine the effective locked balance of the user
    function _balanceOfLocked(uint256 _id) internal view returns (uint256) {
        (uint256 amount, uint256 unlockTime) = ve.locked(_id);
        if (unlockTime >= block.timestamp + 3 years) return amount;
        return 0;
    }

    /// @dev identify the largest veNFT held
    function _largestPosition(address _recipient) internal view returns (uint256) {
        uint256 largestID = 0;
        for (uint256 i = 0; i < ve.balanceOf(_recipient); ++i) {
            uint256 _id = ve.tokenOfOwnerByIndex(recipient, i);
            _balanceOfLocked(_id) > _balanceOfLocked(largestID) ? largestID = _id : largestID = largestID;
        }
        return largestID;
    }
}
