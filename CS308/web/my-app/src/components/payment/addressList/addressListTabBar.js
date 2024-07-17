import * as React from "react";
import AddressListTabBarCard from "./addressListTabBarCard";
import { Grid } from "@mui/material";
import { Stack, Box } from "@mui/material";
import AddressListForm from "./addressListForm";
import PaymentForm from "../creditCard/paymentForm";
import { useState, useEffect } from "react";
/*
const addressListTabBar = () => {
    return <div>
        <Grid container spacing={0}
        >
            <Grid item xs={6}>
        <AddressListTabBarCard/>
            </Grid>
            <Grid item xs={6}>
        <AddressListTabBarCard/>
        </Grid>
       </Grid>
        
    </div>

}
*/

const AddressListTabBar = (props) => {
  const [addressId, setAddressId] = useState(-1);
  const addressIdHolder = (id) => {
    setAddressId(id);
    //console.log(id);
  };

  useEffect(() => {
    props.addressId(addressId);
  }, [addressId]);
  return (
    <Box sx={{ bgcolor: "#FFFFFF" }}>
      <Stack direction="column">
        <Stack direction="row">
          <AddressListTabBarCard
            title="ADDRESS INFORMATION"
            description="Select a saved address or create a new address."
            isOpen={props.isAddress}
            direction={"address"}
          />
          <AddressListTabBarCard
            title="PAYMENT INFORMATION"
            description="Select a saved credit card or enter your credit card information."
            isOpen={!props.isAddress}
            direction={"card"}
          />
        </Stack>
        {props.isAddress ? (
          <AddressListForm addressIdHolder={addressIdHolder} />
        ) : (
          <PaymentForm />
        )}
      </Stack>
    </Box>
  );
};

export default AddressListTabBar;
