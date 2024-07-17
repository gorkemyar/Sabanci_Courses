import * as React from "react";
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardActions from "@mui/material/CardActions";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import { useNavigate } from "react-router-dom";
import { useCallback } from "react";
import themeOptions from "../../style/theme";
export default function OutlinedCard(props) {
  const isOpen = props.isOpen;
  const direction = props.direction;
  let link = "/";
  if (direction === "address") {
    link = "/address-list";
  } else {
    link = "/payment";
  }
  const navigate = useNavigate();

  const handleOnClick = useCallback(() => navigate(link), [navigate]);

  const card = (
    <React.Fragment>
      <CardContent
        onClick={isOpen ? () => {} : handleOnClick}
        sx={{ maxWidth: 400, minHeight: 120 }}
      >
        <Typography
          variant="h6"
          component="div"
          fontWeight={550}
          color="primary.main"
        >
          {props.title}
        </Typography>
        <Typography sx={{ mb: 1 }}>{props.description}</Typography>
      </CardContent>
      <CardActions></CardActions>
    </React.Fragment>
  );

  return (
    <Card
      variant="outlined"
      sx={{
        bgcolor: isOpen ? "#FFFFFF" : themeOptions.palette.secondary.light,
        border: 0,
        borderRadius: 0,
      }}
    >
      {card}
    </Card>
  );
}
