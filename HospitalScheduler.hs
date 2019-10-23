import Data.List (minimumBy, sortBy)
import Data.Ord (comparing)
import System.IO

run :: IO String
run = 
    do  
        hSetBuffering stdin LineBuffering -- this allows the backspace key to work on Mac's terminal
        openingTerminalText
        putStrLn("Enter 'yes' to begin loading today's patients schedule:")
        ans <- getLine
        if (ans `elem` ["y","yes","YES","Yes"])
            then do
                putStrLn("")
                putStrLn("Enter the name of the .csv file which contains your patients list (including .csv):")
                csvFileName <- getLine
                putStrLn("")
                file <- readCsv (csvFileName)
                if (file == [[""]]) then return "ERROR: Input .csv file is empty."
                    else do
                        let inputPatientsList = (readCsvToPatients file)
                        let inputPatientsAsTuples = patientsToTuples inputPatientsList
                        let inputPatientsForPrint = tuplesToPrintableString inputPatientsAsTuples
                        putStrLn("**LOADED FILE** " ++ csvFileName ++ " contains the following patients:")
                        putStrLn("---------------------------------------------")
                        putStrLn(inputPatientsForPrint)
                        putStrLn("Would you like to add another patient to this list? Enter 'yes' or 'no':")
                        ans <- getLine
                        putStrLn("")
                        if (ans `elem` ["y","yes","YES","Yes"])
                            then do
                                putStrLn("Enter the patient's name, appointment start time, and appointment end time (using a 24 hour clock).")
                                putStrLn("For example: 'John Doe, Thirteen, Fifteen' (not including the '' symbols).")
                                inputPatientAsString <- getLine
                                putStrLn("")
                                putStrLn("")
                                let inputPatientAsStringList = splitSep (== ',') inputPatientAsString
                                let newPatient = createPatient inputPatientAsStringList
                                let newPatientAsListOfPatient = newPatient : []
                                let newPatientsList = inputPatientsList ++ newPatientAsListOfPatient
                                let newPatientsAsTuples = patientsToTuples newPatientsList
                                let newPatientsForPrint = tuplesToPrintableString newPatientsAsTuples
                                putStrLn("**UPDATED LIST** today's patients list now contains the following patients:")
                                putStrLn("---------------------------------------------")
                                putStrLn(newPatientsForPrint)
                                let sortedPatientsList = sortPatients (sortBy (comparing endTime) newPatientsList)
                                let sortedTuplesListDr1 = patientsToTuples sortedPatientsList
                                let sortedTuplesListDr2 = patientsToTuples (sortPatients (removeSeenPatients newPatientsList sortedPatientsList))
                                let finalPatientsListDr1 = tuplesToPrintableString sortedTuplesListDr1
                                let finalPatientsListDr2 = tuplesToPrintableString sortedTuplesListDr2
                                putStrLn("Enter the name for the .txt file in which Hospital Scheduler will save its output (including .txt):")
                                txtFileName <- getLine
                                let numOfDrs = show (length (minDrsList newPatientsList))
                                putStrLn("")
                                putStrLn("")
                                putStrLn("***************************************************************")
                                putStrLn ("NOTE: To see all of today's patients, you would need " ++ numOfDrs ++ " doctors.")
                                putStrLn("***************************************************************")
                                printPatients finalPatientsListDr1 finalPatientsListDr2 txtFileName
                                closingTerminalTextDr1
                                putStrLn(finalPatientsListDr1)
                                closingTerminalTextDr2
                                putStrLn(finalPatientsListDr2)
                                putStrLn("")
                                putStrLn("")
                                return "Process complete."
                        else do
                            let sortedPatientsList = sortPatients (sortBy (comparing endTime) inputPatientsList)
                            let sortedTuplesListDr1 = patientsToTuples sortedPatientsList
                            let sortedTuplesListDr2 = patientsToTuples (sortPatients (removeSeenPatients inputPatientsList sortedPatientsList))
                            let finalPatientsListDr1 = tuplesToPrintableString sortedTuplesListDr1
                            let finalPatientsListDr2 = tuplesToPrintableString sortedTuplesListDr2
                            putStrLn("Enter the name for the .txt file in which Hospital Scheduler will save its output (including .txt):")
                            txtFileName <- getLine
                            let numOfDrs = show (length (minDrsList inputPatientsList))
                            putStrLn("")
                            putStrLn("")
                            putStrLn("***************************************************************")
                            putStrLn ("NOTE: To see all of today's patients, you would need " ++ numOfDrs ++ " doctors.")
                            putStrLn("***************************************************************")
                            printPatients finalPatientsListDr1 finalPatientsListDr2 txtFileName
                            closingTerminalTextDr1
                            putStrLn(finalPatientsListDr1)
                            closingTerminalTextDr2
                            putStrLn(finalPatientsListDr2)
                            putStrLn("")
                            putStrLn("")
                            return "Process complete."
        else return "ERROR: Invalid input. Program closing."

-- data type for the Time (in order)
data Time = Zero | One | Two | Three | Four | Five
           | Six | Seven | Eight | Nine | Ten | Eleven
           | Twelve | Thirteen | Fourteen | Fifteen
           | Sixteen | Seventeen | Eighteen | Nineteen
           | Twenty | Twenty_One | Twenty_Two | Twenty_Three
            deriving (Ord, Eq, Show, Read)

-- data type for a Patient
data Patient = No_Patient |
    Patient { name :: String
            , startTime :: Time
            , endTime :: Time
            }   deriving (Ord, Eq, Show)

-- text that is printed on the terminal after the user enters: 'run'
-- welcoming messages for the user
openingTerminalText :: IO ()
openingTerminalText = do
    putStrLn("")
    putStrLn("************************")
    putStrLn("Hospital Scheduler 2019")
    putStrLn("************************")
    putStrLn("")
    putStrLn("")
    putStrLn("Hello! Welcome to Hospital Scheduler.")

-- text that is printed on the terminal after the user enters the name for the output file
-- the header and sub-header for Dr 1's patient schedule
closingTerminalTextDr1 :: IO ()
closingTerminalTextDr1 = do
    putStrLn("")
    putStrLn("")
    putStrLn("------------------------------")
    putStrLn("1st Doctor's Patient Schedule:")
    putStrLn("------------------------------")
    putStrLn("NAME, START TIME, END TIME")

-- text that is printed on the terminal after closingTerminalTextDr1 is printed
-- the header and sub-header for Dr 2's patient schedule
closingTerminalTextDr2 :: IO ()
closingTerminalTextDr2 = do
    putStrLn("")
    putStrLn("")
    putStrLn("------------------------------")
    putStrLn("2nd Doctor's Patient Schedule:")
    putStrLn("------------------------------")
    putStrLn("NAME, START TIME, END TIME")

-- returns the minimum number of doctors necessary to see the given list of patients
-- returns the list of all schedules needed to see all patients
minDrsList :: [Patient] -> [[Patient]]
minDrsList [] = []
minDrsList lst = seenPatients : (minDrsList unseenPatients)
        where 
            seenPatients = sortPatients lst
            unseenPatients = removeSeenPatients lst seenPatients

-- convert list of name and time tuples tuples into a single string
-- separate each patient onto his/her own line
-- concat each patient's name to his/her startTime, with a comma and a space between
tuplesToPrintableString :: [(String,Time,Time)] -> String
tuplesToPrintableString [] = ""
tuplesToPrintableString lst = concatMap printify lst
  where
    printify (name, startTime, endTime) = (show name) ++ ", " ++ (show startTime) ++ ", " ++ (show endTime) ++ "\n"

-- print Dr1 and Dr2's schedules to output .txt file
-- .txt file will be named according to the user's input
printPatients :: String -> String -> String -> IO ()
printPatients [] _ txtFileName = writeFile txtFileName "ERROR: no patients in the inputted .csv file."
printPatients lst1 lst2 txtFileName =
    writeFile txtFileName textToPrint
    where
        textToPrint =
            "------------------------------" ++
            "\n" ++
            "1st Doctor's Patient Schedule:" ++
            "\n" ++
            "------------------------------" ++
            "\n" ++
            "NAME, START TIME, END TIME" ++
            "\n" ++
            lst1 ++
            "\n" ++
            "\n" ++
            "------------------------------" ++
            "\n" ++
            "2nd Doctor's Patient Schedule:" ++
            "\n" ++
            "------------------------------" ++
            "\n" ++
            "NAME, START TIME, END TIME" ++
            "\n" ++
            lst2

-- creates a list of patients from the inputted csv file
readCsvToPatients :: [[String]] -> [Patient]
readCsvToPatients [[]] = []
readCsvToPatients [] = []
readCsvToPatients lst = map createPatient lst

-- creates a patient
createPatient :: [String] -> Patient
createPatient (a:b:c:d) = Patient a (read b :: Time) (read c :: Time)

-- given a list of patients, returns a list of patients sorted in the optimal order
sortPatients :: [Patient] -> [Patient]
sortPatients [] = []
sortPatients (h:t) = min : sortPatients (removeConflicts min (sortBy (comparing startTime) (h:t)))
    where min = minimumBy (comparing endTime) (h:t)

-- convert list of patients to list of name and time tuples
patientsToTuples :: [Patient] -> [(String,Time,Time)]
patientsToTuples [] = []
patientsToTuples (h:t) = (name h, startTime h, endTime h) : patientsToTuples t

-- filters the patients already seen from the list of all patients given
-- removeSeenPatients :: allPatients firstList -> newPatientsList
removeSeenPatients :: [Patient] -> [Patient] -> [Patient]
removeSeenPatients [] _ = []
removeSeenPatients  allP firstP = filter (\x -> not (x `elem` firstP)) allP

-- removes the patients whose appointments conflict with that of the already chosen patient
removeConflicts :: Patient -> [Patient] -> [Patient]
removeConflicts p [] = []
removeConflicts p (h:t)
    | endTime p > startTime h = removeConflicts p t
    | otherwise = h : removeConflicts p t

-- credit to David Poole, Homework 3 Question 3
splitSep :: (a -> Bool) -> [a] -> [[a]]
splitSep f [] = [[]]
splitSep f (h:t)
    | f h = [] : splitSep f t
    | otherwise = ((h:t1):t2) where t1:t2 = splitSep f t

-- credit to David Poole, Homework 3 Question 3
readCsv fileName = 
    do
        file <- readFile fileName
        return [splitSep (== ',') line | line <- splitSep (== '\n') file]
