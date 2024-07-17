import * as React from "react";
import ImageList from "@mui/material/ImageList";
import ImageListItem from "@mui/material/ImageListItem";
import { useState } from "react";
import { ThemeProvider } from "@mui/styles";
import themeOptions from "../../style/theme";
import ImagePop from "./ImagePop";

function srcset(image, size, rows = 1, cols = 1) {
  return {
    src: `${image}?w=${size * cols}&h=${size * rows}&fit=crop&auto=format`,
    srcSet: `${image}?w=${size * cols}&h=${
      size * rows
    }&fit=crop&auto=format&dpr=2 2x`,
  };
}

export default function QuiltedImageList(props) {
  const [isPop, setIsPop] = useState(false);
  const [idM, setId] = useState();
  const [imgM, setImg] = useState();
  let items = props.images;
  //console.log(items);
  const itemData = [];
  items.map((item, index) => {
    itemData.push({
      key: item.id,
      img: item.photo_url,
      cols: index % 3 == 0 || index & (3 == 2) ? 2 : null,
      rows: index % 3 == 0 ? 2 : null,
    });
  });
  const clickHandler = (id, img) => {
    setId(id);
    setImg(img);
    setIsPop(true);
  };
  const closeHandler = () => {
    setIsPop(false);
  };
  return (
    <ThemeProvider theme={themeOptions}>
      <ImageList
        sx={{ width: 500, height: 450 }}
        variant="quilted"
        cols={4}
        rowHeight={121}
      >
        {itemData.map((item) => (
          <ImageListItem
            onClick={() => {
              clickHandler(item.key, item.img);
            }}
            key={item.key}
            cols={item.cols || 1}
            rows={item.rows || 1}
          >
            <img
              {...srcset(item.img, 121, item.rows, item.cols)}
              alt={item.title}
              loading="lazy"
            />
          </ImageListItem>
        ))}
      </ImageList>
      {isPop && (
        <ImagePop onConfirm={closeHandler} img={imgM} id={idM}></ImagePop>
      )}
    </ThemeProvider>
  );
}
