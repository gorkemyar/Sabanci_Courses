import * as React from "react";
import { styled } from "@mui/material/styles";
import Card from "@mui/material/Card";
import CardHeader from "@mui/material/CardHeader";
import CardMedia from "@mui/material/CardMedia";
import CardContent from "@mui/material/CardContent";
import CardActions from "@mui/material/CardActions";
import ShoppingBasketOutlinedIcon from "@mui/icons-material/ShoppingBasketOutlined";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import FavoriteIcon from "@mui/icons-material/Favorite";
import CommentIcon from "@mui/icons-material/Comment";
import themeOptions from "../../../theme";
import { ThemeProvider } from "@emotion/react";
import { Box, Stack } from "@mui/material";
import { Link } from "react-router-dom";

const ExpandMore = styled((props) => {
  const { expand, ...other } = props;
  return <IconButton {...other} />;
})(({ theme, expand }) => ({
  transform: !expand ? "rotate(0deg)" : "rotate(180deg)",
  marginLeft: "auto",
  transition: theme.transitions.create("transform", {
    duration: theme.transitions.duration.shortest,
  }),
}));

const CardItem = () => {
  const [expanded, setExpanded] = React.useState(false);

  const handleExpandClick = () => {
    setExpanded(!expanded);
  };

  return (
    <ThemeProvider theme={themeOptions}>
      <Card sx={{ maxWidth: 400 }}>
        <CardHeader
          title="item title not necessary deletable"
          subheader="Until when promotion continues"
        />
        <Link to="/Dummy" underline="none">
          <CardMedia
            component="img"
            height="194"
            image={`furn4.jpg`}
            alt="Voidture not Found"
          />
        </Link>
        <CardContent>
          <Typography variant="body2" color="text.secondary">
            This place will consist the information about item and the money
          </Typography>
        </CardContent>
        <Box sx={{ flexGrow: 1, display: { xs: "none", md: "inline" } }}>
          <Stack direction="row" justifyContent="space-evenly" spacing={2}>
            <CardActions sx={{ display: { xs: "none", md: "inline" } }}>
              <IconButton aria-label="add to favorites">
                <FavoriteIcon />
              </IconButton>
              <IconButton aria-label="share">
                <ShoppingBasketOutlinedIcon />
              </IconButton>
              <IconButton aria-label="share">
                <CommentIcon />
              </IconButton>
            </CardActions>
          </Stack>
        </Box>
      </Card>
    </ThemeProvider>
  );
};
export default CardItem;
