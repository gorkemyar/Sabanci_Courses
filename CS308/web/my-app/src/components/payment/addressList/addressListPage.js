import * as React from "react";
import AddressListHeader from "./addressListHeader";
import AddressListTabBar from "./addressListTabBar";
import { ThemeProvider, Box } from "@mui/material";
import themeOptions from "../../style/theme";
import AddressListSummary from "./addressListSummary";
import { CssBaseline, Stack } from "@mui/material";
import Footer from "../../footer/Footer";
import { useState, useEffect } from "react";

const AddressListPage = () => {
  const [addressId, setAddressId] = useState(-1);
  const addressIdHolder = (id) => {
    setAddressId(id);
    //console.log(id);
  };
  return (
    <ThemeProvider theme={themeOptions}>
      <CssBaseline />
      <Box sx={{ ml: 12, mr: 12 }}>
        <AddressListHeader></AddressListHeader>
        <Stack direction="row" justifyContent="center" spacing={4}>
          <AddressListTabBar
            isAddress={true}
            addressId={addressIdHolder}
          ></AddressListTabBar>
          <AddressListSummary
            isAddress={true}
            buttonText={"Go To Payment"}
            link={"/payment"}
            addressId={addressId}
          ></AddressListSummary>
        </Stack>
        <Footer bgcolor={"#FFFFF"}></Footer>
      </Box>
    </ThemeProvider>
  );
};

export default AddressListPage;

/*
      <Box sx={{ml: 12, mr: 12}}>
        <AddressListHeader></AddressListHeader>
        <Box
          sx={{
            mt: 2,
            mb: 2,
            ml: 16,
            mr: 16,
            display: "grid",
            gap: 4,
            gridTemplateColumns: "auto auto auto auto auto auto",
            gridColumn: "1 / 3",
          }}
        >
          <Box sx={{ gridColumn: "span 5" }}>
            <AddressListTabBar></AddressListTabBar>
          </Box>

          <AddressListSummary></AddressListSummary>
        </Box>
      </Box>
*/
