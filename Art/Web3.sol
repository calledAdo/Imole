//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

contract Art {
    address owner;
    string public _name;
    uint private numOfStreamRights;
    uint immutable _pricePerStream;

    struct streamer {
        uint16 numberOf_streams;
        uint deposit;
    }
    mapping(uint => address) internal streamRight_ID_Owner;

    constructor(address _owner, string memory _artName, uint pricePerStream) {
        owner = _owner;
        _name = _artName;
        _pricePerStream = pricePerStream;
    }

    function ownerOf(uint streamRight_ID) public view returns (address) {
        return _ownerOf(streamRight_ID);
    }

    function name() public view returns (string memory) {}

    function _baseURI() public view returns (string memory) {}

    function _ownerOf(uint streamRight_ID) internal view returns (address) {
        return streamRight_ID_Owner[streamRight_ID];
    }

    function _exists(uint streamRight_ID) internal view returns (bool) {
        return _ownerOf(streamRight_ID) != address(0);
    }

    function _safeMint(address to) public {
        require(to != address(0));
        _mint(to, numOfStreamRights + 1);
    }

    function _mint(address to, uint streamRight_ID) internal {
        streamRight_ID_Owner[streamRight_ID] = to;

        emit Mint(to, streamRight_ID);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual {}

    event Mint(address to, uint streamRight_ID);
}
