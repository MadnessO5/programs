# OlympiadCounter

A Pascal program that reads a list of olympiad participants from a text file and prints the number(s) of the school(s) that sent the most participants.

## Problem

An informatics olympiad is held in a city with 67 schools (numbered 1 to 67). Each participant is registered with a ticket number: the last two digits are the participant's number within their school, and the remaining leading digits are the school number (e.g. school №5 issues tickets 501, 502, ...; school №49 issues tickets 4901, 4902, ...).

Participants are recorded, one per line, in a file olymp.txt, each line containing the ticket number followed by the participant's surname and first name, e.g.:

5803 Ivanov Vasily
401 Lavrukhina Olga
419 Gorelik Oksana
2102 Borisov Andrey
The program only needs the ticket numbers (names are read and skipped) and must determine which school(s) sent the most participants.

## Files

- **olympcount.pas** — the Pascal source code.
- **olymp.txt** — a sample input file with test data (15 participants across several schools; school №5 has the most participants in this sample).
- **README.md** — this file.

## Requirements

- Free Pascal (fpc) or any compatible Pascal compiler.

## How to build and run

Compile the program:

fpc olympcount.pas
Run it with olymp.txt redirected to standard input (the program reads from stdin until end of file, it does not open the file itself):

./olympcount < olymp.txt
With the provided sample data, the output is:

5
meaning school №5 had the largest number of registered participants.

## Notes

- Input is read with readln under {$I-}, so any malformed line makes the program print Incorrect data and stop with exit code 1.
- If a ticket number implies a school number outside the valid range (1..67), the program prints Illegal school id: <n> [<ticket>] and stops with exit code 1. Try adding a line like 9999 Test Participant to olymp.txt to see this in action.
- If several schools are tied for the maximum number of participants, the program prints all of their numbers, one per line.
- To test with your own data, edit olymp.txt (or create another file and redirect it the same way) using the format <ticket> <surname> <name> per line.
