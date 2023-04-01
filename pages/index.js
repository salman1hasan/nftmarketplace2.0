import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import axios from 'axios';
import Web3Modal from 'web3modal';
import { INFURA_URL, contractAddress } from '@/config';
import NFTMarketplace from '../abi/NFTMarketplace.json';

export default function Home() {
  const [nfts, setNfts] = useState([]);
  const [loadingState, setLoadingState] = useState('not-loaded');

  useEffect(() => {
    loadNfts();
  }, []);

  async function loadNfts() {
    const provider = new ethers.providers.JsonRpcProvider(INFURA_URL);
    const marketContract = new ethers.Contract(
      contractAddress,
      NFTMarketplace.abi,
      provider
    );
    const data = await marketContract.fetchMarketItems(); //All unsold nfts

    const items = await Promise.all(
      data.map(async (i) => {
        const tokenUri = await marketContract.tokenURI(i.tokenId);
        const meta = await axios.get(tokenUri);
        let price = ethers.utils.formatUnits(i.price.toString(), 'ether');

        //creates an array of item objects
        let item = {
          price,
          tokenId: i.tokenId.toNumber(),
          seller: i.seller,
          owner: i.owner,
          image: meta.data.name,
          description: meta.data.description,
        };

        return item;
      })
    );
    setNfts(items);
    setLoadingState('loaded');
  }

  if (loadingState == 'not-loaded')
    return <h1 className="px-20 py-10 text-3xl">Wait Loading......</h1>;

  if (loadingState == 'loaded' && !nfts.length)
    return <h1 className="px-20 py-10 text-3xl">No items in marketplace</h1>;

  return (
    <div>
      <h1>Welcome to Home!</h1>
    </div>
  );
}
