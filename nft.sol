pragma solidity 0.6.0;

import "openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FirstCollectible is ERC721 {
    uint public countToken;
    constructor () public ERC721 ("Dog", "puppy"){
        countToken = 0; //keeps track of number of tokens
    }

    function createCollectible(string memory tokenURI) public return (uint256) {
        uint256 newItemId = countToken;
        _safeMint(msg.sender, newItemId); //creates new nft
        _setTokenURI(newItemId, tokenURI);
        countToken++;
        return newItemId;
    }
}