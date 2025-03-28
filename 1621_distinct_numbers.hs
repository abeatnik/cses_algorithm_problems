import Data.Set (Set, fromList, size)

main :: IO()
main = do
    _ <- getLine
    input <- getContents  
    let numbers = map read (words input) :: [Int]
    let input_set = fromList numbers :: Set Int
    putStrLn (show (size input_set))