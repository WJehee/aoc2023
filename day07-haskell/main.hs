import System.IO  
import Control.Monad
import Data.List
import Data.Foldable
import Data.Tuple

data Hand = HighCard | OnePair | TwoPair | Three | FullHouse | Four | Five deriving (Eq, Ord, Enum, Show)

main = do  
        contents <- readFile "input.txt"
        print . sum . map snd . process . map parse . lines $ contents

parse :: String -> (String, Int)
parse line = (hand, bid) where
    ws = take 2 $ words $ line
    hand = head ws 
    bid = read $ last ws 

process :: [(String, Int)] -> [(String ,Int)]
process items = x where
    apply_rank (i, x) = (fst x, (i * snd x))
    -- change the argument to sort_pairs, part1 = False, part2 = True
    x = map apply_rank $ zip [1..] $ sortBy (sort_pairs True) items

sort_pairs :: Bool -> (String, Int) -> (String, Int) -> Ordering
sort_pairs part2 x y =
    if xHand /= yHand then compare xHand yHand
    else myCompare (fst x) (fst y) part2 where
    xHand = get_hand (fst x) part2
    yHand = get_hand (fst y) part2

freqs :: Ord a => [a] -> [(a, Int)]
freqs str = [(head x, length x) | x <- group (sort str)]

get_hand :: String -> Bool -> Hand
get_hand x part2 = if part2 then apply_jokers num_jokers best_hand else best_hand
    where
    best_hand = foldr (\x y -> if x > y then x else y) HighCard $ combine_options $ get_options $ freqs x
    num_jokers = case filter (\x -> fst x == 'J') $ freqs x of
        []     -> 0
        (j:_)  -> snd j

    get_options :: [(Char, Int)] -> [Hand]
    get_options [] = []
    get_options (f:fs) = case f of
        ('J', _)        -> get_options fs
        (_, 1)          -> HighCard : get_options fs
        (_, 2)          -> OnePair : get_options fs
        (_, 3)          -> Three : get_options fs
        (_, 4)          -> Four : get_options fs
        (_, x) | x >= 5 -> Five : get_options fs

    apply_jokers :: Int -> Hand -> Hand
    apply_jokers 0 h                = h
    apply_jokers _ Five             = Five
    apply_jokers 1 HighCard         = OnePair
    apply_jokers 1 OnePair          = Three
    apply_jokers 1 TwoPair          = FullHouse
    apply_jokers 1 Three            = Four
    apply_jokers 1 FullHouse        = Four
    apply_jokers 1 Four             = Five
    apply_jokers j h | j >= 0       = apply_jokers (j-1) $ apply_jokers 1 h

    combine_options :: [Hand] -> [Hand]
    combine_options fs = fs ++ fullhouse ++ twopair where
        fullhouse = if (length (filter (== Three) fs) == 1) && (length (filter (== OnePair) fs) == 1) then [FullHouse] else []
        twopair = if (length (filter (== OnePair) fs) == 2) then [TwoPair] else []

myCompare :: String -> String -> Bool -> Ordering
myCompare x y part2 = cmp x y chars
    where
    charlist = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
    charlist2 = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']
    chars = if part2 then charlist2 else charlist

    cmp _ _ [] = EQ
    cmp [] _ _ = EQ
    cmp (x:xs) (y:ys) (c:cs) = case c of
        c | x == c && y == c  -> cmp xs ys chars
        c | x == c            -> GT
        c | y == c            -> LT
        _                     -> cmp (x:xs) (y:ys) cs


