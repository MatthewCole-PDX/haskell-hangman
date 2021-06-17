The program is an executable and runs the game of hangman from the command line
It was created with the help of cabal and runs from the program executable main.lhs
Included are three required text files: "hardWords.txt", "mediumWords.txt", and "easyWords.txt" which reads from at runtime.
Also included is the "myProject.cabal" file with build depends "random" and "directory".


>module Main where
>import System.Environment
>import System.Directory
>import System.IO
>import Data.List
>import Data.Char
>import System.Random

In this program we will be working with an IO system in order to play a game of hangman.
We will use two global variables, one of type data to monitor whether the game is active or not, and one a basic integer to set the game length

>chances = 7
>data GameOutcome = GreatGood | Incomplete | NotGood deriving (Eq)

The program is an executable and runs from a program main which reads from three different text files organized by difficuty.

>main :: IO ()
>main = do
>    hSetBuffering stdout NoBuffering
>    putStrLn "Welcome to 'Learn you a Hangman for great good!'" 
>    hardWordsLibrary <- readFile "hardWords.txt"
>    let hardWords = lines hardWordsLibrary
>    mediumWordsLibrary <- readFile "mediumWords.txt"
>    let mediumWords = lines mediumWordsLibrary
>    easyWordsLibrary   <- readFile "easyWords.txt"
>    let easyWords = lines easyWordsLibrary
>    libraries easyWords mediumWords hardWords

main calls the libraries function which runs the backend of the game and act as a secondary main function
the user will select one of three libraries before starting the game
libraries then calls a random number generator using getStdGen in order to choose and index i from one of the three input files
libraries will also display the result of the game at the end

>libraries :: [String] -> [String] -> [String] -> IO ()
>libraries beginner normal expert = do
>    putStrLn "Menu"
>    (Just option)  <- menuSelect
>    putStrLn $ "Currently playing on " ++ option ++" mode."
>    let library =  if option == "Expert" then expert else
>                   if option == "Normal" then normal else beginner
>    random <- getStdGen
>    let (i, newRandom ) = randomR (0, length library) random
>        secretWord = map toLower (library !! i)
>    outcome <- parseInput secretWord ""
>    let displayOutcome =   if outcome == NotGood then "   ___ \n" ++ "  |  \\| \n" ++ "  O   | \n" ++ " /|\\  | \n" ++ " / \\  | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n" ++ "Game Over" else "for Great Good!"
>    putStrLn displayOutcome
>    putStrLn $ "Secret Word: " ++ secretWord

libraries first calls menu select which displays the frontend of the config interface
menuSelect returns to libraries the user's selection as an IO string

>menuSelect :: IO (Maybe String)
>menuSelect = do
>    putStrLn "Select Difficulty:"
>    putStrLn "1) Beginner (You know nothing, John Snow)"
>    putStrLn "2) Normal (You know some things, John Snow)"
>    putStrLn "3) Expert (You know everything, John Snow)"
>    option <- getChar
>    return $ checkOption option

checkOption takes a character from MenuSelect and returns it as a string

>checkOption :: Char -> (Maybe String)
>checkOption '1' = Just "Beginner"
>checkOption '2' = Just "Normal"
>checkOption '3' = Just "Expert"
>checkOption _ = Nothing

libraries second call is parseInput with the argument of the secret word
parseInput will now run until the game is complete, acting as the game driver
It first displays a graphical representation of the game called displayGallows, 
then a string view of the puzzzle, then a conjoined string of incorrect guessed letters,
then a countdown number to the end of the game,
and finally an input for the user's next attempt

>parseInput :: String -> String -> IO GameOutcome
>parseInput secretWord attempted = do
>    let displayGallows = if chances - length (wrong secretWord attempted) == 7 then "------" else 
>                         if chances - length (wrong secretWord attempted) == 6 then "   ___ \n" ++ "  |  \\| \n" ++ "      | \n" ++ "      | \n" ++ "      | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n" else 
>                         if chances - length (wrong secretWord attempted) == 5 then "   ___ \n" ++ "  |  \\| \n" ++ "  O   | \n" ++ "      | \n" ++ "      | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n" else 
>                         if chances - length (wrong secretWord attempted) == 4 then "   ___ \n" ++ "  |  \\| \n" ++ "  O   | \n" ++ "  |   | \n" ++ "      | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n" else 
>                         if chances - length (wrong secretWord attempted) == 3 then "   ___ \n" ++ "  |  \\| \n" ++ "  O   | \n" ++ " /|   | \n" ++ "      | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n" else 
>                         if chances - length (wrong secretWord attempted) == 2 then "   ___ \n" ++ "  |  \\| \n" ++ "  O   | \n" ++ " /|\\  | \n" ++ "      | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n" else  "   ___ \n" ++ "  |  \\| \n" ++ "  O   | \n" ++ " /|\\  | \n" ++ " /    | \n" ++ "     /|\\  \n" ++ "    /_|_\\ \n"
>                         
>    putStrLn displayGallows
>    putStrLn $ "Word: " ++ blankSpaces secretWord attempted
>    putStrLn $ "Previous incorrect guesses: "
>    putStrLn $ (conjoin $ zip (wrong secretWord attempted) (repeat ' '))
>    putStrLn $ "Chances: " ++ show (chances - length (wrong secretWord attempted))
>    input "Pick a letter: "
>    attempt <- getChar
>    let attempt'           = toLower attempt
>        displayOutcome     =   if attempt' `elem` attempted then "Already tried that." else
>                               if attempt' `elem` secretWord then "Correct!" else "Wrong."
>        attempted'         =   if attempt' `elem` attempted then attempted else attempt':attempted
>        outcome            =   if (removeSpaces $ blankSpaces secretWord attempted') == secretWord then GreatGood else
>                               if length (wrong secretWord attempted') == chances then NotGood else Incomplete
>        lastAction  = case outcome of GreatGood   -> return GreatGood
>                                      NotGood     -> return NotGood
>                                      Incomplete  -> parseInput secretWord attempted'
>    putStrLn displayOutcome
>    lastAction

parseInput returns the Data of gameOutcome to Libraries once finished, or calls itself recursively if still in the game

parseInput also calls blankSpaces which conjoins blank spaces with returned character ids from a map of returns from unrevealed

>blankSpaces :: String -> String -> String
>blankSpaces secretWord attempted = conjoin $ zip blnks blankSpaces
>                    where   blnks = map (`unrevealed` attempted) secretWord
>                            blankSpaces = repeat ' '

unrevealed is a helper that returns _ if char not guessed, otherwise id

>unrevealed :: Char -> String -> Char
>unrevealed c attempted = if c `elem` attempted then c else '_'

wrong is a helper that generates list of incorrect attempts given secretWord and list of attempts

>wrong :: String -> String -> String
>wrong secretWord attempted = [ x | x <- attempted, not $ x `elem` secretWord]

conjoin is a helper foldr function for assembling strings of character pairs

>conjoin :: [(Char, Char)] -> String
>conjoin pairs = foldr (\(x,s) acc -> x:s:acc) "" pairs

removeSpaces helps parseInput read the conjoined correct guesses to determine if the entire word has been revealed

>removeSpaces :: String -> String
>removeSpaces = filter (/= ' ')

input is the function that takes the user's guesses as an argument and returns them to parseInput

>input :: String -> IO String
>input text = do
>    putStr text
>    hFlush stdout
>    getLine
