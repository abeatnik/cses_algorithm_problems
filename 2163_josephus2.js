const fs = require("fs");

let input = fs.readFileSync(0, "utf-8").trim();
let [n, k] = input.split(" ").map(Number);

let result = getJosephusForN(n, k);
console.log(result.join(" "));

function getJosephusForN(n, k) {
    let arr = Array.from({ length: n }, (_, i) => i + 1);
    return josephus(arr, k);
}

function josephus(arr, k) {
    if (!arr) return [];
    if (k == 0) return arr;
    if (arr.length == 1) return arr;
    if (arr.length == 2) return k % 2 == 0 ? arr : arr.slice().reverse();
    else {
        let n = arr.length;
        let idx = k % n;
        const removed = arr[idx];
        const before = arr.slice(0, idx);
        const after = arr.slice(idx + 1);
        const remaining = after.concat(before);
        return [removed].concat(josephus(remaining, k));
    }
}
