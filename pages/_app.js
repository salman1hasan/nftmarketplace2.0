import '../styles/globals.css';
import Link from 'next/link';

function App({ Component, pageProps }) {
  return (
    <div>
      <nav className="border-b p-6">
        <p className="text-4xl font-bold">Metaverse NFT Store</p>
        <div className="flex mt-4"></div>
        <Link legacyBehavior href="/">
          <a className="mr-4 text-pink-500">Home</a>
        </Link>
        <Link legacyBehavior href="/create-nft">
          <a className="mr-4 text-pink-500">Sell NFT</a>
        </Link>
        <Link legacyBehavior href="/my-nfts">
          <a className="mr-4 text-pink-500">My NFT</a>
        </Link>
        <Link legacyBehavior href="/creator-dashboard">
          <a className="mr-4 text-pink-500">Dashboard</a>
        </Link>
      </nav>
      <Component {...pageProps} />
    </div>
  );
}

export default App;
