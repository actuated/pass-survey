# pass-survey
Have a list of passwords you cracked during a pentest or password audit? This shell script will give you statistical information about different character type combinations and password lengths.

# Usage
`pass-survey.sh` only requires an input file. Each line of the input file will be treated as a password.

**-o** allows you to specify an output file.

`./pass-survey.sh [inputfilename] [-o outputfilename]`

# Example
```
# ./pass-survey.sh input.txt 

  Press Enter to review input.txt (2289 lines)...

  ============[ pass-survey.sh - Ted R (github: actuated) ]============

  File        input.txt
  Passwords 	2289

  =========================[ Character Types ]=========================

  Totals

	    0       Blank Passwords               0%
	    1559    Only One Character Type       68.1%
	    722     Only Two Character Types      31.5%
	    8       Only Three Chracter Types     0.34%
	    0       All Four Character Types      0%

  Breakdown

	    Pwds    Character Types (See Help for Legend)

	    1501    abc
	    4       ABC
	    47    	123
	    7      	!@#
	    614    	abc + ABC
	    101   	abc + 123
	    3     	ABC + 123
	    4     	abc + !@#
	    8     	abc + ABC + 123

  =========================[ Password Length ]=========================

  Average

	    6.03    Characters

  Breakdown

	   Chars    Pwds    Percentage

	   1        5       0.218436%
	   2        2       0.0873744%
	   3        55      2.4028%
	   4        159     6.94626%
	   5        366     15.9895%
	   6        973     42.5076%
	   7        499     21.7999%
	   8        230     10.0481%

  ===============================[ fin ]===============================
```

