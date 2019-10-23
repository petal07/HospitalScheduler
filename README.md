# Hospital Scheduler
CPSC 312 project - Interval Scheduling Problem in Haskell

## What You Need
- Haskell's GHC (see https://www.haskell.org/downloads/)
- csv file in the same folder as source code

## Example Input

***Note: format of the csv file***
- The starting and ending times must be from Zero to Twenty_Three (24 hour clock).
- The syntax is as follows: Patient Name, Starting Time, Ending Time

***Sample input .csv file***
```
Al,One,Three
Beth,One,Two
Cia,Two,Four
Dani,Three,Six
Ellie,Twenty,Twenty_Two
```

## Running The Program
- In terminal, change directories to be wherever the project and input csv file are saved
- run `ghci`
- run `:load HospitalScheduler`
- run `run`
- Follow the prompts that appear
- Output will appear on the command line, as well as being printed to a txt output file.

## Example Output:
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
