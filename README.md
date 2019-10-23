# HospitalScheduler
CPSC 312 project - Interval Scheduling Problem in Haskell

## What you need
- Haskell's GHC (see https://www.haskell.org/downloads/)
- csv file in the same folder as source code

## Format of the csv file
Note: the starting and ending times must be from Zero to Twenty_Three (24 hour clock): 

***Patient Name, Starting Time, Ending Time***

***Example***:

Al,One,Three

Beth,One,Two

Cia,Two,Four

Dani,Three,Six

Ellie,Twenty,Twenty_Two

## Running the program
- In terminal, change directories to be wherever the project and input csv file are saved
- run `ghci`
- run `:load HospitalScheduler`
- run `run`

## Example output:
```
***************************************************************
NOTE: To see all of today's patients, you would need 4 doctors.
***************************************************************


------------------------------
1st Doctor's Patient Schedule:
------------------------------
NAME, START TIME, END TIME
"Betty White", One, Four
"Emerald Wong", Four, Seven
"Harold Goldberg", Eight, Eleven



------------------------------
2nd Doctor's Patient Schedule:
------------------------------
NAME, START TIME, END TIME
"Cara Hayle", Three, Five
"Fiona Jefferson", Five, Nine
```
