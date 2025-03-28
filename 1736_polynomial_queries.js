const fs = require("fs");

let input = fs.readFileSync(0, "utf-8").trim().split("\n");
const [n, q] = input[0].split(" ").map(Number);
let arr = input[1].split(" ").map(Number);
let queries = input.slice(2).map((line) => line.split(" ").map(Number));

let diff1 = Array(n + 2).fill(0); // rate of increase
let diff2 = Array(n + 2).fill(0); // correction shift

let prefixSum = Array(n + 1).fill(0);
for (let i = 1; i <= n; i++) {
    prefixSum[i] = prefixSum[i - 1] + arr[i - 1];
}

let result = [];
for (let [op, l, r] of queries) {
    if (op === 1) {
        diff1[l] += 1;
        diff1[r + 1] -= 1;
        diff2[l] += 1 - l;
        diff2[r + 1] -= 1 - l + (r - l + 1);
    } else if (op === 2) {
        let d1 = 0,
            d2 = 0,
            sumAfterUpdates = 0;
        for (let i = 1; i <= r; i++) {
            d1 += diff1[i];
            d2 += diff2[i];
            if (i >= l) {
                sumAfterUpdates += arr[i - 1] + d1 * i + d2;
            }
        }

        result.push(sumAfterUpdates);
    }
}

console.log(result.join("\n"));
