const fs = require("fs");

let input = parseInt(fs.readFileSync(0, "utf-8").trim());

getOrderForN(input);

function getOrderForN(n) {
    let arr = Array.from({ length: n }, (_, i) => i + 1);
    return getOrder(arr);
}

function getOrder(arr) {
    //let start = performance.now();
    let result = [];
    let current = arr;
    let next = [];
    let condition = true;
    while (current.length > 0) {
        for (let i = 0; i < current.length; i++) {
            if (condition) {
                next.push(current[i]);
            } else {
                result.push(current[i]);
            }
            condition = !condition;
        }
        current = next;
        next = [];
    }
    //let end = performance.now();
    //console.log(`Execution Time: ${(end - start).toFixed(5)} ms`);
    console.log(result.join(" "));
}
