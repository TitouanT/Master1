module TestCommon where
string_tuples tuples = map (\ (a,b,c) -> (a, show b, show c)) tuples
