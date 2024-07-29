// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Attestation} from "@eas/contracts/IEAS.sol";

import {ScrollBadge} from "./ScrollBadge.sol";
import {ScrollBadgeEligibilityCheck} from "./extensions/ScrollBadgeEligibilityCheck.sol";
import {Unauthorized} from "../Errors.sol";

import {IVotingEscrow} from "../interfaces/IVotingEscrow.sol";

/// @title NuriBadge
/// @notice A badge that shows that the user has a veNFT with Nuri locked
contract NuriBadge is ScrollBadgeEligibilityCheck {
    /// @notice veNFT contract
    IVotingEscrow public ve;
    /// @notice minimum veNURI lock to be eligible
    uint256 public constant MIN_LOCK = 10 * 1e18;
    /// @dev makes it so you can't use the same nft over and over
    mapping(uint256 id => bool _used) internal basicSybilCheck;

    /// @notice badge uri
    string public defaultBadgeURI;

    constructor(address resolver_, address _ve, string memory _baseURI) ScrollBadge(resolver_) {
        ve = IVotingEscrow(_ve);
        defaultBadgeURI = _baseURI;
    }

    /// @inheritdoc ScrollBadge
    function onIssueBadge(Attestation calldata attestation) internal override returns (bool) {
        /// @dev store recipient for easy use later in the func
        address _recipient = attestation.recipient;
        if (!super.onIssueBadge(attestation)) {
            return false;
        }

        /// @dev if the user has no ve, or if their largest ve was already used - revert
        if (!_hasVe(_recipient) || basicSybilCheck[_largestPosition(_recipient)]) {
            revert Unauthorized();
        }

        /// @dev label the veNFT id as "used" to prevent easy sybiling
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

    /// @inheritdoc ScrollBadge
    function badgeTokenURI(bytes32 uid) public view override returns (string memory) {
        if (uid == bytes32(0)) {
            return defaultBadgeURI;
        }

        return getBadgeTokenURI(uid);
    }

    /// @notice Returns the token URI corresponding to a certain badge UID.
    /// @param uid The badge UID.
    /// @return The badge token URI (same format as ERC721).
    function getBadgeTokenURI(bytes32 uid) internal view virtual returns (string memory) {}

    /// @inheritdoc ScrollBadgeEligibilityCheck
    function isEligible(address recipient) external view override returns (bool) {
        bool mintable = !hasBadge(recipient) && _hasVe(recipient);
        bool validLock = false;
        for (uint256 i = 0; i < ve.balanceOf(recipient); ++i) {
            uint256 _id = ve.tokenOfOwnerByIndex(recipient, i);

            _balanceOfLocked(_id) > MIN_LOCK ? validLock = true : validLock = false;
        }
        /// @dev if mintable and the user has a valid lock, return true
        return mintable && validLock;
    }

    /// @dev internal function for whether the minter has a veNFT or not
    function _hasVe(address _recipient) internal view returns (bool) {
        return ve.balanceOf(_recipient) > 0;
    }

    /// @dev determine the effective locked balance of the user
    function _balanceOfLocked(uint256 _id) internal view returns (uint256) {
        (uint256 amount, uint256 unlockTime) = ve.locked(_id);
        /// @dev if the unlock time is longer than 3 years (out of 4 max), return the amount- else return 0
        if (unlockTime >= block.timestamp + (4 * 365 * 86400)) return amount;
        return 0;
    }

    /// @dev identify the largest veNFT held
    function _largestPosition(address _recipient) internal view returns (uint256) {
        uint256 largestID = 0;
        for (uint256 i = 0; i < ve.balanceOf(_recipient); ++i) {
            uint256 _id = ve.tokenOfOwnerByIndex(_recipient, i);
            /// @dev ternary operator for updating the largestID
            _balanceOfLocked(_id) > _balanceOfLocked(largestID) ? largestID = _id : largestID = largestID;
        }
        return largestID;
    }
}
