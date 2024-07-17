import * as React from "react";
import Card from "@mui/material/Card";
import CardActions from "@mui/material/CardActions";
import CardContent from "@mui/material/CardContent";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import themeOptions from "../../style/theme";
import { Box, CardActionArea } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { Stack, Grid } from "@mui/material";
import axios from "axios";
import { getCookie } from "../../recoils/atoms";
const access = getCookie("access_token");

let headersList = {
  Authorization: `Bearer ${access}`,
};

export default function addressListGetOld(props) {
  const deleteHandler = (id, link) => {
    console.log(link, id);
    axios.delete(`${link}${id}`, {
      headers: headersList,
    });
  };

  if (props.isNew) {
    return (
      <Card
        sx={{
          width: props.isProfile ? 220 : 350,
          minHeight: 100,
          display: "block",
          borderRadius: 4,
          bgcolor: themeOptions.palette.secondary.dark,
          m: 1,
        }}
      >
        <CardContent sx={{ pb: 0, mb: 0 }}>
          <CardActionArea id={props.id} onClick={props.onClick}>
            <Typography
              variant="h6"
              component="div"
              sx={{ mb: 1 }}
              align="center"
            >
              {props.title}
            </Typography>
            <Stack direction="row" alignItems="center" justifyContent="center">
              <AddIcon style={{ fontSize: 90 }}></AddIcon>
            </Stack>{" "}
          </CardActionArea>
        </CardContent>
      </Card>
    );
  } else {
    return (
      <Card
        sx={{
          width: props.isProfile ? 220 : 350,
          minHeight: 100,
          display: "block",
          borderRadius: 4,
          bgcolor: themeOptions.palette.secondary.light,
          m: 1,
        }}
      >
        <CardContent>
          <Typography variant="h6" component="div" sx={{ mb: 1 }}>
            {props.title}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {props.description}
            <br />
          </Typography>

          <Grid container spacing={0}>
            <Grid item xs={12} sm={3}>
              <Typography variant="body2" color="text.secondary">
                {props.postal_code}
              </Typography>
            </Grid>
            <Grid item xs={12} sm={3}>
              <Typography variant="body2" color="text.secondary">
                {props.province}
              </Typography>
            </Grid>
            <Grid item xs={12} sm={3}>
              <Typography variant="body2" color="text.secondary">
                {props.city}
              </Typography>
            </Grid>
            <Grid item xs={12} sm={3}>
              <Typography variant="body2" color="text.secondary">
                {props.country}
              </Typography>
            </Grid>
          </Grid>
        </CardContent>
        <CardActions>
          <Box sx={{ display: { md: "block" } }}>
            <Button
              onClick={() => {
                deleteHandler(props.id, props.link);
              }}
              size="small"
            >
              Delete
            </Button>
          </Box>
        </CardActions>
      </Card>
    );
  }
}

/*

        {props.isProfile ? (
              <Button id={props.id} size="small" color="primary" onClick={props.onClick}>
                Edit
              </Button>
            ) : (
              <></>
            )}
*/
