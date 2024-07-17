import React from "react";
import ProfilePageContainer from "./profilePageContainer";
import AddressListGetOld from "../payment/addressList/addressListGetOld";
import { Box } from "@mui/system";
import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import PaymentAddNew from "../payment/creditCard/paymentAddNew";
import { Typography } from "@mui/material";
import { useState, useEffect } from "react";
import { getData } from "../recoils/getterFunctions";

const UpdatePaymentPage = () => {
  const [isLoaded, setLoaded] = useState(false);

  const [addressList, setAddressList] = useState([]);
  useEffect(() => {
    getData("http://164.92.208.145/api/v1/user/credit").then((res) => {
      res.data.push({
        payment_method: "Add New Payment Method",
      });

      //console.log(res.data);
      setAddressList(res.data);
      setLoaded(true);
    });
  }, []);

  const [open, setOpen] = React.useState(false);
  const [dialogTitle, setDialogTitle] = React.useState("");
  const [dialogContent, setDialogContent] = React.useState("");

  const handleClickOpen = (event) => {
    console.log(event.currentTarget.getAttribute("id"));
    if (event.currentTarget.getAttribute("id") === "-1") {
      setDialogTitle("Add New Address");
      setDialogContent();
    } else {
      setDialogTitle("Edit Address");
      setDialogContent(addressList[event.currentTarget.getAttribute("id")]);
    }
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const addressWidget = (
    <div>
      {addressList.map((address, index) => {
        return (
          <div key={`a${index}`} style={{ display: "inline-flex" }}>
            <AddressListGetOld
              key={address["id"]}
              isProfile={true}
              isNew={index === addressList.length - 1 ? true : false}
              title={address["payment_method"]}
              description={address["card_number"]}
              postal_code={address["card_name"]}
              province={address["CW"]}
              city={address["expiry_date"]}
              id={address["id"]}
              link={"http://164.92.208.145/api/v1/user/credit/"}
              onClick={handleClickOpen}
            />
          </div>
        );
      })}

      <Box sx={{ mt: 20, ml: 5, mr: 5 }}>
        <Typography color="text.secondary">
          The payment infrastructure for Voidture Inc. is provided by
          MasterCard.
        </Typography>
        <img src="/masterpass.png" width={300} alt="Mastercard" />
      </Box>

      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{dialogTitle}</DialogTitle>
        <DialogContent>
          <PaymentAddNew data={dialogContent} />
        </DialogContent>
      </Dialog>
    </div>
  );

  return (
    <ProfilePageContainer
      pageIndex={4}
      widget={isLoaded ? addressWidget : <div>Loading...</div>}
    ></ProfilePageContainer>
  );
};

export default UpdatePaymentPage;
