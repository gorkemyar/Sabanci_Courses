import { ThemeProvider } from "@mui/material/styles";
import themeOptions from "../components/style/theme";
import PrimarySearchAppBar from "../components/header/AppBar";
import ResponsiveAppBar from "../components/header/AppBarUnder";
import Footer from "../components/footer/Footer";
import { Box } from "@mui/material";
import CardItemHandler from "../components/card/mediaMiddle/CardItemHandler";
import { RecoilRoot } from "recoil";
import { useParams, useLocation } from "react-router-dom";
import { useEffect, useState } from "react";
import { getDataWithoutAccess } from "../components/recoils/getterFunctions";

const CategoryProduct = () => {
  const [isLoaded, setLoaded] = useState(false);
  const [products, setProducts] = useState([]);

  const { type } = useParams();
  const stateParamValue = useLocation();
  const title =
    stateParamValue.state != null
      ? stateParamValue.state.name
      : type.substring(0, type.length - 1);

  const catId =
    stateParamValue.state != null
      ? stateParamValue.state.catId
      : Number(type[type.length - 1]);

  const subId =
    stateParamValue.state != null ? stateParamValue.state.subId : null;

  const lastId = subId || catId;

  useEffect(() => {
    getDataWithoutAccess(
      `http://164.92.208.145/api/v1/categories/${lastId}`
    ).then((res) => {
      setProducts(res.data.products);
      console.log(products);
      setLoaded(true);
    });
  }, [type]);

  return (
    <RecoilRoot>
      <ThemeProvider theme={themeOptions}>
        <PrimarySearchAppBar></PrimarySearchAppBar>
        <ResponsiveAppBar></ResponsiveAppBar>
        {isLoaded ? (
          <CardItemHandler item={products} title={title}></CardItemHandler>
        ) : (
          <div>Loading...</div>
        )}
      </ThemeProvider>
      <Box sx={{ m: 2 }} />
      <Footer />
    </RecoilRoot>
  );
};
export default CategoryProduct;
