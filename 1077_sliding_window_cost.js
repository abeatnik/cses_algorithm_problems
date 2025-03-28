const fs = require("fs");
let input = fs.readFileSync(0, "utf-8").trim();
const [first, second] = input.split("\n");

const [lenNums, lenWindow] = first.split(" ").map(Number);
const nums = second.split(" ").map(Number);

let result = [];
for (let i = 0; i < lenNums - (lenWindow - 1); i++) {
    let window = nums.slice(i, i + lenWindow);
    let possibleCosts = [];
    let { min, max } = getMinMax(window);
    for (let i = min; i <= max; i++) {
        possibleCosts.push(window.reduce((a, b) => a + Math.abs(b - i), 0));
    }
    let cost = Math.min(...possibleCosts);
    result.push(cost);
}

console.log(result.join(" "));

//trying to get min & max by iterating through the window only once
function getMinMax(arr) {
    let min = arr[0],
        max = arr[0];
    for (let i = 1; i < arr.length; i++) {
        let num = arr[i];
        if (num < min) min = num;
        else if (num > max) max = num;
    }
    return { min, max };
}
