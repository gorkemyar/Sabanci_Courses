import { Box, Grid, Container } from "@mui/material";
import CardHalf from "./functions/CardHalf";
import CardItem from "./functions/CardItem";
const CardHalfTogether = () => {
  return (
    <Container maxWidth="lg" height="400">
      <Box sx={{ m: 2 }} />
      <h2 className="h2Center">Hot Spot</h2>
      <Grid container spacing={2}>
        <Grid item key={2} xs={6}>
          <Grid container spacing={2}>
            <Grid item key={3} xs={6}>
              <CardItem imageId="furn3.jpg" cost="1500$"></CardItem>
            </Grid>
            <Grid item key={4} xs={6}>
              <CardItem imageId="furn3.jpg" cost="1500$"></CardItem>
            </Grid>
          </Grid>
        </Grid>
        <Grid item key={1} xs={6}>
          <CardHalf way="right"></CardHalf>
        </Grid>
      </Grid>
      <Box sx={{ m: 2 }} />
    </Container>
  );
};
export default CardHalfTogether;
