import * as React from "react";
import { styled, useTheme, alpha } from "@mui/material/styles";
import Box from "@mui/material/Box";
import { Link } from "react-router-dom";
import CssBaseline from "@mui/material/CssBaseline";
import { CardMedia, Card } from "@mui/material";

const drawerWidth = 240;

const DrawerHeader = styled("div")(({ theme }) => ({
  display: "flex",
  alignItems: "center",
  padding: theme.spacing(0, 1),
  // necessary for content to be below app bar
  ...theme.mixins.toolbar,
  justifyContent: "flex-start",
}));

const CardHalf = (props) => {
  const theme = useTheme();
  const open = true;

  return (
    <Box sx={{ display: "flex" }}>
      <CssBaseline />
      <Card
        sx={{
          width: 500,
          flexShrink: 0,
          "& .MuiDrawer-paper": {
            width: drawerWidth,
          },
        }}
        variant="persistent"
        anchor={props.way}
        open={open}
      >
        <Link to="/Dummy" underline="none">
          <CardMedia
            component="img"
            height="400"
            image={`furn${1}.jpg`}
            alt="Voidture no Item"
          />
        </Link>
      </Card>
    </Box>
  );
};
export default CardHalf;
