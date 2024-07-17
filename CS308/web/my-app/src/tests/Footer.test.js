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
import Footer from '../components/footer/Footer';

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


it('Footer renders correctly', () => {
  act(() => {
    render(<BrowserRouter><RecoilRoot><Footer/></RecoilRoot></BrowserRouter>, container);

  });
    
  
  
  expect(container.textContent).toContain("HelpContactSupportPrivacyAccountLoginRegisterGet");
  expect(container.textContent).toContain("")
  
});