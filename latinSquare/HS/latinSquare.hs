-- Compute the minimal distance for Latin square

main = do
    let a = LS 2 [Point 1 1, Point 2 3]
        b = createLS 3 4
        --res = computeMinDisLS b
        res = computeDisPointPoint (Point 1 1) (Point 0 0)
    putStrLn ("test :\n" ++ (toString a) ++ show res)


-- definition of the types 
data LatinSquare = LS Integer [Point]
data Point = Point Integer Integer


-- functions used to print a LatinSquare
-- TODO overload show
toString :: LatinSquare -> String
toString (LS a []) = "\n"
toString (LS a (x:xs)) = toStringLine a x ++ "\n" ++ toString (LS a xs)

toStringLine :: Integer -> Point -> String
toStringLine a (Point px 0) = "X"
toStringLine a (Point px py) = " " ++ toStringLine a (Point px (py-1))




-- create the "num"-ieme Latinsquare of size "size"
createLS :: Integer -> Integer -> LatinSquare
createLS size num = LS size []




-- compute the minimal distance for a given latin square
computeMinDisLS :: LatinSquare -> Float
computeMinDisLS a = 0


computeListDisPointLS :: Point -> LatinSquare -> [Float]
computeListDisPointLS a (LS b (x:[])) = [computeDisPointPoint a x]
computeListDisPointLS a (LS b (x:xs)) = (computeDisPointPoint a x):(computeListDisPointLS a (LS b xs))


computeDisPointPoint :: Point -> Point -> Float
computeDisPointPoint (Point ax ay) (Point bx by) = sqrt (x'^2 + y'^2)
    where
        x' = fromIntegral bx - fromIntegral ax
        y' = fromIntegral by - fromIntegral ay
