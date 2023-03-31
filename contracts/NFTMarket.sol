// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds; //total number of items ever created
  Counters.Counter private _itemsSold; //total number of items sold

  uint256 listingPrice = 0.001 ether; //people have to pay to list their nft
  address payable owner; //Owner of the smart contract

  constructor() ERC721("Metaverse Tokens","META"){ //prewritten by openzeppelin
    owner = payable(msg.sender);
  }

  mapping(uint256 => MarketItem) private idToMarketItem;

  struct MarketItem{
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }

  event MarketItemCreated( 
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );

//Returns the listing price of the market
  function getListingPrice() public view returns(uint256){
      return listingPrice;
  }

  //update the listing price
  function updateListingPrice(uint _listingPrice) public payable{
    require(owner == msg.sender,"Only marketplace owner can update listing price"); //owner is = msg.sender,
    listingPrice =_listingPrice;
  }

  function createMarketItem(uint256 tokenId, uint256 price) private {
    require(price >0, "Price must be greater than zero"); //price>0 and the price must be greater than zero
    require(msg.value == listingPrice, "Price must be equal to listing price");  //msg.value == listingPrice

    idToMarketItem[tokenId]= MarketItem( //this is an idtomarketitem with token id = market item and the tokenid payable msg.sender payable address(this) price false
      tokenId,
      payable(msg.sender),
      payable(address(this)),
      price,
      false
    );

    _transfer(msg.sender,address(this),tokenId);
    emit MarketItemCreated(tokenId, msg.sender, address(this), price,false);
  }

  //Mint a token and list it in the marketplace
  function createToken(string memory tokenURI,uint256 price) public payable returns(uint){
      _tokenIds.increment(); //Create a tokenId 
      uint256 newTokenId = _tokenIds.current(); //uint256 newTokenId and create _tokenIds.current(), going to increment it
      _mint(msg.sender, newTokenId); //_mint, msg.sender, use the mint functionality _mint(msg.sender, newTokenId);, and are going to send the tokenID
      _setTokenURI(newTokenId,tokenURI); //_setTokenURI going to have new tokenID with token URI 
      createMarketItem(newTokenId, price); //then going to have createMarketItem new token id and price, has to be called internally 
      return newTokenId; //then return the newTokenId
  }

//functions are coming from the open zeppelin library
//transfer the ownership of the item as well as between parties like that
function createMarketSale(uint256 tokenId) public payable{
    uint price= idToMarketItem[tokenId].price; //get the price of the nft
    address seller =idToMarketItem[tokenId].seller; //require address seller and idtomarketitem[tokenid]
  
    require(msg.value == price, "Please submit the asking price in order to complete the purchase"); //require price
    idToMarketItem[tokenId].owner = payable(msg.sender);
    idToMarketItem[tokenId].sold = true;
    idToMarketItem[tokenId].seller = payable(address(0)); 
    _itemsSold.increment(); 
    _transfer(address(this),msg.sender,tokenId);
    payable(owner).transfer(listingPrice); //payable owner.transfer (listingPrice)
    payable(seller).transfer(msg.value); //seller and transfer msg.value
  }


//returns all unsold market items
function fetchMarketItems() public view returns(MarketItem[] memory) { 
      uint itemCount = _tokenIds.current(); //sets the amount of token ids
      uint unsoldItemCount = _tokenIds.current() - _itemsSold.current(); //token ids current - items sold current
      uint currentIndex =0; //set the current index 

      MarketItem[] memory items = new MarketItem[](unsoldItemCount); //empty array memory contain all the market items new MarketItem [] (unsoldItemcount)
      //push the items here and return the array

      for(uint i=0; i<itemCount; i++){ //look through theitemCount
        if(idToMarketItem[i+1].owner == address(this)){ //if idToMarketItem [i+1] start from one is the owner and is == address (this)
          uint currentId = i+1; //then set the currentId = i+1
          MarketItem storage currentItem = idToMarketItem[currentId]; //MarketItem storage is = currentItem = idToMarketItem[currentId]
          items[currentIndex] = currentItem; //items[currentIndex] = currentItem
          currentIndex += 1;

        }
      }
      return items;
    }

    //Returns only item that a user has purchased
    function fetchMyNfts() public view returns(MarketItem[] memory){ //fetchItemsListed and public view returns marketitem and memory
      uint totalItemCount= _tokenIds.current(); //uint totalitemcount = _tokensIds.current //get the total item count= tokenIds.current
      uint itemCount=0; //uint itemCount
      uint currentIndex=0; //uint currentIndex 

      for(uint i=0;i<totalItemCount;i++){ //loop through all the totalitem counts
        if(idToMarketItem[i+1].owner == msg.sender){ //if the id to marketitem [i+1].seller == msg.sender
          itemCount+=1; //increment i+1
        } 
      }

      MarketItem[] memory items = new MarketItem[](itemCount); //MarketItem memory items = new MarketItem and the itemcount
      for(uint i=0; i<totalItemCount;i++){ //loop through the uint i=0; i<totalItemcount; i++
        if(idToMarketItem[i+1].owner == msg.sender){ //if idtomarketitem [i+1].seller == msg.sender
          uint currentId=i+1;//increment currentId = i+1
          MarketItem storage currentItem = idToMarketItem[currentId]; //marketItem storage currentItem and idToMarketItem[currentId]
          items[currentIndex]= currentItem; //item currentIndex = currentItem
          currentIndex +=1; //add currentIndex +=1
        }
      }
      return items;
    }



 //Returns only item that a user has listed
    function fetchItemsListed() public view returns(MarketItem[] memory){ //fetchItemsListed and public view returns marketitem and memory
      uint totalItemCount= _tokenIds.current(); //uint totalitemcount = _tokensIds.current //get the total item count= tokenIds.current
      uint itemCount=0; //uint itemCount
      uint currentIndex=0; //uint currentIndex 

      for(uint i=0;i<totalItemCount;i++){ //loop through all the totalitem counts
        if(idToMarketItem[i+1].seller == msg.sender){ //if the id to marketitem [i+1].seller == msg.sender
          itemCount+=1; //increment i+1
        } 
      }

      MarketItem[] memory items = new MarketItem[](itemCount); //MarketItem memory items = new MarketItem and the itemcount
      for(uint i=0; i<totalItemCount;i++){ //loop through the uint i=0; i<totalItemcount; i++
        if(idToMarketItem[i+1].seller == msg.sender){ //if idtomarketitem [i+1].seller == msg.sender
          uint currentId=i+1;//increment currentId = i+1
          MarketItem storage currentItem = idToMarketItem[currentId]; //marketItem storage currentItem and idToMarketItem[currentId]
          items[currentIndex]= currentItem; //item currentIndex = currentItem
          currentIndex +=1; //add currentIndex +=1
        }
      }
      return items;
    }

    // Allows user to resell a token they have purchased

    function resellToken(uint256 tokenId,uint256 price) public payable {
       require(idToMarketItem[tokenId].owner ==msg.sender, "Only item owner can perform this operation"); //idtomarketitem tokenid
       require(msg.value == listingPrice, "Price must be equal to listing price"); //msg.value == listingprice
       idToMarketItem[tokenId].sold = false;
       idToMarketItem[tokenId].price = price;
       idToMarketItem[tokenId].seller = payable(msg.sender);
       idToMarketItem[tokenId].owner= payable(address(this));
       _itemsSold.decrement();
       _transfer(msg.sender, address(this),tokenId);

    }


//Allow user to cancel their market listing
function cancelItemListing(uint256 tokenId) public{
  require(idToMarketItem[tokenId].seller == msg.sender, "Only item seller can perform this operation");
  require(idToMarketItem[tokenId].sold == false, "Only cancel items which are not sold yet");
  idToMarketItem[tokenId].owner= payable(msg.sender);
  idToMarketItem[tokenId].seller= payable(address(0));
  idToMarketItem[tokenId].sold= true;
  _itemsSold.increment();
  payable(owner).transfer(listingPrice);
  _transfer(address(this), msg.sender, tokenId);
}
}

