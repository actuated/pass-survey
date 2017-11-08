# pass-survey
Have a list of passwords you cracked during a pentest or password audit? This shell script will give you analysis of reused passwords, reused password bases (4+ letter combinations), password length, and character type breakdown.

# Usage
`pass-survey.sh` only requires an input file. Each line of the input file will be treated as a password.

`./pass-survey.sh [input file] [--top [number]] [--bases [file]]`

  - **[input file]** must be the first parameter.
  - **--top** optionally lets you specify the number of most common password and bases to list by specifying a **[number]**. By default, the top 10 are shown.
  - **--bases** optionally lets you specify a file containing password bases to check for.
    - By default, the script greps letters out of each line, looks for strings at least four characters long, converts them to lowercase, and checks for reuse.
    - This option will do a case-insensitive file-to-file grep to look for your bases in the password file, convert those results to lowercase, and look for reuse of four+ character strings.
