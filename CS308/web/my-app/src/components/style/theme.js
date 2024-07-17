import { createTheme, responsiveFontSizes } from "@mui/material/styles";
import { deepmerge } from "@mui/utils";

let themeOptions = createTheme({
  palette: {
    type: "light",
    primary: {
      main: "#ff6600",
      light: "#ffb74d",
    },
    secondary: {
      main: "#dddddd",
      light: "#eeeeee",
    },
    white: {
      main: "#ffffff",
    },
    black: { main: "#000000" },
    background: {
      default: "#F7F3F0",
    },
    transparent: {
      main: "transparent",
    },

    action: {
      disabled: "#000000"
    }
  },
  props: {
    MuiList: {
      dense: true,
    },
    MuiMenuItem: {
      dense: true,
    },
    MuiTable: {
      size: "small",
    },
    MuiButton: {
      size: "small",
    },
    MuiButtonGroup: {
      size: "small",
    },
    MuiCheckbox: {
      size: "small",
    },
    MuiFab: {
      size: "small",
    },
    MuiFormControl: {
      margin: "dense",
      size: "small",
    },
    MuiFormHelperText: {
      margin: "dense",
    },
    MuiIconButton: {
      size: "small",
    },
    MuiInputBase: {
      margin: "dense",
    },
    MuiInputLabel: {
      margin: "dense",
    },
    MuiRadio: {
      size: "small",
    },
    MuiSwitch: {
      size: "small",
    },
    MuiTextField: {
      margin: "dense",
      size: "small",
    },
    MuiAppBar: {
      color: "default",
    },
    MuiContainer: {},
    MuiIcon: {
      marginRight: "20px",
    },
    MuiButtons: {
      marginTop: "40px",
    },
    MuiCardGrid: {
      padding: "20px 0",
    },
    MuiCard: { height: "100%", display: "flex", flexDirection: "column" },
    MuiCardMedia: {
      paddingTop: "56.25%",
    },
    MuiCardContent: {
      flexGrow: 1,
    },
  },
  overrides: {
    MuiAppBar: {
      colorInherit: {
        backgroundColor: "#ffffff",
        color: "#000000",
      },
    },
  },
});

themeOptions = responsiveFontSizes(themeOptions);
themeOptions = createTheme(deepmerge(themeOptions));

export default themeOptions;
