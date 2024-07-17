import * as React from "react";
import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Menu from "@mui/material/Menu";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";
import MenuItem from "@mui/material/MenuItem";
import { useState, useEffect, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { Popper, Stack } from "@mui/material";
import DropDownMenu from "./categories/DropDownMenu";
import { ClickAwayListener } from "@mui/material";

const AppBarUnder = () => {
  const [pages, setData] = useState([]);
  const [isLoaded, setIsLoaded] = useState(false);
  const [isLoaded2, setIsLoaded2] = useState(false);
  const getData = async () => {
    //const { data } = await axios.get("http://localhost:8000/customMockData/1");

    const { data } = await axios({
      method: "get",
      url: "http://164.92.208.145/api/v1/categories/?skip=0&limit=100",
      withCredentials: false,
    });

    setData(data.data);
    console.log(data.data);
    setIsLoaded(true);
  };

  useEffect(() => {
    getData();
  }, []);
  /*
  useEffect(() => {
    if (isLoaded) {
      let tmp = pages[4];
      pages.map((page, index) => {
        pages[4 - index] = pages[3 - index];
      });
      pages[0] = tmp;

      setIsLoaded2(true);
    }
  }, [isLoaded]);
  */
  const [anchorElNav, setAnchorElNav] = React.useState(null);
  const [openPopper, setOpenPopper] = React.useState(false);
  const handleOpenNavMenu = (event) => {
    setAnchorElNav(event.currentTarget);
  };

  const handleCloseNavMenu = () => {
    setAnchorElNav(null);
  };

  const [anchorEl, setAnchorEl] = React.useState(null);
  const [img, setImg] = React.useState();
  const [subs, setSubs] = React.useState();
  const [categoryId, setCategoryId] = React.useState();
  const HandleClick = (props) => {
    console.log(props.imga);
    setImg(props.imga);
  };

  const navigate = useNavigate();
  const handleOnClick = useCallback(
    (title, id) => navigate(`/Categories/${title}${id}`),
    [navigate]
  );

  const handleClickAway = (e) => {
    if (e.target.type !== "button") setOpenPopper(false);
  };

  const handleClick = (imga, sub, id) => {
    setOpenPopper(true);

    setAnchorEl(anchorEl ? null : document.getElementById("myStack"));
    setImg(imga);
    setSubs(sub);
    setCategoryId(id);
  };

  const open = Boolean(anchorEl);
  const id = open ? "simple-popper" : undefined;
  //console.log(pages);
  return (
    <div>
      <AppBar position="static" color="inherit" id="myStack">
        <Container maxWidth="false">
          <Toolbar disableGutters>
            <Box sx={{ flexGrow: 1, display: { xs: "flex", md: "none" } }}>
              <IconButton
                size="medium"
                aria-label="account of current user"
                aria-controls="menu-appbar"
                aria-haspopup="true"
                onClick={handleOpenNavMenu}
                color="inherit"
              ></IconButton>
              <Menu
                id="menu-appbar"
                anchorEl={anchorElNav}
                anchorOrigin={{
                  vertical: "bottom",
                  horizontal: "left",
                }}
                keepMounted
                transformOrigin={{
                  vertical: "top",
                  horizontal: "left",
                }}
                open={Boolean(anchorElNav)}
                onClose={handleCloseNavMenu}
                sx={{
                  display: { xs: "block", md: "none" },
                }}
              >
                {pages.map((page) => (
                  // todo : handleCloseNavMenu
                  <MenuItem key={page.title} onClick={handleCloseNavMenu}>
                    <Typography textAlign="center">{page.title}</Typography>
                  </MenuItem>
                ))}
              </Menu>
            </Box>

            <Box
              sx={{
                flexGrow: 1,
                paddingBottom: 0,
                display: { xs: "none", md: "inline" },
              }}
            >
              <Stack
                direction="row"
                justifyContent="space-around"
                paddingBottom="0"
              >
                {isLoaded ? (
                  pages.map((page, i) => (
                    <Button
                      aria-describedby={id}
                      onDoubleClick={() => {
                        handleOnClick(page.title, page.id);
                      }}
                      onClick={() => {
                        handleClick(
                          page.image_url,
                          page.subcategories,
                          page.id
                        );
                      }}
                      key={i}
                      sx={{ my: 2, color: "white", display: "block" }}
                    >
                      {page.title}
                    </Button>
                  ))
                ) : (
                  <div>Loading...</div>
                )}
              </Stack>
            </Box>
          </Toolbar>
        </Container>
      </AppBar>

      <ClickAwayListener onClickAway={handleClickAway}>
        <Box>
          {openPopper && (
            <Popper
              id={id}
              open={open}
              anchorEl={anchorEl}
              placement="bottom-start"
              sx={{ display: "block", width: "100%" }}
            >
              <DropDownMenu img={img} sub={subs} catId={categoryId} />
            </Popper>
          )}
        </Box>
      </ClickAwayListener>
    </div>
  );
};
export default AppBarUnder;
