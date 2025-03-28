import Data.List (intercalate)

getNext :: [Int] -> Int -> [Int]
getNext [] _ = []
getNext xs 0 = xs
getNext [x] _ = [x]
getNext [x,y] k = if even k then [x,y] else [y,x]
getNext xs k = 
        let 
            n = length xs
            idx = k `mod` n
            (before, after) = splitAt idx xs
            removed = head after
            remaining = (tail after) ++ before
        in removed : getNext remaining k

getResult :: Int -> Int -> [Int]
getResult n k = getNext [1..n] k

main :: IO()
main = do
    line <- getLine
    let [n, k] = map read (words line)
    let [n, k,_] = map read (words line)
    let result_arr = getResult n k 
    let result = intercalate " " (map show result_arr)
    putStrLn result




