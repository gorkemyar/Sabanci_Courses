import AddressListHeader from "../addressList/addressListHeader";
import AddressListTabBar from "../addressList/addressListTabBar";
import { ThemeProvider, Box } from "@mui/material";
import themeOptions from "../../style/theme";
import AddressListSummary from "../addressList/addressListSummary";
import PaymentSummary from "./PaymentSummary";
import { CssBaseline, Stack } from "@mui/material";
//import Footer from "../../footer/Footer";

const paymentPage = () => {
  return (
    <ThemeProvider theme={themeOptions}>
      <CssBaseline />
      <Box sx={{ ml: 12, mr: 12 }}>
        <AddressListHeader></AddressListHeader>
        <Stack direction="row" justifyContent="center" spacing={4}>
          <AddressListTabBar
            isAddress={false}
            addressId={() => {}}
          ></AddressListTabBar>
          <PaymentSummary
            totalCost={1000}
            isAddress={false}
            buttonText={"MAKE PAYMENT"}
            link={"/payment-success"}
            addressId={0}
          ></PaymentSummary>
        </Stack>
      </Box>
    </ThemeProvider>
  );
};

export default paymentPage;

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
