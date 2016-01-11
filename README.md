# pass-survey
Have a list of passwords you cracked during a pentest or password audit? This shell script will give you statistical information about different character type combinations and password lengths. Dictionary checks are now included, with built-in dictionaries for months, seasons, sports teams, first and last names, dictionary words, years, and sequential or repeating letters and numbers.

# Usage
`pass-survey.sh` only requires an input file. Each line of the input file will be treated as a password.

`./pass-survey.sh [inputfilename] [-o outputfilename]`

**-o** allows you to specify an output file.

Dictionary checks have been added, so that passwords can be checked for common strings that could make cracking or guessing easier. The **Dictionary Checks** section includes more detail on the built-in dictionaries.

**--no-dict** disables dictionary checks.

**--dict [dictionaryfilename]** allows you to specify a different dictionary. This can be used with or without the built-in dictionaries.

**--only-custom** disables the (other) built-in dictionaries. It will use `dictionaries/custom.txt`, or the file specified with `--dict [dictionaryfilename]`.

**-v** specifies verbose output. While doing dictionar checks, the current dictionary and line being checked is shown as it runs. Without this option, that line keeps getting overwritten, regardless of whether there are 0 or more hits. With this option, lines with hits are retained, and the scrolling attempts move down a line.

# Dictionary Checks

Built-in dictionaries are included in the `dictionaries` directory. The script reads through each line or each dictionary, doing a case-insensitive grep for that line in the input file. Thus, the timing depends primarily on the dictionaries and not the input file. Benchmarks were done with 50, 900, and 9000 line input files and verbose mode, during which the built-in dictionaries averaged 10 minutes and 52 seconds on a Kali 2 VM with 4 GB of memory on a desktop computer. This average was consistent with vastly different input files.

* Custom
  - The default file is `dictionaries/custom.txt`. This is empty, and is there so you can customize it with content like company-specific strings or other personalized dictionary checks.
  - **--dict [filename]** can be used to specify a different custom dictionary.
  - **--only-custom** disables the other built-in dictionaries, so you can use either the built-in custom dictionary, or your own, by itself. You can also use these options to specify one of the built-in dictionaries to run alone, like `--dict dictionaries/years.txt --only-custom`.
  - The custom dictionary will be ignored if it is 0 lines.
* Months - `dictionaries/months.txt`
* Seasons - `dictionaries/seasons.txt`
* Sports Team Names - `dictionaries/teams.txt`
  - 115 lines.
  - Includes MLB, NBA, NFL, and NHL teams.
* First Names - `dictionaries/firstnames.txt`
  - 2500 lines.
  - Includes the 2500 most common first names that were 3+ characters, based on US census data.
* Last Names - `dictionaries/lastnames.txt`
  - 2500 lines.
  - Includes the 2500 most common last names that were 5+ characters, based on US census data.
* Dictionary Words - `dictionaries/words.txt`
  - 61937 lines.
  - Based on the Princeton WordNet index files.
  - Excludes words that were less than 4 characters, or included numbers or special characters.
  - Includes up to the first 8 characters of the words that were not excluded.
* Years (1900-2199) - `dictionaries/years.txt`
* Sequential/Repeating Characters - `dictionaries/sequential_repeating.txt`
  - 297 lines.
  - Includes 3-9 character sequential and 3-8 character repeating numbers (ex: 123-123456789, 111-11111111, etc.).
  - Includes 3-8 character sequential and repeating letters (ex: abc-abcdefgh, aaa-aaaaaaaa, etc.).
  - Includes 3-8 character keyboard rows, starting with Q, A, and Z (ex: qwe-qwertyui, asd-asdfghjk, etc.).



# Example
```
# ./pass-survey.sh testfile.txt -v


  ============[ pass-survey.sh - Ted R (github: actuated) ]============

  File          testfile.txt
  Passwords     9

  Dictionary Checks: Built-In

  Press Enter to begin...

  =============================[ parsing ]=============================

  Dictionary Check: Started 09:58:06 PM
  Note: See help/usage (-h) for options and information.
  Dictionary Check: (4/9) Sports Teams : penguins : 1 Hit(s)                           
  Dictionary Check: (5/9) First Names : john : 1 Hit(s)                                
  Dictionary Check: (5/9) First Names : johnny : 1 Hit(s)                          
  Dictionary Check: (7/9) Words : chair : 1 Hit(s)                                    
  Dictionary Check: (7/9) Words : hair : 1 Hit(s)                           
  Dictionary Check: (7/9) Words : john : 1 Hit(s)                           
  Dictionary Check: (7/9) Words : johnny : 1 Hit(s)                       
  Dictionary Check: (7/9) Words : pass : 1 Hit(s)                           
  Dictionary Check: (7/9) Words : password : 1 Hit(s)                       
  Dictionary Check: (7/9) Words : penguin : 1 Hit(s)                        
  Dictionary Check: (7/9) Words : sword : 1 Hit(s)                          
  Dictionary Check: (7/9) Words : word : 1 Hit(s)                           
  Dictionary Check: (8/9) Years : 2016 : 1 Hit(s)                           
  Dictionary Check: (9/9) Sequential/Repeating : 999 : 1 Hit(s)                             
  Dictionary Check: (9/9) Sequential/Repeating : abc : 1 Hit(s)                            
  Dictionary Check: Done 10:08:55 PM                                                       

  =========================[ character types ]=========================

  Totals

        2       Blank Passwords                 22.2%
        3       Only One Character Type         33.3%
        1       Only Two Character Types        11.1%
        1       Only Three Chracter Types       11.1%
        2       All Four Character Types        22.2%

  Breakdown

        Pwds    Character Types (See Help for Legend)

        2       [Blank]
        2       abc
        1       123
        1       abc + ABC
        1       abc + ABC + 123
        2       abc + ABC + 123 + !@#

  ========================[ dictionary checks ]========================

        0       Hit(s): Months
        0       Hit(s): Seasons
        1       Hit(s): Sports Team Names
        2       Hit(s): First Names (US Census Top 2500, 3+ Chars)
        0       Hit(s): Last Names (US Census Top 2500, 5+ Chars)
        9       Hit(s): Words (4 - 1st 8 Chars, WordNet Indexes)
        1       Hit(s): Years (1900-2199)
        2       Hit(s): Sequential or Repeating Chars (3+)

  Note: Passwords may hit more than once

  =========================[ password length ]=========================

  Average

        6.22    Characters

  Breakdown

        Chars   Pwds    Percentage

        0       2       22.2222%
        5       1       11.1111%
        6       1       11.1111%
        8       3       33.3333%
        9       1       11.1111%
        12      1       11.1111%

  ===============================[ fin ]===============================

```

