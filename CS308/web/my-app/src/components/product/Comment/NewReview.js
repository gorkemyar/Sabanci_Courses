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

const NewReview = (props) => {
  const [value, setValue] = React.useState(3);

  const addNewComment = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    const newComment = data.get("comment");
    //console.log(newComment);
    axios
      .post(
        `http://164.92.208.145/api/v1/products/${props.id}/comment`,
        {
          content: newComment,
          rate: value,
        },
        {
          headers: {
            Accept: "*/*",
            Authorization: `Bearer ${access}`,
          },
        }
      )
      .then((res) => {
        console.log(res);
        console.log(newComment);
      })
      .catch((err) => {
        console.log(err);
      });

    let bodyContent2 = JSON.stringify({
      rate: Number(value),
    });
    axios
      .post(
        `http://164.92.208.145/api/v1/products/${props.id}/rate?rate=${value}`,
        bodyContent2,
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
    props.onConfirm();
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
              console.log(newValue);
              document.cookie = `rating=${newValue};`;
            }}
          />
        </Grid>
        <Box sx={{ m: 2 }} />
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
          component="form"
          onSubmit={addNewComment}
          noValidate
        >
          <Grid container justifyContent="center">
            <TextField
              id="comment"
              label="Comment"
              name="comment"
              multiline
              minRows={5}
              fullWidth
              sx={{ padding: (1, 1, 1, 1) }}
            />
          </Grid>
          <Stack direction="row">
            <Button
              onClick={props.onCancel}
              variant="contained"
              sx={{
                backgroundColor: "#ff6600",
                display: "block",
                padding: (8, 1, 8, 1),
              }}
            >
              <Typography sx={{ color: "black" }}>Cancel</Typography>
            </Button>
            <Box sx={{ m: 1 }} />
            <Button
              type="submit"
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
          </Stack>
        </Box>
      </Card>
    </div>
  );
};

export default NewReview;
