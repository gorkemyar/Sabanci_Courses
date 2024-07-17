import * as React from "react";
import { styled } from "@mui/material/styles";
import Card from "@mui/material/Card";
import CardMedia from "@mui/material/CardMedia";
import CardActions from "@mui/material/CardActions";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import DeleteOutlinedIcon from "@mui/icons-material/DeleteOutlined";
import themeOptions from "../../style/theme";
import { ThemeProvider } from "@emotion/react";
import { Box, Stack, Divider, Grid } from "@mui/material";
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

const SmallItem = (props) => {
  const [expanded, setExpanded] = React.useState(false);
  const removeHandler = () => {
    props.delete(props.id);
  };
  return (
    <ThemeProvider theme={themeOptions}>
      <Card sx={{ maxWidth: 500, maxHeight: 500 }}>
        <Stack direction="row" spacing={2} sx={{ height: "40px" }}>
          <Grid container spacing={2}>
            <Grid item key={1} xs={12} sm={6} md={6}>
              <Link to="/Dummy" underline="none">
                <CardMedia
                  component="img"
                  height="100"
                  width="100"
                  image={props.imageId}
                  alt="Voidture not Found"
                />
              </Link>
            </Grid>
            <Grid item key={2} xs={12} sm={6} md={6}>
              <Stack>
                <Typography variant="body1">{props.title}</Typography>
                <Divider />
                <Typography variant="body2">{props.description}</Typography>
              </Stack>
            </Grid>
          </Grid>
        </Stack>
        <Box sx={{ m: 8 }} />
        <Stack
          direction="row"
          justifyContent="space-evenly"
          spacing={2}
          sx={{ height: "30px" }}
        >
          <Typography variant="body2" color="text.secondary" fontWeight="bold">
            {props.cost}$
          </Typography>
          <CardActions>
            <IconButton aria-label="share" onClick={removeHandler}>
              <DeleteOutlinedIcon />
            </IconButton>
          </CardActions>
        </Stack>
        <Divider />
      </Card>
    </ThemeProvider>
  );
};
export default SmallItem;
