import * as React from "react";
import { styled, useTheme, alpha } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Drawer from "@mui/material/Drawer";

import CssBaseline from "@mui/material/CssBaseline";
import List from "@mui/material/List";
import Divider from "@mui/material/Divider";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
import ListItem from "@mui/material/ListItem";
import { Link } from "react-router-dom";
import { Typography, Button, ThemeProvider, Stack } from "@mui/material";
import SmallItem from "./SmallItem";
import themeOptions from "../../style/theme";
import {
  createShoppingDict,
  getDataWithoutAccess,
  getData,
  createOrderCookie,
} from "../../recoils/getterFunctions";
import { useState, useEffect } from "react";
import { loggedState } from "../../recoils/atoms";
import {
  RecoilRoot,
  atom,
  selector,
  useRecoilState,
  useRecoilValue,
} from "recoil";
//document.cookie = "orderList=";
let mydict = createShoppingDict();

const drawerWidth = 240;
const DrawerHeader = styled("div")(({ theme }) => ({
  display: "flex",
  alignItems: "center",
  padding: theme.spacing(0, 1),
  // necessary for content to be below app bar
  ...theme.mixins.toolbar,
  justifyContent: "flex-start",
}));

const SmallShopCard = (props) => {
  const [isLoaded, setLoaded] = useState(false);
  const [products, setProducts] = useState([]);
  const [isLoggin, setIsLogged] = useRecoilState(loggedState);
  console.log(mydict);

  useEffect(() => {
    for (let proId in mydict) {
      console.log(proId);
      //console.log(proId);
      getDataWithoutAccess(
        `http://164.92.208.145/api/v1/products/${proId}`
      ).then((res) => {
        //console.log(res.data);
        if (res.data.stock < mydict[res.data.id]) {
          mydict[res.data.id] = res.data.stock;
          if (!isLoggin) {
            createOrderCookie(mydict);
          }
        }
        setProducts((prev) => {
          return [...prev, res.data];
        });
      });
    }
    setLoaded(true);
  }, []);

  console.log(products);
  const removeCardHandler = (id) => {
    delete mydict[id];
    if (!isLoggin) {
      createOrderCookie(mydict);
    }
  };
  const theme = useTheme();
  const open = true;
  let totalCost = 0;
  return (
    <ThemeProvider theme={themeOptions}>
      <Box sx={{ display: "flex" }}>
        <CssBaseline />
        <Drawer
          sx={{
            width: drawerWidth,
            flexShrink: 0,
            "& .MuiDrawer-paper": {
              width: drawerWidth,
            },
          }}
          variant="persistent"
          anchor="right"
          open={open}
        >
          <DrawerHeader sx={{ backgroundColor: "#ff6600" }}>
            <Typography variant="h6">Shopping Basket</Typography>
            <Box sx={{ marginLeft: "auto" }}>
              <IconButton onClick={props.onConfirm}>
                <CloseIcon></CloseIcon>
              </IconButton>
            </Box>
          </DrawerHeader>
          <Divider />
          <List>
            {products.map((card) => (
              <ListItem button key={card.key}>
                <SmallItem
                  imageId={
                    card.photos[0] != null ? card.photos[0].photo_url : ""
                  }
                  model={card.model}
                  number={card.number}
                  cost={card.price}
                  description={card.description}
                  title={card.title}
                  id={card.id}
                  stock={card.stock}
                  count={mydict[card.id]}
                  delete={() => {
                    removeCardHandler(card.id);
                  }}
                >
                  {(totalCost += card.cost)}
                </SmallItem>
              </ListItem>
            ))}
          </List>
          <Divider variant="fullWidth" />
          <Box sx={{ m: 2 }} />
          <Typography variant="body2" sx={{ color: "black" }}>
            The total cost is {totalCost}$.
          </Typography>
          <Stack justifyContent="center" alignItems="center">
            <Link
              to="/Dummy"
              style={{
                textDecoration: "none",
                color: "black",
                justifyContent: "center",
              }}
            >
              <Link
                to="/Basket"
                style={{ textDecoration: "none", color: "black" }}
              >
                <Button
                  sx={{
                    backgroundColor: "#ff6600",
                    display: "block",
                    padding: (8, 1, 8, 1),
                  }}
                >
                  <Typography sx={{ color: "#000000" }}>My Basket</Typography>
                </Button>
              </Link>
            </Link>
          </Stack>
        </Drawer>
      </Box>
    </ThemeProvider>
  );
};
export default SmallShopCard;
