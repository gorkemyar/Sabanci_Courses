import * as React from "react";
import Box from "@mui/material/Box";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import Divider from "@mui/material/Divider";
import InboxIcon from "@mui/icons-material/Inbox";
import DraftsIcon from "@mui/icons-material/Drafts";
import { Link } from "react-router-dom";
import { Paper } from "@mui/material";

const Column = (props) => {
  const columnItems = props.columnItems;
  console.log(props.catId);
  const catId = props.catId;

  return (
    <Box sx={{}}>
      <nav aria-label="category-items">
        <List dense>
          {columnItems.map((item) => (
            <ListItem key={item.id}>
              <Link
                to={`/Categories/${item.title}`}
                state={{ catId: catId, subId: item.id, name: item.title }}
                style={{
                  textDecoration: "none",
                  color: "black",
                }}
              >
                <ListItemButton>
                  <ListItemText primary={item.title} />
                </ListItemButton>
              </Link>
            </ListItem>
          ))}
        </List>
      </nav>
    </Box>
  );
};

export default Column;
