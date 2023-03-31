Section 1 
 
1.Set up development environment using hardhat 
2.Create a smart contract that tracks and stores nft data 
3.Writing unit tests 
4.Deploy Smart Contract 
5.NextJS App 
6. Ether.js/Metamask to interact w/ deployed contract 
7.Working of application 
 
Installed MetaMask 
	Test Goerli ethers 
 
Hardhat -> Test deploy and work w/ on the ethereum blockchain 
 
Create newfolder 
 
NFT Marketplace DAAP 
Npm init –y 
npm install –save-dev hardhat 
 
npx hardhat 
Create JS Project 
 
npm install –save-dev hardhat@^2.10.1 @nomicfoundation/hardhat-toolbox@^1.0.1 
npm install –save-dev nomic labs ethereum waffle chai nomic labshardhat ethers and ethers 
 
Install dart nextjs snipps tailwindcss as well and hardhat 
 
Section 2 
 
Hardhat.config.js 
 
infura.io/dashboard 
Create New Project 
Web 3 API(Formerly Ethereum) 
NFT Marketplace 
Ethereum 
Hardhat.config.js 
	solidity: “0.8.9” 
	             networks:{ 
		goerli: { 
		          } 
npm install @openzeppelin/contracts dotenv 
Check if installed 
Create a .env file 
Infura_URL =”” 
WalletPrivateKey=”” 
Goerli : { 
	url: process.env.UNFURA_URL, 
	            accounts: [process.env Wallet_Private_Key] 
	} 
networks:{ 
	hardhat:{ 
 
	} 

 
 
Section 3 
Creating NFTMarketplace Contract 
Create a file NFTMarketplace.sol 
Copy passe spdx license and pragma solidity ^0.8.9; 
 
contract NFTMarketplace{ 
import Counters.sol, ERC721URI Storage.sol, import openzeppelin contracts token erc721.sol 
 
Contract NFT Marketplace is ERC721URIStorage 
            Using counters for Counters.counter; 
	       Counters counter private _tokenIds ///total numbers of items created 
            Counters Counter private _itemsSold; //total number of items sold 
 
ERC721 -> What the token does and stuff. It’s important to know what version 
 
Next variable Listing Price = 0.001 ether; //people have to pay to list their nft 
 
address payable owner //owner of the smart contract 
 
constructor() ERC721 (“Metaverse Tokens”, “Meta”) { 
				Name, Symbol -> Inhereing the code returned by open zeppelin library 
			   owner = payable(msg.sender); 
			} 
 
Own data analytics own premices 
		struct MarketItem( 
			uint256 tokenId-> tokenId 
		             address payable seller; -> address of a seller 
		              address payable owner -> address of owner 
			uint256 price -> price 
			    bool sold; -> sold or not 
		} 
 
event MarketItemCreated{ 
	uint256 indexed tokenId; ->  
        Events called so it can be saved in the blockchain properly address seller, 
	       address owner; 
	        uint256 price; 
                bool sold 
} 
 
Mint a token and list it in the marketplace 
createToken (tokenURI, price) public payable return the tokenID 
	_tokenId.increment -> Increments the token 
          uint256 newtokenId-> tokenIds.current 
          mint(msg.sender, newtokenid) 
          _setTokenURI(newtokenID,tokenURI) 
          createMarketItem 
          return tokenid 
} 
 
//Creating the sale of the marketplace item 
//transfer the ownership of the item as well and funds between parties 
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
 
 
 
Section 4 
//Return all unsold market items 
 
function fetchMarketItems()public view returns(MarketItem[] memory){ 
        uint itemCount =_ tokenIds.current(); make the item count the tokenIds.current 
        uint unsoldItemCount= _tokenIds.current() -_itemSold.current(); //unsold item accounts is going    to be unsolditemcount = tokenids.current(0-itemsSold.current() 
        uint currentIndex = 0; 
        
        MarketItem[] memory items = new MarketItem[](unsoldItemCount);{ 
	for(uint I=0; I<itemCount; I++){ 
		 if(idToMarketItem[I+1].owner == address(this)){ 
		uint currentId = I+1; 
                            MarketItem storage currentItem= idToMarketItem[currentId]; 
                            item[currentIndex]= currentItem; 
                            currentIndex += 1; 
 
	       }   
         } 
	return items; 
} 
 
Section 5 
//Allows user to resell a token they have purchased 
function resellToken(uint256 tokenID, uint256 price) public payable{ 
	require(idToMarketItem[tokenId].owner == msg.sender, “Only item owner can perform this operation”) //the id to marketitem has to be the owner == msg.sender 
     require(msg.value == listingPrice, “Price must be equal to listing price”) 
     idToMarketItem[tokenId].sold = false; 
     idToMarketItem[tokenId].price = price; //if someone changes the price 
     idToMarketItem[tokenId].seller= payable(msg.sender);//payable msg.sender 
     idToMarketItem[tokenId].owner = payable(address(this));  
     _itemsSold.decrement(); //decrement the item sold  
    _transfer(msg.sender, address(this), tokenId); //transfer the ownership //how to resell a token 
} 
 
//Allow someone to cancel a listing 
function cancelItemListing(uint256 tokenId) public{ 
      require(idToMarketItem[tokenId].seller == msg.sender, “only item can perform this operation”); 
      require(idToMarketItem[tokenId].sold== false, “Only cancel items which are not sold”) 
      idToMarketItem.owner = payable(msg.sender) 
      idToMarketItem.seller= payable(address(0)) 
      idToMarketItem.sold= true; 
 
} 
} 
 

 
Section 6 
Import expect and require chai 
import ethers and require hardhat 
 
add description and add nft marketplace 
declare a bunch of variables (nftmarket,nftmarket, listingprice,contractowner,buyeraddress,nftmarketaddress 
 
add const auctionPrice = ethers.utisl.parseuinits(100,ether) 
 
create a before each function  [The use of before each should be executed before each @test method] 
NFTMarket = await ethers.getContractFactory(NFTMarketplace) 
nftmarket= await nftmarket.deploy() 
await nftmarket.deployed() 
nftmarketaddress = nftmarketaddress 
[contractOwner,buyerAddress] = await ethers.getSigners() 
listingPrice = await nftMarket.getListingPrice(); 
listingPrice= listingPrice.toString() 
 
const mintandlistnft = async(tokenuri, auctionprice) => { 
	const transaction = await nftmarket.createToken(tokenURI,auctionPrice,{value:listingPrice)} 
            const receipt= await transaction.wait() 
            const tokenId = reciept.events[0].args.tokenId; 
            return tokenId 
} 
)}; 
 
Section 7 
Describe (Mint and a list a new nfttoken and function(){ 
     const tokenURI = https://some-token.uri/” 
 
     it(“Should revert if price is zero”, async ()=> { 
	await expect(mintand List(tokenURI,0).to.be.revertedWith(“Price must be greater than zero”); 
}) 
 
it(“should revert if listing price not correct” async function(){ 
   await expect(nftMarket.createToken(tokenURI, auctionPrice,{value:0}.to.be.revertedwith(“Prie must be equal to”) 
}); 
 
Delete Lock.js and delete Lock.sol npx hardhat compile 
 

Add another it should create an nft with the correct owner and token uri async function 
const tokenid = await mintandlistnft(tokenUri) 
const mintedtokenuri = await nftmarket.tokenuri(tokenid) 
const ownerAddress = await nftmarket.ownerof(tokenid) 
expect owneraddress to equal nftmarketaddress 
expect mintedtokenuri toequal tokenuri 
 
This should create the nft marketplace 
 
Then we should emit the market item after its succesfully created 
This includes transaction = await nftmarket.createToken(tokenURI, auctionPrice,{(listingPrice}) 
receipt = await transaction.wait() 
const tokenID = receipt.events [0].args.tokenid 
await expect(transaction).to.emit(nftMarket,Marketitemcreated).withargs(tokenid,contractowner.address) 
 
Section 8 
Create a describe function and execute sale of a marketplace item and function 
add const token uri = “some-token/uri” 
It should revert if auction price is not correct  
const newNFTToken = await mintAndListNFT(tokenURI, and create auctionPrice)      
await expect(nftMarket.connect(buyerAddress()); 
Revert if auction price is not correct and add const newNFTToken 
Add await mintAndListNft(tokenURI, auctionPrice) 
Add await expect(nftMarket.connect(buyerAddress)).create marketsale(()) 
newNftToken, {value:20}.to.be.revertedWith(“”); 
Going to get reverted with please submit the asking price in order to complete the purchase 
Next test case is going to be buy a new token and check token owner address async() => { 
	const newNFTtoken = await mintAndListNFT(tokenURI, auctionPrice): 
	  cont oldOwnerAddress = await nftMarket.ownerOf(newNftToken); 
 
	//Now the owner is the marketplace address 
      expect(oldOwnerAddress).to.equal(nftMarketAddress); 
      await nftMarket.connect(buyerAddress).createMarketSale(newNftToken,{value: auctionprice}} 
       
     const newOwnerAddress = await nftMarket.ownerOf(newNftToken); 
     //Now the new owner is the buyer address 
 
    expect(newOwnerAddress).to.equal(buyerAddress.address); 
 
}); 
 
 
Section 9 
Resale of a marketplace item and add token URI 
 
It should revert if the token owner or price isn’t correct 
const newNftToken = await mintAndListNFT(tokenURI, auctionPrice) 
await NFTMarket.connect(buyerAddress).createMarketSale(newNfttoken, value: auctionPrice); 
await expect(nftMarket.resellToken(newNFTToken, auctionPrice, {value:listingPrice})).to.be.reverted.with(“Only item owner can perform the operation”) 
await expect(nftMarket.connect(buyerAddress).reselltoken(newNftToken,auctionPrice,{{value:0}}.to.be.revertedwith(“Price must be equal to listing price“) 
it(“Buy a new token and then resell it”,async()=> { 
            const newNFTToken = await mintAndListNFT(tokenURI,auctionPrice) 
            await nftMarket.connect(buyerAddress).createMarketSale(newNftToken,{value:auctionPrice} 
            
            const tokenOwnerAddress = await nftMarket.ownerOf(newNftToken); 
            //Now the new owner is the buyer address 
           expect(tokenOwnerAddress).to.equal(buyerAddress.address); 
            
           await nftMarket.connect(buyerAddress).resellToken(newNftToken,auctionPrice, {value:listingPrice} 
 
	   const newTokenOwner = await nftMarket.ownerOf(newNftToken) 
 
	//Now new token 
         expect(newTokenOwner).to.equal(nftMarketAddress); 
}); 
 
Section 10 
Describe (“Fetch marketplace items’, function(){ 
	const tokenURI =”https://some-token.uri/” 
 
	it(“Should fetch the correct number of unsold items”,async() =>{ //fetch unsold items 
	await mintAndListNFT(tokenURI, auctionPrice); 
	          await mintAndListNFT(tokenURI, auctionPrice); 
             await mintAndListNFT(tokenURI, auctionPrice); 
 
	         let unsoldItems = await nftMarket.fetchMarketItems(); 
            expect(unsoldItems.length).is.equal(3); 
}); 
 
           it(“should fetch correct number of items that a user has purchased”, async() => { //fetch correct number of items  
		let nfttoken = await mintandlistnft(tokenuri,auctionPrice); 
                            await mintAndListNFT(tokenURI,auctionPrice); 
                            await mintAndListNFT(tokenURI, auctionPrice); 
 
	          await nftMarket.connect(buyerAddress).createMarketSale(nftToken, {value:auctionPrice}) 
 
	             let buyerTotalItems = await nftMarket.connect(buyerAddress).fetchMyNfts(); 
                           expect(buyerTotalItems.length).is.equal(1)          
}) 
 
 

it('Should fetch correct number of items listed by a user', async () => { 

await mintAndListNft(tokenURI, auctionPrice); 

await mintAndListNft(tokenURI, auctionPrice); 

await nftMarket.connect(buyerAddress).createToken(tokenURI,auctionPrice,{value: listingPrice}); 

let ownerlistings = await nftMarket.fetchItemsListed(); 

expect(ownerlistings.length).to.equal(2); 

}); 
 
 

Section 11 
Add a testcase NFTMarket.js and import cancel a marketplace listing 
const token uri 
describe('Cancel a Marketplace listing', function () { 

const tokenURI = 'https://some-token-uri'; 

 
 

it('Should cancel and return the correct number of listings', async () => { 

let nftToken = await mintAndListNft(tokenURI, auctionPrice); 

await nftMarket 

.connect(buyerAddress) 

.createToken(tokenURI, auctionPrice, { value: listingPrice }); 

await nftMarket 

.connect(buyerAddress) 

.createToken(tokenURI, auctionPrice, { value: listingPrice }); 

let unsoldItems = await nftMarket.fetchMarketItems(); 

await expect(unsoldItems.length).is.equal(3); 

await nftMarket.cancelItemListing(nftToken); 

 
 

let newUnsoldItems = await nftMarket.fetchMarketItems(); 

 
 

await expect(newUnsoldItems.length).is.equal(2); 

}); 

}); 

}); 
 
Section 12 
Deploy.js is added to scripts 
add const main = async() =>{ 
contractFactory 
contract 
contract.deployed() 
console.log(Contract deployed to, contract.address) 
 
const runMain = async() => { 
try{ 
await main() 
process.exit(0); 
}catch(error){ 
console.log(error); 
process.exit(1) 
} 
} 
 
run main [Basic code that needs to be executed make sure that the contract address is kept and maintained and kept secret] 
 
 

 
