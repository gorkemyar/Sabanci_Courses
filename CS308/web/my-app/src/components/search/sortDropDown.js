import * as React from "react";
import themeOptions from "../style/theme";
import { Typography, Menu, MenuItem, Button } from "@mui/material";
export default function SortDropDown(props) {
  const [buttonText, setButtonText] = React.useState("Sort");
  const [anchorEl, setAnchorEl] = React.useState(null);
  const open = Boolean(anchorEl);
  const handleSelect = (event) => {
    handleClose();
    props.handleSort(event.target.value);
    if (event.target.value === 0) {
      setButtonText("Sort by: Default");
    } else if (event.target.value === 1) {
      setButtonText("Sort by: Price (Low to High)");
    } else if (event.target.value === 2) {
      setButtonText("Sort by: Price (High to Low)");
    } else if (event.target.value === 3) {
      setButtonText("Sort by: Popularity");
    } else {
      setButtonText("Sort by: Default");
    }
  };

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };

  return (
    <div>
      <Button
        id="sort-button"
        aria-controls={open ? "sort-menu" : undefined}
        aria-haspopup="true"
        aria-expanded={open ? "true" : undefined}
        onClick={handleClick}
        variant="contained"
        sx={{
          backgroundColor: themeOptions.palette.secondary.main,
          display: "block",
          padding: (8, 1, 8, 1),
          mb: 2,
          justify: "center",
          borderRadius: "0",
          pl: 4,
          pr: 4,
        }}
      >
        <Typography sx={{ color: "white" }}>{buttonText}</Typography>
      </Button>

      <Menu
        id="sort-menu"
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
        MenuListProps={{
          "aria-labelledby": "sort-button",
        }}
        elevation={1}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "right",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
      >
        <MenuItem onClick={handleSelect} value={0}>
          Default
        </MenuItem>
        <MenuItem onClick={handleSelect} value={1}>
          Price (Low to High)
        </MenuItem>
        <MenuItem onClick={handleSelect} value={2}>
          Price (High to Low)
        </MenuItem>
        <MenuItem onClick={handleSelect} value={3}>
          Popularity
        </MenuItem>
      </Menu>
    </div>
  );
}
