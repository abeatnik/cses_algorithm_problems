{-# LANGUAGE BangPatterns #-}
import Data.Maybe (fromJust, maybeToList)
import qualified Data.Sequence as Seq
import qualified Data.IntSet as IntSet
import qualified Data.IntMap.Strict as IntMap
import qualified Data.Array.Unboxed as Array
import Control.Monad (msum)

type Point = (Int, Int)
type Grid = Array.UArray Point Char
type Queue = Seq.Seq Point
type Visited = IntSet.IntSet
type ParentMap = IntMap.IntMap (Point, Char)

-- Directional constants
directions :: [(Int, Int, Char)]
directions = [(0, -1, 'L'), (0, 1, 'R'), (-1, 0, 'U'), (1, 0, 'D')]

-- Convert 2D point to 1D int for faster lookup
pointToInt :: Int -> Point -> Int
pointToInt cols (row, col) = row * cols + col

-- Parse input and create an efficient grid representation
parseGrid :: [String] -> (Point, Point, Grid, Int, Int)
parseGrid (dimensions:rows) = 
    case (start, end) of
        (Just s, Just e) -> (s, e, grid, rows', cols)
        _ -> error "Start or End not found in grid"
    where
        [rows', cols] = map (read :: String -> Int) (words dimensions)
        rowsList = zip [0..] rows
        grid = Array.array ((0,0), (rows'-1, cols-1)) 
               [((r,c), cell) | (r, row) <- rowsList, (c, cell) <- zip [0..] row]
        start = findChar 'A' rowsList
        end = findChar 'B' rowsList

-- Find character in grid
findChar :: Char -> [(Int, String)] -> Maybe Point
findChar c rowsList = 
    msum [Just (row, col) | (row, line) <- rowsList, 
                            (col, char) <- zip [0..] line, 
                            char == c]

-- Optimized BFS implementation
bfs :: Grid -> Point -> Point -> Int -> Int -> Maybe [Char]
bfs !grid !start !end !rows !cols = 
    bfsLoop (Seq.singleton start) 
            (IntSet.singleton (pointToInt cols start)) 
            IntMap.empty
    where
        -- Check if a point is valid to explore
        isValid :: Point -> Visited -> Bool
        isValid p@(nx, ny) visited = 
            nx >= 0 && nx < rows && ny >= 0 && ny < cols && 
            grid Array.! p /= '#' && 
            not (IntSet.member (pointToInt cols p) visited)
        
        -- Main BFS loop
        bfsLoop :: Queue -> Visited -> ParentMap -> Maybe [Char]
        bfsLoop !queue !visited !parentMap
            | Seq.null queue = Nothing
            | otherwise =
                let !(current@(x, y), restQueue) = Seq.splitAt 1 queue
                    !currentPoint = Seq.index current 0
                in if currentPoint == end
                    then Just (reconstructPath parentMap start end cols)
                    else 
                        let -- Generate valid neighbors
                            neighbors = [(x+dx, y+dy, move) | (dx, dy, move) <- directions, 
                                        let newPoint = (x+dx, y+dy),
                                        isValid newPoint visited]
                            
                            -- Process each neighbor
                            (newQueue, newVisited, newParentMap) = 
                                foldl' process (restQueue, visited, parentMap) neighbors
                            
                            -- Add neighbor to queue and update maps
                            process (!q, !v, !p) (nx, ny, move) =
                                let !newPoint = (nx, ny)
                                    !intPoint = pointToInt cols newPoint
                                in (q Seq.|> newPoint, 
                                    IntSet.insert intPoint v, 
                                    IntMap.insert intPoint (currentPoint, move) p)
                        in bfsLoop newQueue newVisited newParentMap

-- Strict fold to prevent thunk buildup
foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' f z [] = z
foldl' f z (x:xs) = let !z' = f z x in foldl' f z' xs

-- Reconstruct path from parent map
reconstructPath :: ParentMap -> Point -> Point -> Int -> [Char]
reconstructPath parentMap start end cols = go end []
    where
        go !current !path
            | current == start = path
            | otherwise = 
                case IntMap.lookup (pointToInt cols current) parentMap of
                    Just (prev, move) -> go prev (move : path)
                    Nothing -> error "Path reconstruction failed"

main :: IO ()
main = do
    input <- lines <$> getContents
    let (start, end, grid, rows, cols) = parseGrid input
    case bfs grid start end rows cols of
        Just path -> do
            putStrLn "YES"
            print $ length path
            putStrLn $ reverse path
        Nothing -> putStrLn "NO"