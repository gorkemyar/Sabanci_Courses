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
import Column from "../components/header/categories/Column";

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

it("Column component renders correctly", () => {
  act(() => {
    render(<BrowserRouter><RecoilRoot><Column columnItems={[{id:"1", title: "title1"}, {id:2, title:"title2"}]}/></RecoilRoot></BrowserRouter>, container);
  });
  expect(container.textContent).toMatch(/title1/);
  expect(container.textContent).toMatch(/title2/);
});
