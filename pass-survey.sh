#!/bin/bash
# pass-survey.sh
# 10/24/2015 by tedr@tracesecurity.com
# Script for statistical information about password audit results.
# Meant to be used with an input file containing passwords only, one per line.
# 10/26/2015 - Added code to truncate total percentages and average length.
# 10/27/2015 - Reorganized output and coded totals/breakdowns to only show if not 0.
# 10/29/2015 - Recreated script with options and usage information.
# 10/31/2015 - Cosmetic changes, and changed input file to -i for consistency with other scripts.
# 12/28/2015 - Removed -i for input, input file must be first parameter.

varDateCreated="10/24/2015"
varDateLastMod="12/28/2015"
varOutFile=
varInFile=

function usage
{
  echo
  echo "  =============[ pass-survey.sh - tedr@tracesecurity.com ]============="
  echo
  echo "  Created $varDateCreated - Last Modified $varDateLastMod"
  echo
  echo -e "  This script provides statistical information for passwords."
  echo -e "  Each line of the input file will be reviewed as a password."
  echo -e "  Passwords will be reviewed for character types and length."
  echo
  echo "  ==============================[ usage ]=============================="
  echo
  echo -e "\t./pass-survey.sh -[input file] [-o [output file]]"
  echo
  echo -e "\t[input file] \tRequired input file for review"
  echo -e "\t\t\t\tEach line will be treated as a password"
  echo
  echo -e "\t-o [output file] \tOptional output file"
  echo
  echo -e "\t-h \t\t\tDisplays this usage/about information"
  echo
  echo "  ==============================[ about ]=============================="
  echo
  echo -e "  Character Type Legend"
  echo
  echo -e "\tabc = Lower Case Letters \t123 = Numbers"
  echo -e "\tABC = Upper Case Letters \t!@# = Symbols and Spaces"
  echo
  echo "  =[(c) 2015, free for personal and commercial use with credit intact]="
  echo
  exit
}

function pass_survey
{
# Individual Counts
  varLowerOnly="$(grep '[[:lower:]]' $varInFile | grep -v '[[:upper:][:digit:][:punct:][:space:]]' | wc -l)"
  varUpperOnly="$(grep '[[:upper:]]' $varInFile | grep -v '[[:lower:][:digit:][:punct:][:space:]]' | wc -l)"
  varDigitOnly="$(grep '[[:digit:]]' $varInFile | grep -v '[[:upper:][:lower:][:punct:][:space:]]' | wc -l)"
  varSpecOnly="$(grep '[[:punct:][:space:]]' $varInFile | grep -v '[[:upper:][:lower:][:digit:]]' | wc -l)"
  varLettersOnly="$(grep '[[:lower:]]' $varInFile | grep '[[:upper:]]' | grep -v '[[:digit:][:punct:][:space:]]' | wc -l)"
  varLowerDigitOnly="$(grep '[[:lower:]]' $varInFile | grep '[[:digit:]]' | grep -v '[[:upper:][:punct:][:space:]]' | wc -l)"
  varUpperDigitOnly="$(grep '[[:upper:]]' $varInFile | grep '[[:digit:]]' | grep -v '[[:lower:][:punct:][:space:]]' | wc -l)"
  varDigitSpecOnly="$(grep '[[:digit:]]' $varInFile | grep '[[:punct:][:space:]]' | grep -v '[[:lower:][:upper:]]' | wc -l)"
  varLowerSpecOnly="$(grep '[[:lower:]]' $varInFile | grep '[[:punct:][:space:]]' | grep -v '[[:upper:][:digit:]]' | wc -l)"
  varUpperSpecOnly="$(grep '[[:upper:]]' $varInFile | grep '[[:punct:][:space:]]' | grep -v '[[:lower:][:digit:]]' | wc -l)"
  varNoSpec="$(grep '[[:upper:]]' $varInFile | grep '[[:lower:]]' | grep '[[:digit:]]' | grep -v '[[:punct:][:space:]]' | wc -l)"
  varNoDigit="$(grep '[[:upper:]]' $varInFile | grep '[[:lower:]]' | grep '[[:punct:][:space:]]' | grep -v '[[:digit:]]' | wc -l)"
  varNoUpper="$(grep '[[:lower:]]' $varInFile | grep '[[:digit:]]' | grep '[[:punct:][:space:]]' | grep -v '[[:upper:]]' | wc -l)"
  varNoLower="$(grep '[[:upper:]]' $varInFile | grep '[[:digit:]]' | grep '[[:punct:][:space:]]' | grep -v '[[:lower:]]' | wc -l)"

  # Totals
  varSingleTotal=$(($varLowerOnly + $varUpperOnly + $varDigitOnly + $varSpecOnly))
  varDoubleTotal=$(($varLettersOnly + $varLowerDigitOnly + $varUpperDigitOnly + $varDigitSpecOnly + $varLowerSpecOnly + $varUpperSpecOnly))
  varTripleTotal=$(($varNoSpec + $varNoDigit + $varNoUpper + $varNoLower))
  varQuadTotal="$(grep '[[:upper:]]' $varInFile | grep '[[:lower:]]' | grep '[[:digit:]]' | grep '[[:punct:][:space:]]' | wc -l)"
  varBlank="$(grep '^$' $varInFile | wc -l)"
  varTotal="$(wc -l < $varInFile)"

  # Percentages
  varBlankPercent=$(awk "BEGIN {print $varBlank*100/$varTotal}" | cut -c1-4)%
  varSinglePercent=$(awk "BEGIN {print $varSingleTotal*100/$varTotal}" | cut -c1-4)%
  varDoublePercent=$(awk "BEGIN {print $varDoubleTotal*100/$varTotal}" | cut -c1-4)%
  varTriplePercent=$(awk "BEGIN {print $varTripleTotal*100/$varTotal}" | cut -c1-4)%
  varQuadPercent=$(awk "BEGIN {print $varQuadTotal*100/$varTotal}" | cut -c1-4)%

  read -p "  Press Enter to review $varInFile ($varTotal lines)..."
  echo 
  echo "  =============[ pass-survey.sh - tedr@tracesecurity.com ]============="
  echo
  echo -e "  File \t\t$varInFile"
  echo -e "  Passwords \t$varTotal"
  echo

  echo "  =========================[ Character Types ]========================="
  echo

  echo "  Totals"
  echo
  echo -e "\t$varBlank \tBlank Passwords \t\t$varBlankPercent"
  echo -e "\t$varSingleTotal \tOnly One Character Type \t$varSinglePercent"
  echo -e "\t$varDoubleTotal \tOnly Two Character Types \t$varDoublePercent"
  echo -e "\t$varTripleTotal \tOnly Three Chracter Types \t$varTriplePercent"
  echo -e "\t$varQuadTotal \tAll Four Character Types \t$varQuadPercent"
  echo

  echo "  Breakdown"
  echo
  echo -e "\tPwds\tCharacter Types (See Help for Legend)"
  echo
  if [ $varBlank != 0 ]; then echo -e "\t$varBlank \t[Blank]"; fi
  if [ $varLowerOnly != 0 ]; then echo -e "\t$varLowerOnly \tabc"; fi
  if [ $varUpperOnly != 0 ]; then echo -e "\t$varUpperOnly \tABC"; fi
  if [ $varDigitOnly != 0 ]; then echo -e "\t$varDigitOnly \t123"; fi
  if [ $varSpecOnly != 0 ]; then echo -e "\t$varSpecOnly \t!@#"; fi
  if [ $varLettersOnly != 0 ]; then echo -e "\t$varLettersOnly \tabc + ABC"; fi
  if [ $varLowerDigitOnly != 0 ]; then  echo -e "\t$varLowerDigitOnly \tabc + 123"; fi
  if [ $varUpperDigitOnly != 0 ]; then echo -e "\t$varUpperDigitOnly \tABC + 123"; fi
  if [ $varDigitSpecOnly != 0 ]; then echo -e "\t$varDigitSpecOnly \t123 + !@#"; fi
  if [ $varLowerSpecOnly != 0 ]; then echo -e "\t$varLowerSpecOnly \tabc + !@#"; fi
  if [ $varUpperSpecOnly != 0 ]; then echo -e "\t$varUpperSpecOnly \tABC + !@#"; fi
  if [ $varNoSpec != 0 ]; then echo -e "\t$varNoSpec \tabc + ABC + 123"; fi
  if [ $varNoDigit != 0 ]; then echo -e "\t$varNoDigit \tabc + ABC + !@#"; fi
  if [ $varNoUpper != 0 ]; then echo -e "\t$varNoUpper \tabc + 123 + !@#"; fi
  if [ $varNoLower != 0 ]; then echo -e "\t$varNoLower \tABC + 123 + !@#"; fi
  if [ $varQuadTotal != 0 ]; then echo -e "\t$varQuadTotal \tabc + ABC + 123 + !@#"; fi
  echo 

  echo "  =========================[ Password Length ]========================="
  echo
  echo "  Average"
  echo
  echo -e "\t$(awk '{ cnt += length($0) } END { print cnt / NR }' $varInFile | cut -c1-4) \tCharacters"
  echo
  echo "  Breakdown"
  echo
  echo -e "\tChars\tPwds\tPercentage"
  echo
  awk '{++a[length()]} END{for (i in a) print "\t"i"\t"a[i],"\t"a[i]*100/'$varTotal'"%"}' $varInFile | sort -g
  echo
  echo "  ===============================[ fin ]==============================="
  echo
}

# Check for input file as first parameter, error if it doesn't exist as a file
varInFile="$1"
if [ ! -f "$varInFile" ]; then echo; echo "Error: Input file doesn't exist."; usage; exit; fi

while [ "$1" != "" ]; do
  case $1 in
    -o ) shift
         varOutFile=$1
         if [ "$varOutFile" = "" ]; then varOutFile="throwerror"; fi # Flag for error if no file name was given
         ;;
    -h ) usage
         exit
  esac
  shift
done

if [ "$varInFile" != "" ]; then # Make sure input file was given or error
  if [ -f $varInFile ]; then # Make sure input file exists or error
    if [ "$varOutFile" != "" ]; then # See if output file was given
      if [ "$varOutFile" = "throwerror" ]; then # If output option was used without file name given, error
        echo
        echo "  Error: -o option used without output filename."
        usage
      fi
      if [ -f $varOutFile ]; then # If an existing output file was listed, warn
        echo
        echo "  Warning: $varOutFile exists."
        read -p "  Press Enter to continue and overwrite..."
      fi

      # Run pass_survey function with output
      echo
      pass_survey | tee $varOutFile
    else
      echo # Run pass_survey function without output
      pass_survey
    fi
  else # Error on input file that doesn't exist
    echo
    echo -e "  Error: Input file doesn't exist."
    usage
  fi
else # Error on failure to provide input file
  echo
  echo -e "  Error: Input file was not specified."
  usage
fi

