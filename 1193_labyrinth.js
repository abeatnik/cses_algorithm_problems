const fs = require("fs");

let input = fs.readFileSync(0, "utf-8").trim().split("\n");

const [first, ...rest] = input;
const [rows, cols] = first.split(" ").map(Number);
const map = [];

rest.forEach((line) => {
    map.push(line.split(""));
});

let start, end;

for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
        if (map[i][j] == "A") start = [i, j];
        if (map[i][j] == "B") end = [i, j];
    }
}

const directions = [
    [0, -1, "L"],
    [0, 1, "R"],
    [-1, 0, "U"],
    [1, 0, "D"],
];

function findPath(map, start, end) {
    const queue = [start];
    const visited = new Set();
    const parent = new Map();

    visited.add(`${start[0]},${start[1]}`);

    while (queue.length > 0) {
        let [x, y] = queue.shift();

        if (x === end[0] && y === end[1])
            return getInstructions(parent, start, end);

        for (const [dx, dy, move] of directions) {
            let nx = x + dx,
                ny = y + dy;

            if (
                nx >= 0 &&
                nx < rows &&
                ny >= 0 &&
                ny < cols &&
                map[nx][ny] != "#"
            ) {
                let key = `${nx},${ny}`;

                if (!visited.has(key)) {
                    queue.push([nx, ny]);
                    visited.add(key);
                    parent.set(key, {
                        prev: [x, y],
                        move,
                    });
                }
            }
        }
    }
    return "NO";
}

function getInstructions(parentMap, start, end) {
    let path = [];
    let current = `${end[0]},${end[1]}`;

    while (current != `${start[0]},${start[1]}`) {
        let { prev, move } = parentMap.get(current);
        path.push(move);
        current = prev.toString();
    }

    let instructions = path.reverse().join("");

    return `YES\n${path.length}\n${instructions}`;
}

console.log(findPath(map, start, end));
