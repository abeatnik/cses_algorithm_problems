import Data.List (elemIndex)
import Data.Maybe (fromJust, maybeToList)
import qualified Data.Sequence as Seq
import qualified Data.Set as Set
import qualified Data.Map as Map
import Control.Monad (guard, msum)

type Point = (Int, Int)
type Grid = [[Char]]
type Queue = Seq.Seq Point
type Visited = Set.Set Point
type ParentMap = Map.Map Point (Point, Char)

directions :: [(Int, Int, Char)]
directions = [(0, -1, 'L'), (0, 1, 'R'), (-1, 0, 'U'), (1, 0, 'D')]

initialQueue :: Point -> Queue
initialQueue start = Seq.singleton start

initialVisited :: Point -> Visited
initialVisited start = Set.singleton start

initialParentMap :: ParentMap
initialParentMap = Map.empty

parseGrid :: [String] -> (Point, Point, Grid)
parseGrid (dimensions:rows) = 
    case (start, end) of
        (Just s, Just e) -> (s, e, grid)
        _ -> error "Start or End not found in grid"
    where
        [n, m] = map (read :: String -> Int) (words dimensions) -- [row, col]
        grid = rows
        start = findChar 'A' grid
        end = findChar 'B' grid

findChar :: Char -> Grid -> Maybe Point
findChar c grid = 
    msum [Just (row, col) | (row, line) <- zip [0..] grid, col <- maybeToList (elemIndex c line)]

bfs :: Grid -> Point -> Point -> Maybe [Char]
bfs grid start end = bfsLoop (initialQueue start) (initialVisited start) initialParentMap
    where
        bfsLoop :: Queue -> Visited -> ParentMap -> Maybe [Char]
        bfsLoop queue visited parentMap
            | Seq.null queue = Nothing
            | otherwise =
                let (current, restQueue) = Seq.splitAt 1 queue
                    currentPoint = Seq.index current 0
                in if currentPoint == end
                    then Just (reconstructPath parentMap start end)
                    else 
                        let (updatedQueue, updatedVisited, updatedParentMap) = 
                                processNeighbors grid currentPoint restQueue visited parentMap
                        in 
                            bfsLoop updatedQueue updatedVisited updatedParentMap

processNeighbors :: Grid -> Point -> Queue -> Visited -> ParentMap -> (Queue, Visited, ParentMap)
processNeighbors grid (x, y) queue visited parentMap = 
    foldl process (queue, visited, parentMap) directions
    where
        process (q, v, p) (dx, dy, move) =
            let newPoint = (x + dx, y + dy)
            in if isValid grid newPoint v
                then (q Seq.|> newPoint, Set.insert newPoint v, Map.insert newPoint ((x, y), move) p)
                else (q, v, p)

isValid :: Grid -> Point -> Visited -> Bool
isValid grid (nx, ny) visited = 
    nx >= 0 && nx < length grid && ny >= 0 && ny < length (head grid) && 
    (grid !! nx !! ny) /= '#' && not (Set.member (nx, ny) visited)

reconstructPath :: ParentMap -> Point -> Point -> [Char]
reconstructPath parentMap start end = reverse (go end [])
    where
        go current path
            | current == start = path
            | otherwise = 
                case Map.lookup current parentMap of
                    Just (prev, move) -> go prev (move : path)
                    Nothing -> error "Path reconstruction failed"

main :: IO ()
main = do
    input <- lines <$> getContents
    let (start, end, grid) = parseGrid input
    case bfs grid start end of
        Just path -> do
            putStrLn "YES"
            print $ length path
            putStrLn $ reverse path
        Nothing -> putStrLn "NO"