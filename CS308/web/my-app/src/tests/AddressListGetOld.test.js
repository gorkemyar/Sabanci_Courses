/**
 * @jest-environment jsdom
 */
// hello.test.js
import React from "react";
import { render, unmountComponentAtNode } from "react-dom";
import { act } from "react-dom/test-utils";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import {
    RecoilRoot,
    atom,
    selector,
    useRecoilState,
    useRecoilValue,
  } from "recoil";
import AddressListGetOld from '../components/payment/addressList/AddressListGetOld';

let container = null;
beforeEach(() => {
  // setup a DOM element as a render target
  container = document.createElement("div");
  document.body.appendChild(container);
});

afterEach(() => {
  // cleanup on exiting
  unmountComponentAtNode(container);
  container.remove();
  container = null;
});


it('Address List Get Old Component renders correctly', () => {
  act(() => {
    render(<BrowserRouter><RecoilRoot><AddressListGetOld/></RecoilRoot></BrowserRouter>, container);

  });
  expect(container.textContent).toContain("Delete");

  act(() => {
    render(<BrowserRouter><RecoilRoot><AddressListGetOld isNew = {true} title={"New Address"}/></RecoilRoot></BrowserRouter>, container);
  });
  expect(container.textContent).toContain("New Address");
  expect(container.textContent).not.toContain("Delete");

  
});