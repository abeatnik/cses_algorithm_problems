import Data.List (intercalate)
import Data.Heap


getWindows :: [Int] -> [[Int]]
getWindows nums =
    let  






main :: IO()
main = do
    input1 <- getLine
    input2 <- getLine
    let [len_nums,len_window] = map read (words input1) :: [Int] 
    let nums = map read (words input2) :: [Int]