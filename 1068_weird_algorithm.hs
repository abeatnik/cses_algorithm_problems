import Data.List (intercalate)

calculate :: Int -> [Int] -> [Int]
calculate num acc
    | num == 1 = acc ++ [num]
    | even num = acc ++ [num] ++ calculate (num `div` 2) acc
    | otherwise = acc ++ [num] ++ calculate ((num * 3) + 1) acc



main :: IO()
main = do
    input <- getLine
    let n = read input :: Int 
    let result_arr = calculate n []
    let result = intercalate " " (map show result_arr)
    putStrLn result