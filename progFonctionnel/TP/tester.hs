import Text.Printf
import System.Environment


-- ######################
-- # Importation des TP #
-- ######################

import qualified TP2
import qualified TP3
import qualified TP4
import qualified TP5
import qualified TP6

-- Prend du texte representant l'appel, la valeur du resulat attendu, et le resultat de l'appel
-- Renvoi la representation du resultat au format: "appel -> res -> True/False"
test_function (str, attendu, res)
	| attendu == res = ok ++ "[V]" ++ fi ++ str ++ " -> " ++ ok ++ res ++ fi
	| otherwise = ko ++ "[X]" ++ fi ++ str ++ " -> " ++ ko ++ "Wanted " ++ attendu ++ " and got " ++ res ++ " instead" ++ fi
	where
		ok = "\x1b[32m"
		ko = "\x1b[41m"
		fi = "\x1b[0m"

chooseset "2" = TP2.tests
chooseset "3" = TP3.tests
chooseset "4" = TP4.tests
chooseset "5" = TP5.tests
chooseset "6" = TP6.tests



do_all_tests tests = map (\b -> map test_function b) tests
concat_with_nl tab = foldl (\a e -> a++e++"\n") "" tab
results numtp =
	concat_with_nl (sep:("# Execution des test du TP" ++ numtp ++ " #"):sep:(map concat_with_nl (do_all_tests (chooseset numtp))))
	where sep = "#############################"


main = do
	args <- getArgs
	printf (results (head args))
	printf "\n\n"

