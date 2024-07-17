import * as React from "react";
import Paper from "@mui/material/Paper";
import Divider from "@mui/material/Divider";
import { Box, Stack } from "@mui/material";
import Column from "./Column";
import DiscountItem from "./DiscountItem";
import { categoryId } from "../../recoils/atoms";
import { useRecoilState } from "recoil";
export default function DropDownMenu(props) {
  const subItems = props.sub;

  const subItems1 = subItems.slice(0, Math.ceil(subItems.length / 2));
  const subItems2 = subItems.slice(
    Math.ceil(subItems.length / 2),
    subItems.length
  );
  return (
    <Box
      bgcolor="#EBEBEB"
      sx={{ zIndex: "1090", width: "100%", display: "block" }}
    >
      <Stack
        direction="row"
        justifyContent="center"
        sx={{ pt: 4, pb: 4, pl: 2, pr: 2 }}
      >
        <Stack
          direction="row"
          justifyContent="flex-start"
          divider={<Divider orientation="vertical" />}
        >
          <Column columnItems={subItems1} catId={props.catId}></Column>
          <Column columnItems={subItems2} catId={props.catId}></Column>
        </Stack>
        <Box sx={{ width: 40 }}></Box>
        <Stack direction="row" justifyContent="flex-end">
          <DiscountItem img={props.img}></DiscountItem>
        </Stack>
      </Stack>
    </Box>
  );
}
