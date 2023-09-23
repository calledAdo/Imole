//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Sigvalidation.sol"


contract Imole {
    using SigValidation for bytes;
  
   //admin address for verifying withdrawal;
    address _admin;

   //a counter to keep track of the number of art's listed
   // and to map uinque numbers to each art;
    uint _art_Count;

   //contract address for payment token :A stablecoin is most suitable
    address paymentToken;



  // each ART contaims 
  //         _ART_NFT :contract address of the NFT attached to it 
  //         _ART_ROYALTY:assigned by art owner upon adding ART ,represents payPerStream;
    struct ART {
        address _ART_NFT;
        uint _ART_ROYALTY;
    }

  //a mapping of a unique number to all arts added useful for getting ART
    mapping(uint => ART) public art_ID;


 //admin address set on constructor;
    constructor(address admin) {
        _admin = admin;
    }

 //returns particular ART mapped to that number(_ID)
    function getART(uint _ID) external view returns (address) {
        return art_ID[_ID];
    }

    function addArt(
        address Art_Nft_Address,
        uint token_ID,
        uint royaltyPrice
    ) external {
        ERC721 _NFT = ERC721(Art_Nft_Address);
        require(_NFT.ownerOf(token_ID) == msg.sender);
        ART storage art = art_ID[_art_Count + 1];
        art._ART_NFT = Art_Nft_Address;
        art._ART_ROYALTY = royaltyPrice;
    }

    function withdrawRevenue(
        bytes memory _signature,
        uint _Art_ID,
        uint amount,
        address to
    ) external {
        require(_signature.isValidSignature(_admin, amount, _Art_ID));
        ERC20 token = ERC20(paymentToken);
        token.transfer(to, amount);
    }

    function Deposit(address depositor, uint amount) external {
        ERC20 token = ERC20(paymentToken);
        require(token.transferFrom(msg.sender, address(this), amount));

        emit AccountFunded(depositor, amount);
    }

    event AccountFunded(address depositor, uint amount);
    event ArtAdded(address art_Address, uint token_ID, uint royalty_Price);
}

 
