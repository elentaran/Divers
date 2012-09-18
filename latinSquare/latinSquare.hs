main = do
    let a = LS 2 [1,2]
        b = createLS 3 4
        res = computeMinDisLS b
    putStrLn ("test :\n" ++ (toString a) ++ show res)


data LatinSquare = LS Integer [Integer]

toString :: LatinSquare -> String
toString (LS a []) = "\n"
toString (LS a (x:xs)) = toStringLine a x ++ "\n" ++ toString (LS a xs)

toStringLine :: Integer -> Integer -> String
toStringLine a 0 = "X"
toStringLine a b = " " ++ toStringLine a (b-1)


createLS :: Integer -> Integer -> LatinSquare
createLS size num = LS size []


computeMinDisLS :: LatinSquare -> Float
computeMinDisLS a = 0
