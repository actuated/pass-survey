# pass-survey
Have a list of passwords you cracked during a pentest or password audit? This shell script will give you analysis of reused passwords, reused password bases (4+ letter combinations), password length, and character type breakdown.

# Usage
`pass-survey.sh` only requires an input file. Each line of the input file will be treated as a password.

`./pass-survey.sh [input file] [--top [number]]`

  - **[input file]** must be the first parameter.
  - **--top** optionally lets you specify the number of most common password, bases, and password lengths to list by specifying a **[number]**. By default, the top 10 are shown.
