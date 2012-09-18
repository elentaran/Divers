import Data.List
import Data.Char

main = do 
    putStrLn "hello, world"
--    putStrLn (show res30)

fib :: Integer -> Integer
fib 1 = 1
fib 2 = 1
fib 25 = 75025
fib 34 = 5702887
fib 35 = 9227465
fib 40 = 102334155
fib 60 = 1548008755920
fib 61 = 2504730781961

fib n = fib (n-1) + fib (n-2)

fibList :: Integer -> [Integer]
fibList 1 = [1]
fibList 2 = [1,1]
fibList n = (head (fibList (n-1)) + head(drop 1 (fibList(n-1)))):(fibList (n-1))


nbDigit :: Integer -> Integer
nbDigit 0 = 0
nbDigit n = 1 + nbDigit (div n 10)

sq5 = sqrt 5 :: Double
phi = (1 + sq5) / 2
fastFib n = round ((phi ** n) / sq5)



cTriangle :: [Integer] -> [Integer] -> [Integer]
cTriangle l1 l2 = zipWith (max) l3 l4
    where 
        l3 = zipWith (+) (0:l1) l2 
        l4 = zipWith (+) (l1 ++ [0]) l2

bigList = [ [75], [95,64], [17,47,82], [18,35,87,10], [20,04,82,47,65], [19,01,23,75,03,34], [88,02,77,73,07,63,67], [99,65,04,28,06,16,70,92], [41,41,26,56,83,40,80,70,33], [41,48,72,33,47,32,37,16,94,29], [53,71,44,65,25,43,91,52,97,51,14], [70,11,33,28,77,73,17,78,39,68,17,57], [91,71,52,38,17,14,91,43,58,50,27,29,48], [63,66,04,68,89,53,67,30,73,16,69,87,40,31], [04,62,98,27,23,09,70,98,73,93,38,53,60,04,23]]

res18 = maximum (foldl cTriangle [] bigList )


propDivisers :: Integer -> [Integer]
propDivisers n = [x | x <- [1..n], isDivisible n x]

isDivisible :: Integer -> Integer -> Bool
isDivisible n m  
    | m >= n = False
    | otherwise = (mod n m == 0)

isAmicals :: Integer -> Integer -> Bool
isAmicals m n = ((sum (propDivisers m) == n) && (sum (propDivisers n) == m))

sizemax = 10000
listD = [ sum (propDivisers x) | x <- [1..sizemax]]
pairD = zip [1..sizemax] listD
pairD2 = zip listD [1..sizemax]
listAmicals = [ fst x | x <- pairD, snd x < sizemax, snd x > 0, fst x /= snd x, (pairD !! (fromInteger (snd x - 1))) == (snd x, fst x)]

res21 = sum listAmicals



powerList = [ mod (x^x) (10^10) | x <- [1..1000]]
res48 = mod (sum powerList) (10^10)


-- problem 17 penible

listTen = ["","one", "two","three","four","five","six","seven","eight","nine"]
listTwenty = ["ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen"]
listDizaine = ["twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"]
listDizaineComp = foldl (++) [] (map (\y -> (map (\x -> y ++ x) listTen)) listDizaine) 
listCentaine = tail (map (\x -> x ++ "hundred") listTen)

listOneHundred = listTen ++ listTwenty ++ listDizaineComp

listAll = listOneHundred ++ (foldl (++) [] (map (\y -> (map (\x -> y ++ "and" ++ x) listOneHundred)) listCentaine)) ++ ["onethousand"] -- 9 "and" are added we remove them at the end (dirty)
res17 = length (foldl (++) "" listAll) -3*9

-- problem 22
test :: IO ()
test = do
    text <- readFile "names.txt"
    let myText = words text 
        res = nameScore (zip [1..(toInteger (length myText))] (sort myText))
    print res


nameScore :: [(Integer,[Char])] -> Integer
nameScore [] = 0
nameScore ((a,b):l) = a * (nameS b) + nameScore l 

nameS :: [Char] -> Integer
nameS [] = 0
nameS (a:l) = (charS a) + (nameS l)

charS :: Char -> Integer
charS a = toInteger((ord a) - 64)

-- problem 28
lengthDiag = 1001
nbJump = floor((lengthDiag-1)/2)
listJump = [x*2 | x <- [1..nbJump]]
listJump2 = concatMap (replicate 4) listJump
tempRes28 = foldList (+) 1 listJump2
res28 = foldl (+) 1 tempRes28

foldList :: (a -> b -> a) -> a -> [b] -> [a]
foldList fun first [] = []
foldList fun first (head:[]) = [fun first head]
foldList fun first (head:tail) = ((fun first head):(foldList fun (fun first head) tail))

-- problem 24
fac :: Integer -> Integer
fac 1 = 1
fac n = n * fac (n-1)

val = 1000000
baseFac = [ fac x | x <- [1..10]] 
baseFac2 = reverse baseFac
listRes = foldList (mod) val baseFac2
res24 = zip (init listRes) (tail baseFac2)


-- problem 30
pui = 4
-- res30 = [ x | x = 100000 * a1 + 10000 * a2 + 1000 * a3 + 100 * a4 + 10 * a5 + a6, a1
-- res30 = [ x | x <- 1000 * a3 + 100 * a4 + 10 * a5 + a6, x == a3^pui + a4^pui + a5^pui + a6^pui, a3 <- [0..9], a4 <- [0..9], a5 <- [0..9], a6 <- [0..9]]



