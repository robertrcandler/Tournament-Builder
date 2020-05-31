import React, { useState, useEffect } from "react";
import Gamecard from "./components/Gamecard";
import "./home.css";
import axios from "axios";

function Home() {
  // const fakedata = [
  //   {
  //     id: 1,
  //     name: "Grand Theft Auto",
  //     background_image: "https://via.placeholder.com/150",
  //     rating: 4,
  //     rating_top: 5,
  //     ratings: [
  //       {
  //         title: "exceptional",
  //         count: 130,
  //         percent: 88,
  //       },
  //       {
  //         title: "recommended",
  //         count: 130,
  //         percent: 88,
  //       },
  //       {
  //         title: "meh",
  //         count: 130,
  //         percent: 88,
  //       },
  //     ],
  //     ratings_count: 3890,
  //   },
  //   {
  //     id: 2,
  //     name: "Destiny 2",
  //     background_image: "https://via.placeholder.com/150",
  //     rating: 4,
  //     rating_top: 5,
  //     ratings: [
  //       {
  //         title: "exceptional",
  //         count: 130,
  //         percent: 88,
  //       },
  //       {
  //         title: "recommended",
  //         count: 130,
  //         percent: 88,
  //       },
  //       {
  //         title: "meh",
  //         count: 130,
  //         percent: 88,
  //       },
  //     ],
  //     ratings_count: 3890,
  //   },
  // ];

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
        for (let i = 0; i < 5; i++) {
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
      <h2>TOP 5 RATED GAMES</h2>
      <p></p>
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

export default Home;
