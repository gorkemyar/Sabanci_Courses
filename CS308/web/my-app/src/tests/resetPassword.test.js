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
import ResetPassword from "../components/signIn/resetPassword";

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

it("Forget Password In Page renders correctly", () => {
  act(() => {
    render(<BrowserRouter><RecoilRoot><ResetPassword /></RecoilRoot></BrowserRouter>, container);
  });
  expect(container.textContent).toMatch(/Password Reset/);
  expect(container.textContent).toMatch(/New Password/);
  expect(container.textContent).toMatch(/Confirm Password/);
  expect(container.textContent).toMatch(/Confirm New Password/);
});
