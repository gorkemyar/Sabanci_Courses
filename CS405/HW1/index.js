const items = [
  { year: 2009, value: 2898, rate: 4.02 },
  { year: 2010, value: 2933, rate: 4.01 },
  { year: 2011, value: 2677, rate: 3.61 },
  { year: 2012, value: 3287, rate: 4.37 },
  { year: 2013, value: 3252, rate: 4.27 },
  { year: 2014, value: 3169, rate: 4.11 },
  { year: 2015, value: 3246, rate: 4.15 },
  { year: 2016, value: 3193, rate: 4.03 },
  { year: 2017, value: 3168, rate: 3.94 },
  { year: 2018, value: 3342, rate: 4.11 },
  { year: 2019, value: 3476, rate: 4.21 },
  { year: 2020, value: 3710, rate: 4.45 },
  { year: 2021, value: 4194, rate: 4.98 },
  { year: 2022, value: 4146, rate: 4.88 },
];

// Functions to create SVG rect elements
function createSVGRectElement(xpos, ypos, width, height, fill) {
  const rect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
  rect.setAttribute("x", xpos);
  rect.setAttribute("y", ypos - height);
  rect.setAttribute("width", width);
  rect.setAttribute("height", height);
  rect.setAttribute("fill", fill);
  rect.setAttribute("class", "rect");
  return rect;
}

// Functions to create SVG text elements
function createSVGTextElement(
  value,
  xpos,
  ypos,
  rotate,
  size,
  fill,
  anchor = "begin"
) {
  const text = document.createElementNS("http://www.w3.org/2000/svg", "text");
  text.setAttribute("x", xpos);
  text.setAttribute("y", ypos);
  text.setAttribute("font-size", size);
  text.setAttribute("fill", fill);
  text.setAttribute("transform", `rotate(${rotate} ${xpos} ${ypos})`);
  text.setAttribute("text-anchor", anchor);
  text.textContent = value;
  return text;
}
// Functions to create SVG line elements
function createSVGLineElement(x1, y1, x2, y2, stroke) {
  const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
  line.setAttribute("x1", x1);
  line.setAttribute("y1", y1);
  line.setAttribute("x2", x2);
  line.setAttribute("y2", y2);
  line.setAttribute("stroke-width", 0.5);
  line.setAttribute("stroke", stroke);
  return line;
}
// Function to create SVG path elements
function createSVGPathElement(points, stroke, fill = "transparent") {
  const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
  path.setAttribute("d", points); // Path data
  path.setAttribute("stroke", stroke);
  path.setAttribute("fill", fill);
  path.setAttribute("stroke-width", 0.6);
  return path;
}

// Constants for aligning elements
const maxItem = items.reduce((max, item) => {
  return max.value > item.value ? max : item;
}, items[0]);

const maxRate = items.reduce((max, item) => {
  return max.rate > item.rate ? max : item;
}, items[0]);

let valueStepSize = 1;
let valueStepCount = 2;
let tmp = maxItem.value;
while (tmp > 10) {
  valueStepSize *= 10;
  valueStepCount++;
  tmp /= 10;
}

let rateStepSize = 1;
let rateStepCount = parseInt(maxRate.rate / 1) + 1;

const space = 6;
const rectWidth = 5;
const bottomY = 100;
//const topY = bottomY - (maxItem.value / 100) * 1.8;
const topY = bottomY - ((valueStepCount * valueStepSize) / 100) * 1.5;
const leftX = 20;
const leftSpace = 4;
const rightSpace = 4;
const rightX =
  leftX +
  leftSpace +
  items.length * rectWidth +
  (items.length - 1) * space +
  rightSpace;

const svgContainer = document.getElementById("svg-container");

// Creating the SVG elements

items.forEach((item, index) => {
  // Bars in the chart
  svgContainer.appendChild(
    createSVGRectElement(
      index * (space + rectWidth) + leftX + leftSpace,
      bottomY,
      rectWidth,
      (item.value / 100) * 1.5,
      "#03a9fc"
    )
  );
  // Year text
  svgContainer.appendChild(
    createSVGTextElement(
      item.year,
      index * (space + rectWidth) + leftX + leftSpace,
      bottomY + 5,
      0,
      3,
      "black"
    )
  );
  // Value text
  svgContainer.appendChild(
    createSVGTextElement(
      item.value,
      index * (space + rectWidth) + leftX + leftSpace + rectWidth - 1,
      bottomY - 15,
      270,
      5,
      "white"
    )
  );
});

// Rate path for the chart (red line)
let ratePath = "";
items.forEach((item, index) => {
  if (index == 0) {
    ratePath += "M";
    ratePath += `${leftX + leftSpace + rectWidth / 2} ${
      bottomY - ((bottomY - topY) / (rateStepCount * rateStepSize)) * item.rate
    }`;
  } else {
    ratePath += "L";
    ratePath += `${
      index * rectWidth + index * space + space / 2 + leftX + leftSpace
    } ${
      bottomY - ((bottomY - topY) / (rateStepCount * rateStepSize)) * item.rate
    } `;
  }
});
svgContainer.appendChild(createSVGPathElement(ratePath, "red", "transparent"));

// Y axis on the left
svgContainer.appendChild(
  createSVGLineElement(leftX, topY, leftX, bottomY + 1, "gray")
);
// Y axis on the right
svgContainer.appendChild(
  createSVGLineElement(rightX, topY, rightX, bottomY + 1, "gray")
);
// X axis on the bottom
svgContainer.appendChild(
  createSVGLineElement(leftX - 1, bottomY, rightX + 1, bottomY, "gray")
);

// Y left axis separators
for (let i = 0; i <= valueStepCount; i++) {
  svgContainer.appendChild(
    createSVGLineElement(
      leftX - 1,
      ((topY - bottomY) / valueStepCount) * i + bottomY,
      leftX,
      ((topY - bottomY) / valueStepCount) * i + bottomY,
      "gray"
    )
  );
  svgContainer.appendChild(
    createSVGTextElement(
      valueStepSize * i,
      leftX - 2,
      ((topY - bottomY) / valueStepCount) * i + bottomY + 1,
      0,
      2,
      "black",
      "end"
    )
  );
}

// Y right axis separators
for (let i = 0; i <= rateStepCount; i++) {
  svgContainer.appendChild(
    createSVGLineElement(
      rightX,
      ((topY - bottomY) / rateStepCount) * i + bottomY,
      rightX + 1,
      ((topY - bottomY) / rateStepCount) * i + bottomY,
      "gray"
    )
  );
  svgContainer.appendChild(
    createSVGTextElement(
      rateStepSize * i,
      rightX + 2,
      ((topY - bottomY) / rateStepCount) * i + bottomY + 1,
      0,
      2,
      "black",
      "start"
    )
  );
}

// X axis separators
items.forEach((_, index) => {
  if (index > 0) {
    svgContainer.appendChild(
      createSVGLineElement(
        index * rectWidth + (index - 1) * space + space / 2 + leftX + leftSpace,
        bottomY + 1,
        index * rectWidth + (index - 1) * space + space / 2 + leftX + leftSpace,
        bottomY,
        "gray"
      )
    );
  }
});

// Texts

// Y left axis text
svgContainer.appendChild(
  createSVGTextElement(
    "(Suicide Count)",
    leftX + 3,
    topY - 3,
    0,
    3,
    "black",
    "end"
  )
);

// Y right axis text
svgContainer.appendChild(
  createSVGTextElement(
    "Suicide rate per hundred-thousand",
    rightX - 3,
    topY - 3,
    0,
    3,
    "black"
  )
);

// Title
svgContainer.appendChild(
  createSVGTextElement(
    "Suicide Count and Rate, 2009-2022",
    leftX,
    topY - 10,
    0,
    5,
    "black"
  )
);

// Legend
svgContainer.appendChild(
  createSVGTextElement(
    "Suicide Rate",
    (leftX + rightX) / 2,
    bottomY + 10,
    0,
    3,
    "black"
  )
);
svgContainer.appendChild(
  createSVGRectElement((leftX + rightX) / 2 - 3, bottomY + 10, 2, 2, "red")
);

svgContainer.appendChild(
  createSVGTextElement(
    "Suicide Count",
    (leftX + rightX) / 2,
    bottomY + 13,
    0,
    3,
    "black"
  )
);
svgContainer.appendChild(
  createSVGRectElement((leftX + rightX) / 2 - 3, bottomY + 13, 2, 2, "blue")
);
