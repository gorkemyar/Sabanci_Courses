import * as React from "react";
import CardMedia from "@mui/material/CardMedia";
import { Link } from "react-router-dom";
export default function MediaCard(props) {
  return (
    <Link to="/Dummy" underline="none">
      <CardMedia
        component="img"
        height="400"
        image={`furn${props.myId + 1}.jpg`}
        alt="Voidture no Item"
      />
    </Link>
  );
}
