import Data.List (intercalate)

getNext :: [Int] -> Int -> [Int]
getNext [] _ = []
getNext xs 0 = xs
getNext [x] _ = [x]
getNext [x,y] k = if even k then [x,y] else [y,x]
getNext xs k =
    (removed xs k) ++ getNext (remaining xs k) k
        where
            removed xs k 
                | k < ((length xs) `div` 2) = [x | (x, i) <- zip xs [0 :: Int ..], (i+1) `mod` (k+1) == 0 ]
                | otherwise = [xs !! (k `mod` (length xs))]

            multiple a b = a * (b `div` a)

            remaining xs k 
                | length xs == 1 = xs
                | k < ((length xs ) `div` 2) = (reverse $ take ((length xs) - (multiple (k +1) (length xs))) $ reverse xs) ++ [x | (x, i) <- zip xs [0 :: Int .. (multiple (k +1) (length xs))-1], (i+1) `mod` (k+1) /= 0 ]
                | k + 1 == length xs = take k xs
                | (k+1) `mod` (length xs) == 1 = drop idx xs
                | otherwise = drop idx xs ++ take (idx - 1) xs
                                where
                                    idx = (k+1) `mod` (length xs)

removed xs k 
    | k < ((length xs) `div` 2) = [x | (x, i) <- zip xs [0 :: Int ..], (i+1) `mod` (k+1) == 0 ]
    | otherwise = [xs !! (k `mod` (length xs))]

multiple a b = a * (b `div` a)

remaining xs k 
    | length xs == 1 = xs
    | k < ((length xs ) `div` 2) = (reverse $ take ((length xs) - (multiple (k +1) (length xs))) $ reverse xs) ++ [x | (x, i) <- zip xs [0 :: Int .. (multiple (k +1) (length xs))-1], (i+1) `mod` (k+1) /= 0 ]
    | k + 1 == length xs = take k xs
    | (k+1) `mod` (length xs) == 1 = drop idx xs
    | otherwise = drop idx xs ++ take (idx - 1) xs
                    where
                        idx = (k+1) `mod` (length xs)

getResult :: Int -> Int -> [Int]
getResult n k = getNext [1..n] k

main :: IO()
main = do
    line <- getLine
    let [n, k] = map read (words line)
    let result_arr = getResult n k 
    let result = intercalate " " (map show result_arr)
    putStrLn result 
