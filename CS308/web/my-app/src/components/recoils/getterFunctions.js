import axios from "axios";
import { getCookie } from "./atoms";

const access = getCookie("access_token");

export const getData = async (link) => {
  try {
    let res = await axios.get(link, {
      headers: {
        Accept: "*/*",
        Authorization: `Bearer ${access}`,
      },
    });
    if (res.status >= 200 && res.status < 300) {
      // test for status you want, etc

      return res.data;
    } else {
      return null;
    }

    // Don't forget to return something
  } catch (err) {
    console.log(err);
  }
};

export const getDataWithoutAccess = async (link) => {
  try {
    let res = await axios.get(link, {
      headers: {
        Accept: "*/*",
      },
    });
    if (res.status >= 200 && res.status < 300) {
      // test for status you want, etc

      return res.data;
    } else {
      return null;
    }
    // Don't forget to return something
  } catch (err) {
    console.log(err);
  }
};

export const createShoppingDict = () => {
  let orderList = getCookie("orderList");
  console.log(orderList);
  let cartDict = {};
  //console.log("order", orderList);
  orderList = orderList.split(" ");
  for (let index = 0; index < orderList.length; index++) {
    let num = Number(orderList[index]);
    //console.log(num);
    if (num > 0) {
      if (num in cartDict) {
        cartDict[num] += 1;
      } else {
        cartDict[num] = 1;
      }
    } else if (num < 0) {
      //console.log("here", num);
      if (!(num in cartDict)) {
        cartDict[-1 * num] = 0;
      }
    }
  }

  return cartDict;
};

export const addCardtoCookie = (proId) => {
  console.log(proId);
  let orderList = getCookie("orderList");

  orderList = `${orderList} ${proId}`;
  document.cookie = `orderList=${orderList};path=/`;
};

export const createOrderCookie = (cartDict) => {
  //console.log(getCookie("orderList"));
  document.cookie = "orderList=;path=/";

  for (let item in cartDict) {
    console.log("dict", item);
    for (let i = 0; i < cartDict[item]; i++) {
      addCardtoCookie(item);
    }
    if (cartDict[item] == 0) {
      //console.log("from", item);
      addCardtoCookie(-1 * item);
    }
  }
};

export const resetOrdercCookie = () => {
  document.cookie = "orderList=;path=/";
};

export const decreaseCardCookie = (proId) => {
  let cartDict = createShoppingDict();
  cartDict[proId] -= 1;
  createOrderCookie(cartDict);
};
