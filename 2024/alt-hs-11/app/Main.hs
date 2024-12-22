{-# LANGUAGE BangPatterns #-}
module Main where

import Control.Parallel.Strategies (parMap, rdeepseq)
import Data.Time.Clock (getCurrentTime, diffUTCTime)

{-# INLINE numberLength #-}
numberLength :: Int -> Int
numberLength 0 = 1
numberLength n = go n 0
  where
    go !numb !len
      | numb <= 0 = len
      | otherwise = go (numb `div` 10) (len + 1)

{-# INLINE splitNumber #-}
splitNumber :: Int -> (Int, Int)
splitNumber !n = 
    let !len = numberLength n
        !half = len `div` 2
        !divisor = 10 ^ half
        !second = n `mod` divisor
        !first = n `div` divisor
    in (first, second)

{-# INLINE blinkOne #-}
blinkOne :: Int -> Maybe [Int]
blinkOne 0 = Just [1]
blinkOne !n = 
    Just $! if even len
        then [first, second]
        else [n * 2024]
    where
        !len = numberLength n
        !(first, second) = splitNumber n

blinkStones :: [Int] -> Int -> Int
blinkStones stones !timesRem
    | timesRem < 1 = length stones
    | otherwise = 
        sum $ parMap rdeepseq processStone stones
    where
        processStone !stone = 
            case blinkOne stone of
                Just values -> blinkStones values (timesRem - 1)
                Nothing -> 0

main :: IO ()
main = do
    let puzzleInput = "6563348 67 395 0 6 4425 89567 739318"
    let !stones = map read $ words puzzleInput :: [Int]

    t0 <- getCurrentTime
    let !result = blinkStones stones 45
    t1 <- getCurrentTime

    putStrLn $ "Result 1: " ++ show result
    putStrLn $ "Time 1: " ++ show (diffUTCTime t1 t0)
