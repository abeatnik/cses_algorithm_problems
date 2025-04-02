const fs = require("fs");
let input = fs.readFileSync(0, "utf-8").trim();
const [_, ...rest] = input.split("\n");
const piles = rest.map((x) => x.split(" ").map(Number));

function validPile(pile) {
    let [x, y] = pile;
    let a = (2 * y - x) / 3;
    let b = (2 * x - y) / 3;
    return Number.isInteger(a) && Number.isInteger(b) && a >= 0 && b >= 0;
}

let result = piles.map((pile) => (validPile(pile) ? "YES" : "NO")).join("\n");
console.log(result);
