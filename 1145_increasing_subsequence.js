const fs = require("fs");

let input = fs.readFileSync(0, "utf-8").trim();
const [first, second] = input.split("\n");

const len = parseInt(first);
let nums = second.split(" ").map(Number);

nums = [3,4,2,6,9,8]

const sequences = [];

for (let n of nums) {
    if (sequences.length == 0) {
        sequences.push(n);
    } else if (sequences[sequences.length - 1] < n) {
        sequences.push(n);
    } else {
        for (let i = 0; i < sequences.length; i++) {
            if (sequences[i] >= n) {
                sequences[i] = n;
                break;
            }
        }
    }
}

[2,4,6,8]

console.log(sequences.length);
