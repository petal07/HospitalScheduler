# HospitalScheduler
CPSC 312 project - Interval Scheduling Problem in Haskell

## What you need
- Haskell's GHC (see https://www.haskell.org/downloads/)
- csv file in the same folder as source code

## Format of the csv file
Note: the starting and ending times must be from Zero to Twenty_Three (24 hour clock)
Patient Name, Starting Time, Ending Time \n
Example: \n
Al,One,Three \n
Beth,One,Two \n
Cia,Two,Four \n
Dani,Three,Six \n
Ellie,Twenty,Twenty_Two

## Running the program
- In terminal, change directories to be wherever the project and input csv file are saved
- run `ghci`
- run `:load HospitalScheduler`
- run `run`

## Example output:
NOTE: To see all of today's patients, you would need 2 doctors.

1st Doctor's Patient Schedule:
NAME, START TIME, END TIME
"Beth", One, Two
"Cia", Two, Four
"Ellie", Twenty, Twenty_Two

2nd Doctor's Patient Schedule:
NAME, START TIME, END TIME
"Al", One, Three
"Dani", Three, Six

"Process complete."
