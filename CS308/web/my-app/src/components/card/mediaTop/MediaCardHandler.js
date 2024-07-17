import {
  RadioGroup,
  Radio,
  FormControlLabel,
  FormControl,
  FormLabel,
} from "@mui/material";
import * as React from "react";
import MediaCard from "./MediaCard";
import { useState } from "react";

const MediaCardHandler = () => {
  const [counter, setCounter] = React.useState(3);
  const [buttonNo, setButtonNo] = useState(0);

  const Timer = () => {
    React.useEffect(() => {
      counter > 0 && setTimeout(() => setCounter(counter - 1), 1000);
    }, [counter]);
  };
  const Clicked = (e) => {
    setCounter(6);
    const id = e.currentTarget.getAttribute("data-id");
    setButtonNo(+id);
    console.log(id);
  };
  const Together = () => {
    setCounter(3);
    setButtonNo((buttonNo + 1) % 6);
  };
  const Again = () => {
    React.useEffect(() => counter === 0 && Together());
  };
  {
    Timer();
    Again();
  }

  return (
    <>
      <MediaCard myId={buttonNo}></MediaCard>
      <FormControl>
        <FormLabel id="demo-row-radio-buttons-group-label "></FormLabel>

        <RadioGroup
          row
          aria-labelledby="demo-row-radio-buttons-group-label"
          name="row-radio-buttons-group"
        >
          <FormControlLabel
            value="0"
            control={<Radio onClick={Clicked} data-id={0} />}
            checked={buttonNo === 0}
          />
          <FormControlLabel
            value="1"
            control={<Radio onClick={Clicked} data-id={1} />}
            checked={buttonNo === 1}
          />
          <FormControlLabel
            value="2"
            control={<Radio onClick={Clicked} data-id={2} />}
            checked={buttonNo === 2}
          />
          <FormControlLabel
            value="3"
            control={<Radio onClick={Clicked} data-id={3} />}
            checked={buttonNo === 3}
          />
          <FormControlLabel
            value="4"
            control={<Radio onClick={Clicked} data-id={4} />}
            checked={buttonNo === 4}
          />
          <FormControlLabel
            value="5"
            control={<Radio onClick={Clicked} data-id={5} />}
            checked={buttonNo === 5}
          />
        </RadioGroup>
      </FormControl>
    </>
  );
};
export default MediaCardHandler;
