const fs = require("fs");

let input = fs.readFileSync(0, "utf-8").trim().split("\n");
const [lenSignal, lenMask] = input[0].split(" ").map(Number);
const signal = input[1].split(" ").map(Number);
const mask = input[2].split(" ").map(Number);

let result = [];

const totalLength = lenSignal + lenMask - 1;

for (let i = 0; i < totalLength; i++) {
    let size = Math.min(i + 1, lenMask, lenSignal, totalLength - i);
    let maxSize = Math.min(lenMask, lenSignal);
    //console.log({ size, maxSize });
    let maskOverlap;
    if (i < maxSize) {
        maskOverlap = mask.slice(-size);
    } else if (totalLength - i < maxSize) {
        maskOverlap = mask.slice(0, size);
    } else if (lenMask == maxSize) {
        maskOverlap = mask;
    } else {
        maskOverlap = mask.slice(lenMask - (i + 1), lenMask - (i + 1) + size);
    }

    let current =
        i < maxSize
            ? signal.slice(0, i + 1)
            : totalLength - i <= maxSize
            ? signal.slice(-size)
            : maxSize == lenMask
            ? signal.slice(i - maxSize + 1, i + 1)
            : signal.slice(-size);
    //console.log({ maskOverlap, current });
    result.push(
        current.reduce((acc, curr, i) => acc + curr * maskOverlap[i], 0)
    );
}

console.log(result.join(" "));
