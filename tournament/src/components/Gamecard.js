import React from "react";
import { CardGroup, Card } from "react-bootstrap";
import "./gameCard.css";

function Gamecard(props) {
  return (
    <CardGroup className="cardflex" style={{width: "20rem"}}>
      <Card>
        <Card.Img variant="top" src={props.backgroundImg} />
        <Card.Body className="bodywrapper">
          <Card.Title>{props.name}</Card.Title>
          <div>
            <Card.Subtitle className="mb-2 text-muted">rating</Card.Subtitle>
            <Card.Text className="ratingSize">
              {props.rating} / {props.ratingTop}
            </Card.Text>
          </div>
        <div className="rating_wrapper">
            <div>
            <Card.Text>{props.ratings1title}</Card.Text>
            <Card.Text>{props.ratings1percent}</Card.Text>
            <Card.Text>
              {props.ratings1count} / {props.ratingsCount}
            </Card.Text>
            </div>
            <div>
            <Card.Text>{props.ratings2title}</Card.Text>
            <Card.Text>{props.ratings2percent}</Card.Text>
            <Card.Text>
              {props.ratings2count} / {props.ratingsCount}
            </Card.Text>
            </div>
        </div>
        </Card.Body>
        <Card.Footer>
          <small className="text-muted"></small>
        </Card.Footer>
      </Card>
      </CardGroup>

      
    

        // <Card style={{ width: "20rem" }}>
        //   <Card.Img variant="top" src="https://via.placeholder.com/150" />
        //   <Card.Body className="bodywrapper">
        //     <Card.Title>{props.title}</Card.Title>
        //     <div>
        //       <Card.Subtitle className="mb-2 text-muted">rating</Card.Subtitle>
        //       <Card.Text className="ratingSize">
        //         {props.rating} / {props.ratingTop}
        //       </Card.Text>
        //     </div>

        //     <div className="rating_wrapper">
        //       <div>

        //         <Card.Text>{props.ratings1title}</Card.Text>
        //         <Card.Text>{props.ratings1percent}</Card.Text>
        //         <Card.Text>
        //           {props.ratings1count} / {props.ratingsCount}
        //         </Card.Text>
        //       </div>
        //       <div>
        //         <Card.Text>{props.ratings2title}</Card.Text>
        //         <Card.Text>{props.ratings2percent}</Card.Text>
        //         <Card.Text>
        //           {props.ratings2count} / {props.ratingsCount}
        //         </Card.Text>
        //       </div>
        //       <div>
        //         <Card.Text>{props.ratings3title}</Card.Text>
        //         <Card.Text>{props.ratings3percent}</Card.Text>
        //         <Card.Text>
        //           {props.ratings3count} / {props.ratingsCount}
        //         </Card.Text>
        //       </div>
        //     </div>

        //   </Card.Body>
        // </Card>
    
  );
}

export default Gamecard;

// key={game.id}
// id={game.id}
// name={game.name}
// backgroundImg={game.background_img}
// rating={game.rating}
// ratingTop={game.rating_top}
// ratings1title={game.ratings[0].title}
// ratings1percent={game.ratings[0].percent}
// ratings1count={game.ratings[0].count}
// ratings2title={game.ratings[1].title}
// ratings2percent={game.ratings[1].percent}
// ratings2count={game.ratings[1].count}
// ratings3title={game.ratings[2].title}
// ratings3percent={game.ratings[2].percent}
// ratings3count={game.ratings[2].count}
// ratingsCount={game.ratings}
