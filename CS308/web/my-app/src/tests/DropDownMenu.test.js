/**
 * @jest-environment jsdom
 */
// hello.test.js
import React from "react";
import { render, unmountComponentAtNode } from "react-dom";
import { act } from "react-dom/test-utils";
import { BrowserRouter, Routes, Route } from "react-router-dom";

import DropDownMenu from '../components/header/categories/DropDownMenu';

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


it('Header dropdown menu renders correctly', () => {
  act(() => {
    const subs = [{id: 1, title: "Sub 1", }, {id: 2, title: "Sub 2"}, {id: 3, title: "Sub 3"}];
    render(<BrowserRouter><DropDownMenu sub={subs} /></BrowserRouter>, container);

  });
    
  
  
  expect(container.textContent).toContain("Sub 1Sub 2Sub 3");
});