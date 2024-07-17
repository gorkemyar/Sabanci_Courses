import {
  RecoilRoot,
  atom,
  selector,
  useRecoilState,
  useRecoilValue,
} from "recoil";

export function getCookie(cname) {
  let name = cname + "=";
  let decodedCookie = decodeURIComponent(document.cookie);
  let ca = decodedCookie.split(";");
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i];
    while (c.charAt(0) == " ") {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

export const loggedState = atom(
  {
    key: "logged",
    default: getCookie("isLogged") === "true",
  },
  [document.cookie]
);

export const nameState = atom(
  {
    key: "name",
    default: getCookie("name") === "gorkemyar@sabanciuniv.edu",
  },
  [document.cookie]
);

export const access_token = atom({
  key: "access_token",
  default: getCookie("access_token"),
});

export const categories = atom({
  key: "categories",
  default: [],
});

export const addressId = atom({
  key: "addressId",
  default: 0,
});

export const creditCardId = atom({
  key: "creditCardId",
  default: 0,
});

export const totalCost = atom({
  key: "totalCost",
  default: -10,
});

export const orders = atom({
  key: "orders",
  default: -10,
});
