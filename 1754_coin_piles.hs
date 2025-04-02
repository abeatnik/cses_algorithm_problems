isValidPile :: [Int] -> Bool
isValidPile [x,y] =
    let 
        a = (2 * y - x) `div` 3
        b = (2 * x - y) `div` 3
    in a >=0 && b >= 0 && (2 * y - x) `mod` 3 == 0 && (2 * x - y) `mod` 3 == 0

yesOrNo :: Bool -> String
yesOrNo True = "YES"
yesOrNo False = "NO"

main :: IO()
main = do
    input <- getContents
    let (_:rest) = lines input
        piles = map (map (read :: String -> Int) . words) rest 
    let result = map (yesOrNo . isValidPile) piles
    mapM_ putStrLn result 
