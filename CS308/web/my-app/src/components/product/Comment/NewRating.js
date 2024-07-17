import React from "react";

import {
  Card,
  Button,
  Typography,
  Stack,
  Grid,
  Rating,
  Box,
  TextField,
} from "@mui/material";
import classes from "../Item/ImagePop.module.css";
import axios from "axios";
import { getCookie } from "../../recoils/atoms";

const access = getCookie("access_token");

const NewRating = (props) => {
  const [value, setValue] = React.useState(0);

  const newRating = () => {
    let bodyContent = JSON.stringify({
      rate: Number(value),
    });
    axios
      .post(
        `http://164.92.208.145/api/v1/products/${props.id}/rate?rate=${value}`,
        bodyContent,
        {
          headers: {
            Accept: "*/*",
            Authorization: `Bearer ${access}`,
          },
        }
      )
      .then((response) => {
        console.log(response);
      })
      .catch((err) => {
        console.log(err);
      });
  };
  return (
    <div>
      <div className={classes.backdrop} />
      <Card className={classes.modal}>
        <Box sx={{ m: 2 }} />

        <Grid container justifyContent="center">
          <Typography component="legend">Rating</Typography>
          <Rating
            name="simple-controlled"
            value={value}
            onChange={(event, newValue) => {
              setValue(newValue);
            }}
          />
        </Grid>
        <Box sx={{ m: 2 }} />
        <Stack direction="row">
          <Button
            onClick={props.onCancel}
            variant="contained"
            sx={{
              backgroundColor: "#ff6600",
              display: "block",
              padding: (8, 1, 8, 1),
              justify: "right",
              align: "right",
            }}
          >
            <Typography sx={{ color: "black" }}>Cancel</Typography>
          </Button>
          <Grid container justifyContent="flex-end">
            <Button
              onClick={() => {
                newRating();
                props.onRating(value);
              }}
              variant="contained"
              sx={{
                backgroundColor: "#ff6600",
                display: "block",
                padding: (8, 1, 8, 1),
                justify: "flex-end",
                align: "right",
              }}
            >
              <Typography sx={{ color: "black" }}>Confirm Comment</Typography>
            </Button>
          </Grid>
        </Stack>
      </Card>
    </div>
  );
};

export default NewRating;
