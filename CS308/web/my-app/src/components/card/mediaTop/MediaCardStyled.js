import React from "react";
import Carousel from "react-material-ui-carousel";
import { Paper, Button } from "@mui/material";
import CardMedia from "@mui/material/CardMedia";
import { Link } from "react-router-dom";

import "./carousel.css";

export default function MediaCardStyled(props) {
  var items = [
    { image: "furn1.jpg", description: "furn1" },
    { image: "furn2.jpg", description: "furn2" },
    { image: "furn3.jpg", description: "furn3" },
    { image: "furn4.jpg", description: "furn4" },
    { image: "furn5.jpg", description: "furn5" },
    { image: "furn6.jpg", description: "furn6" },
  ];

  return (
    <Carousel sx={{ zIndex: "0" }} className="carousel">
      {items.map((item, i) => (
        <Item key={i} item={item} />
      ))}
    </Carousel>
  );
}

function Item(props) {
  return (
    <Link to="/" underline="none" sx={{ zIndex: "0" }}>
      <CardMedia
        component="img"
        height={450}
        image={props.item.image}
        alt={props.item.description}
        sx={{ zIndex: "0" }}
      ></CardMedia>
    </Link>
  );
}
