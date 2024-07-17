import { Grid, Container, Card, Box } from "@mui/material";
import CategoryCard from "./functions/CategoryCard";
const CategoryCardHandler = (props) => {
  const cards = props.item;
  console.log("cards");
  console.log(cards);
  return (
    <div>
      <h2 className="h2Center">Our Furn</h2>
      <Container maxWidth="lg" height="400">
        <Grid container spacing={4}>
          {cards.map((item) => (
            <Grid item key={item.id + 1} xs={12} sm={6} md={6}>
              <CategoryCard
                key={item.id}
                image={item.image_url}
                title={item.title}
                id={item.id}
              ></CategoryCard>
            </Grid>
          ))}
        </Grid>
      </Container>
    </div>
  );
};
export default CategoryCardHandler;
