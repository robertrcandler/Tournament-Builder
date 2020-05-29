import React from "react";
import Gamecard from "./components/Gamecard";

function Home() {
  const fakedata = [
    {
      id: 1,
      name: "Grand Theft Auto",
      background_img: "https://via.placeholder.com/150",
      rating: 4,
      rating_top: 5,
      ratings: [
        {
          title: "exceptional",
          count: 130,
          percent: 88,
        },
        {
          title: "recommended",
          count: 130,
          percent: 88,
        },
        {
          title: "meh",
          count: 130,
          percent: 88,
        },
      ],
      ratings_count: 3890,
    },
    {
      id: 2,
      name: "Destiny 2",
      background_img: "https://via.placeholder.com/150",
      rating: 4,
      rating_top: 5,
      ratings: [
        {
          title: "exceptional",
          count: 130,
          percent: 88,
        },
        {
          title: "recommended",
          count: 130,
          percent: 88,
        },
        {
          title: "meh",
          count: 130,
          percent: 88,
        },
      ],
      ratings_count: 3890,
    },
  ];
  return (
    <div>
      <h2>Render Games Here</h2>
      <p>scrolling Games Go Here</p>
      {fakedata.map((game) => (
        <Gamecard
          key={game.id}
          id={game.id}
          name={game.name}
          backgroundImg={game.background_img}
          rating={game.rating}
          ratingTop={game.rating_top}
          ratings1title={game.ratings[0].title}
          ratings1percent={game.ratings[0].percent}
          ratings1count={game.ratings[0].count}
          ratings2title={game.ratings[1].title}
          ratings2percent={game.ratings[1].percent}
          ratings2count={game.ratings[1].count}
          ratings3title={game.ratings[2].title}
          ratings3percent={game.ratings[2].percent}
          ratings3count={game.ratings[2].count}
          ratingsCount={game.ratings_count}
        />
      ))}
    </div>
  );
}

export default Home;
