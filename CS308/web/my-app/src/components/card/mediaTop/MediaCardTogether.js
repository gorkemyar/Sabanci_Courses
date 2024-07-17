import * as React from "react";
import Card from "@mui/material/Card";
import MediaCardHandler from "./MediaCardHandler";
const MediaCardTogether = () => {
  return (
    <Card
      sx={{
        bgcolor: "background.paper",
        boxShadow: 1,
        borderRadius: 2,
        p: 2,
        minWidth: 300,
      }}
    >
      <MediaCardHandler />
    </Card>
  );
};

export default MediaCardTogether;
