import { useState, useEffect } from "react";
import "./App.css";

function App() {
  const [meme, setMeme] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchMeme = () => {
    setLoading(true);
    fetch("https://meme-api.com/gimme")
      .then((res) => res.json())
      .then((data) => {
        setMeme(data);
        setLoading(false);
      });
  };

  useEffect(() => {
    fetchMeme();
  }, []);

  return (
    <div className="app">
      <h1>😂 Meme Browser</h1>

      {loading ? (
        <div className="loading">Fetching meme...</div>
      ) : (
        <div className="card">
          <p className="meta">r/{meme.subreddit} · 👍 {meme.ups.toLocaleString()}</p>
          <h2>{meme.title}</h2>
          <img src={meme.url} alt={meme.title} />
        </div>
      )}

      <button onClick={fetchMeme} disabled={loading}>
        {loading ? "Loading..." : "Next Meme →"}
      </button>
    </div>
  );
}

export default App;