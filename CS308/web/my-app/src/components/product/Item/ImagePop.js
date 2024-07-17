import React from "react";
import { Card, Button, Stack, CardMedia } from "@mui/material";
import classes from "./ImagePop.module.css";
import CloseIcon from "@mui/icons-material/Close";
const ImagePop = (props) => {
  console.log(props.id);
  return (
    <div>
      <div className={classes.backdrop} onClick={props.onConfirm} />
      <Card className={classes.modal}>
        <Stack
          spacing={0}
          justifycontent="right"
          display="flex"
          direction="column"
          sx={{ padding: (1, 1, 1, 1) }}
        >
          <Button onClick={props.onConfirm}>
            <CloseIcon></CloseIcon>
          </Button>

          <Card justifycontent="right" display="flex" direction="column">
            <CardMedia
              component="img"
              height="300"
              image={props.img}
              alt="Image Not Fount"
            />
          </Card>
        </Stack>
      </Card>
    </div>
  );
};

export default ImagePop;
