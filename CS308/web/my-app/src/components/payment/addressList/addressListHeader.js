import { AppBar} from "@mui/material";
import { Typography } from "@mui/material";
import { Stack } from "@mui/material";

import LockIcon from "@mui/icons-material/Lock";
const addressListHeader = () => {
  return (
    <AppBar color="transparent" elevation={0} position="static">
      <Stack direction="row" justifyContent="space-between">
        <Typography variant="h2" noWrap component="div" sx={{ m: 2, pl: 16 }}>
          Voidture
        </Typography>
        <Stack direction="column" justifyContent="center" alignItems="center">
          <LockIcon fontSize="large" sx={{mt:3, mr: 30, display: {  xs: "none", lg: "block" }}}></LockIcon>
          <Typography
            variant="subtitle2"
            sx={{ pb: 2, pr: 30, display: { xs: "none", lg: "block"} }}
            style={{ color: "red" }}
          >
            SSL SECURED
          </Typography>
        </Stack>
      </Stack>
    </AppBar>
  );
};

export default addressListHeader;
