ecrit 0 = "zero"
ecrit 1 = "un"
ecrit 2 = "deux"
ecrit 3 = "trois"
ecrit 4 = "quatre"
ecrit 5 = "cinq"
ecrit 6 = "six"
ecrit 7 = "sept"
ecrit 8 = "huit"
ecrit 9 = "neuf"
ecrit 10 = "dix"
ecrit 11 = "onze"
ecrit 12 = "douze"
ecrit 13 = "treize"
ecrit 14 = "quatorze"
ecrit 15 = "quinze"
ecrit 16 = "seize"

ecrit 20 = "vingt"
ecrit 30 = "trente"
ecrit 40 = "quarante"
ecrit 50 = "cinquante"
ecrit 60 = "soixante"
ecrit 70 = "soixante-dix"
ecrit 80 = "quatre-vingts"
ecrit 90 = "quatre-vingts-dix"
ecrit 100 = "cent"

ecrit a
--	| a < 20 = ecrit_d a ++ "-" ++ (ecrit_u a)
	| (a < 80 && (mod a 10) == 1) = ecrit_d a ++ " et " ++ (ecrit_u a)
--	| a < 80 = ecrit_d a ++ " et " ++ (ecrit_u a)
	| otherwise = ecrit_d a ++ "-" ++ ecrit_u a

ecrit_u a
	| a < 70 = ecrit (mod a 10)
	| otherwise = ecrit(mod a 20)

ecrit_d a
	| a < 70 = ecrit ((div a 10) * 10)
	| otherwise = ecrit (a - mod a 20)

main = do
	print (ecrit 0)
	print (ecrit 1)
	print (ecrit 2)
	print (ecrit 3)
	print (ecrit 4)
	print (ecrit 5)
	print (ecrit 6)
	print (ecrit 7)
	print (ecrit 8)
	print (ecrit 9)
	print (ecrit 10)
	print (ecrit 11)
	print (ecrit 12)
	print (ecrit 13)
	print (ecrit 14)
	print (ecrit 15)
	print (ecrit 16)
	print (ecrit 17)
	print (ecrit 18)
	print (ecrit 19)
	print (ecrit 20)
	print (ecrit 21)
	print (ecrit 22)
	print (ecrit 23)
	print (ecrit 24)
	print (ecrit 25)
	print (ecrit 26)
	print (ecrit 27)
	print (ecrit 28)
	print (ecrit 29)
	print (ecrit 30)
	print (ecrit 31)
	print (ecrit 32)
	print (ecrit 33)
	print (ecrit 34)
	print (ecrit 35)
	print (ecrit 36)
	print (ecrit 37)
	print (ecrit 38)
	print (ecrit 39)
	print (ecrit 40)
	print (ecrit 41)
	print (ecrit 42)
	print (ecrit 43)
	print (ecrit 44)
	print (ecrit 45)
	print (ecrit 46)
	print (ecrit 47)
	print (ecrit 48)
	print (ecrit 49)
	print (ecrit 50)
	print (ecrit 51)
	print (ecrit 52)
	print (ecrit 53)
	print (ecrit 54)
	print (ecrit 55)
	print (ecrit 56)
	print (ecrit 57)
	print (ecrit 58)
	print (ecrit 59)
	print (ecrit 60)
	print (ecrit 61)
	print (ecrit 62)
	print (ecrit 63)
	print (ecrit 64)
	print (ecrit 65)
	print (ecrit 66)
	print (ecrit 67)
	print (ecrit 68)
	print (ecrit 69)
	print (ecrit 70)
	print (ecrit 71)
	print (ecrit 72)
	print (ecrit 73)
	print (ecrit 74)
	print (ecrit 75)
	print (ecrit 76)
	print (ecrit 77)
	print (ecrit 78)
	print (ecrit 79)
	print (ecrit 80)
	print (ecrit 81)
	print (ecrit 82)
	print (ecrit 83)
	print (ecrit 84)
	print (ecrit 85)
	print (ecrit 86)
	print (ecrit 87)
	print (ecrit 88)
	print (ecrit 89)
	print (ecrit 90)
	print (ecrit 91)
	print (ecrit 92)
	print (ecrit 93)
	print (ecrit 94)
	print (ecrit 95)
	print (ecrit 96)
	print (ecrit 97)
	print (ecrit 98)
	print (ecrit 99)
	print (ecrit 100)
