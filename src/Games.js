import React, { useState, useEffect } from "react";
import Gamecard from "../components/Gamecard";
import "./home.css";
import axios from "axios";

function Games() {

  const [topGames, setTopGames] = useState([]);

  useEffect(() => {
    axios
      .get(
        `https://api.rawg.io/api/games?dates=2019-01-01,2019-12-31&ordering=-rating`,
        { headers: { "User-Agent": "TournaFinder" } }
      )
      .then((response) => {
        const results = [];
        console.log(response.data.results);
        for (let i = 6; i < 20; i++) {
          results.push(response.data.results[i])
        }
        setTopGames(results)
      })
      .catch(function (e) {
        console.log(e);
      });
  }, []);

  return (
    <div>
      <h2>Games</h2>
      <p>Scroll Down Through Games</p>
      <div className="gamecard-container">
        {topGames.length > 0 ?
        topGames.map((game) => (
          <Gamecard
            key={game.id}
            id={game.id}
            name={game.name}
            backgroundImg={game.background_image}
            rating={game.rating}
            ratingTop={game.rating_top}
            ratings1title={game.ratings[0].title}
            ratings1percent={game.ratings[0].percent}
            ratings1count={game.ratings[0].count}
            ratings2title={game.ratings[1].title}
            ratings2percent={game.ratings[1].percent}
            ratings2count={game.ratings[1].count}
            ratingsCount={game.ratings_count}
          />
        )) : <div> </div>}
      </div>
    </div>
  );
}

export default Games;

