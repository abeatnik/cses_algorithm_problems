import Data.List (intercalate)

binaryStringToInt :: String -> Int
binaryStringToInt = foldl (\acc x -> acc * 2 + (if x == '1' then 1 else 0)) 0


getSubstring :: String -> Int
getSubstring bs =  
    let 
        bitsUnchanged :: Char -> String -> Int -> Int -> Int
        bitsUnchanged b "" acc streak = max acc streak
        bitsUnchanged b (s:t) acc streak
            | s == b = bitsUnchanged b t (acc + 1) streak
            | otherwise = bitsUnchanged b t 0 (max acc streak)
        zeros = bitsUnchanged '0' bs 0 0
        ones = bitsUnchanged '1' bs 0 0
    in 
        if zeros > ones then zeros else ones

doFlip :: String -> Int -> String
doFlip bs idx = 
    let 
        flipBit :: Char -> Char
        flipBit '0' = '1'
        flipBit '1' = '0'
        flipBit x = x
    in
        take (idx - 1) bs ++ [flipBit (bs !! (idx - 1))] ++ drop idx bs

doAllFlips :: String -> [Int] -> (String -> Int -> String) -> [String] -> [String]
doAllFlips bs [] f acc = reverse acc
doAllFlips bs (n:ns) f acc = 
    let 
        bs2 = f bs n
    in 
        doAllFlips bs2 ns f (bs2 : acc)


main :: IO()
main = do
    bstring <- getLine
    input2 <- getLine
    let n = read input2 :: Int
    input3 <- getLine
    let nums = map read (words input3) :: [Int]
    let result = intercalate " " (map (show . getSubstring) (doAllFlips bstring nums doFlip []))
    putStrLn result 
    




