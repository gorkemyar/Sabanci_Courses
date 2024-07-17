import * as React from "react";
import Card from "@mui/material/Card";

import CardMedia from "@mui/material/CardMedia";

import Typography from "@mui/material/Typography";

import themeOptions from "../../style/theme";
import { ThemeProvider } from "@emotion/react";
import { Link } from "react-router-dom";
import CardContent from "@mui/material/CardContent";

const DiscountItem = (props) => {
  //console.log(props.img);
  return (
    <ThemeProvider theme={themeOptions}>
      <Card sx={{ maxWidth: 400 }} key={123131241}>
        <Link to="/Dummy" underline="none">
          <CardMedia
            component="img"
            image={props.img}
            alt="Voidture not Found"
          />
        </Link>
      </Card>
    </ThemeProvider>
  );
};

export default DiscountItem;
