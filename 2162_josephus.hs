import Data.List (intercalate)

getNext :: [Int] -> Bool -> [Int]
getNext [] _ = []
getNext [x] _ = [x]
getNext [x,y] True = [x,y]
getNext [x,y] False = [y,x]
getNext xs even_idx = 
    let 
        calculate is_even = [x | (x, i) <- zip xs [0 :: Int ..], even i == is_even]
        current = calculate even_idx
        next_even = if (last xs) == (last current) then False else True
    in 
        current ++ getNext (calculate (not even_idx)) next_even

getResult :: Int -> [Int]
getResult n = getNext [1..n] False

main :: IO ()
main = do
    input <- getLine
    let n = read input :: Int 
    let result_arr = getResult n
    let result = intercalate " " (map show result_arr)
    putStrLn result 