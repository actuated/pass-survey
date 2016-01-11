#!/bin/bash
# pass-survey.sh
# 10/24/2015 by Ted R (http://github.com/actuated)
# Script for statistical information about password audit results.
# Meant to be used with an input file containing passwords only, one per line.

# Dictionary Word lists are based on Princeton WordNet indexes.
# Index files were parsed to remove any line with digits, ".", "'", "-", "_", or less than 4 characters.
# Anything after the first 8 characters was cut.
# Required citations for WordNet license agreement:
#
## George A. Miller (1995). WordNet: A Lexical Database for English.
## Communications of the ACM Vol. 38, No. 11: 39-41.
##
## Christiane Fellbaum (1998, ed.) WordNet: An Electronic Lexical Database. Cambridge, MA: MIT Press.
##

# 10/26/2015 - Added code to truncate total percentages and average length.
# 10/27/2015 - Reorganized output and coded totals/breakdowns to only show if not 0.
# 10/29/2015 - Recreated script with options and usage information.
# 10/31/2015 - Cosmetic changes, and changed input file to -i for consistency with other scripts.
# 12/28/2015 - Removed -i for input, input file must be first parameter.
# 1/1/2016 - Aesthetic change.
# 1/10/2016 - Added dictionary checks and related options.

varDateCreated="10/24/2015"
varDateLastMod="1/10/2016"
varOutFile=
varInFile=
varDoDict="Y"
varVerbose="N"
varCustomDict="dictionaries/custom.txt"
varCustomOnly="N"
varTempRandom=$(( ( RANDOM % 9999 ) + 1 ))
varTempFile="temp-psurvey-$varTempRandom.txt"
if [ -f "$varTempFile" ]; then rm $varTempFile; fi

function usage
{
  echo
  echo "  ============[ pass-survey.sh - Ted R (github: actuated) ]============"
  echo
  echo -e "  This script provides statistical information for passwords."
  echo -e "  Each line of the input file will be reviewed as a password."
  echo -e "  Passwords will be reviewed for character types and length."
  echo
  echo "  Created $varDateCreated - Last Modified $varDateLastMod"
  echo
  echo "  ==============================[ usage ]=============================="
  echo
  echo -e "  ./pass-survey.sh [input file] [options]"
  echo
  echo -e "  [input file]      Required input file for review"
  echo -e "                    Each line will be treated as a password"
  echo
  echo -e "  -o [output file]  Optional output file"
  echo
  echo -e "  --no-dict         Disable dictionary checks"
  echo
  echo -e "  --dict [file]     Set a different filename for the custom dict"
  echo -e "                    Default is dictionaries/custom.txt"
  echo
  echo -e "  --only-custom     Only check the custom dictionary"
  echo
  echo -e "  -v                Verbose: Retain non-zero dictionary checks"
  echo -e "                    Verbose output files contain 0 and non-0 checks"
  echo
  echo -e "  -h                Displays this usage/about information"
  echo
  echo "  ==============================[ about ]=============================="
  echo
  echo -e "  Character Type Legend"
  echo
  echo -e "\tabc = Lower Case Letters \t123 = Numbers"
  echo -e "\tABC = Upper Case Letters \t!@# = Symbols and Spaces"
  echo
  echo -e "  Dictionary Parsing"
  echo
  echo -e "    Benchmark time to run built-in dicts (w/ -v) was 10 min 52 s."
  echo -e "    Time should depend on dictionaries and hits, not input file."
  echo -e "    Script reads each line of each dict, grepping input file to hit."
  echo
  echo -e "    - Custom "
  echo -e "        Default is dictionaries/custom.txt"
  echo -e "        Modify for custom uses, like company names."
  echo -e "        Specify another file with --dict [filename]."
  echo -e "        Use --only-custom to disable other dictionary checks."
  echo -e "        Tip: These options can let you run a single built-in dict."
  echo -e "    - Months (12)"
  echo -e "    - Seasons (4)"
  echo -e "    - Sports Team Names (115)"
  echo -e "        Includes MLB, NBA, NFL, and NHL teams."
  echo -e "    - First Names (2500)"
  echo -e "        Based on US census data."
  echo -e "        Includes the 2500 most common names that were 3+ chars."
  echo -e "    - Last Names (2500)"
  echo -e "        Based on US census data."
  echo -e "        Includes the 2500 most common names that were 5+ chars."
  echo -e "    - Dictionary Words (61937)"
  echo -e "        Based on Princeton WordNet index files."
  echo -e "        Does not include words with special chars or spaces."
  echo -e "        Does not include words with less than 4 chars."
  echo -e "        Only includes the unique first 8 characters of words."
  echo -e "    - Years (200)"
  echo -e "        1900-2199"
  echo -e "    - Sequential/Repeating Characters (297)"
  echo -e "        Includes 3-9 char sequential and repeating numbers."
  echo -e "        Includes 3-8 char sequential and repeating letters."
  echo -e "        Includes 3-8 char keyboard rows, starting w/ Q, A, and Z."
  echo
  exit
}

function dict_check
{
  # Dictionary Checks

  varCustom=0
  varMonth=0
  varSeason=0
  varTeam=0
  varSequential=0
  varFirstName=0
  varLastName=0
  varDictWord=0
  varYear=0

  echo
  varTimeNow=$(date +%r)
  echo "  Dictionary Check: Started $varTimeNow"
  echo "  Note: See help/usage (-h) for options and information."

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      if [ "$varCustomOnly" = "N" ]; then echo -ne "  Dictionary Check: (1/9) $varCustomName : $varDictLine : $varCheckLine Hit(s)                       "\\r; fi
      if [ "$varCustomOnly" = "Y" ]; then echo -ne "  Dictionary Check: (1/1) $varCustomName : $varDictLine : $varCheckLine Hit(s)                       "\\r; fi
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varCustom=varCustom+varCheckLine
      fi
    done < "$varCustomDict"

    if [ "$varCustomOnly" = "N" ]; then
    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (2/9) Months : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varMonth=varMonth+varCheckLine
      fi
    done < dictionaries/months.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (3/9) Seasons : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varSeason=varSeason+varCheckLine
      fi
    done < dictionaries/seasons.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (4/9) Sports Teams : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varTeam=varTeam+varCheckLine
      fi
    done < dictionaries/teams.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (5/9) First Names : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varFirstName=varFirstName+varCheckLine
      fi
    done < dictionaries/firstnames.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (6/9) Last Names : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varLastName=varLastName+varCheckLine
      fi
    done < dictionaries/lastnames.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (7/9) Words : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varDictWord=varDictWord+varCheckLine
      fi
    done < dictionaries/words.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (8/9) Years : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varYear=varYear+varCheckLine
      fi
    done < dictionaries/years.txt

    varDictLine=""
    while read varDictLine; do
      varCheckLine="0"
      varCheckLine=$(grep -i "$varDictLine" "$varInFile" | wc -l | awk '{print $1}')
      echo -ne "  Dictionary Check: (9/9) Sequential/Repeating : $varDictLine : $varCheckLine Hit(s)                       "\\r
      if [ "$varCheckLine" != "0" ]; then
        if [ "$varVerbose" = "Y" ]; then echo; fi
        let varSequential=varSequential+varCheckLine
      fi
    done < dictionaries/sequential_repeating.txt
    fi

  varTimeNow=$(date +%r)
  echo -e "  Dictionary Check: Done $varTimeNow                                    "
}

function dict_show
{
  echo "  ========================[ dictionary checks ]========================"
  echo
  if [ "$varCheckCustom" != "0" ]; then echo -e "\t$varCustom \tHit(s): Custom ($varCustomName)"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varMonth \tHit(s): Months"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varSeason \tHit(s): Seasons"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varTeam \tHit(s): Sports Team Names"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varFirstName \tHit(s): First Names (US Census Top 2500, 3+ Chars)"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varLastName \tHit(s): Last Names (US Census Top 2500, 5+ Chars)"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varDictWord \tHit(s): Words (4 - 1st 8 Chars, WordNet Indexes)"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varYear \tHit(s): Years (1900-2199)"; fi
  if [ "$varCustomOnly" = "N" ]; then echo -e "\t$varSequential \tHit(s): Sequential or Repeating Chars (3+)"; fi
  echo
  echo "  Note: Passwords may hit more than once"
  echo
}

function pass_survey
{

  varTotal="$(wc -l < $varInFile)"

  echo 
  echo "  ============[ pass-survey.sh - Ted R (github: actuated) ]============"
  echo
  echo -e "  File \t\t$varInFile"
  echo -e "  Passwords \t$varTotal"
  echo
  if [ "$varDoDict" = "N" ]; then echo "  Dictionary Checks: Disabled"; fi
  if [ "$varDoDict" = "Y" ] && [ "$varCustomOnly" = "N" ] && [ "$varCheckCustom" != "0" ]; then echo "  Dictionary Checks: $varCustomName + Built-In"; fi
  if [ "$varDoDict" = "Y" ] && [ "$varCustomOnly" = "N" ] && [ "$varCheckCustom" = "0" ]; then echo "  Dictionary Checks: Built-In"; fi
  if [ "$varDoDict" = "Y" ] && [ "$varCustomOnly" = "Y" ]; then echo "  Dictionary Checks: $varCustomName"; fi
  echo
  read -p "  Press Enter to begin..."
  echo
  echo "  =============================[ parsing ]============================="

# Character Type Individual Counts
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

  # Character Type Totals
  varSingleTotal=$(($varLowerOnly + $varUpperOnly + $varDigitOnly + $varSpecOnly))
  varDoubleTotal=$(($varLettersOnly + $varLowerDigitOnly + $varUpperDigitOnly + $varDigitSpecOnly + $varLowerSpecOnly + $varUpperSpecOnly))
  varTripleTotal=$(($varNoSpec + $varNoDigit + $varNoUpper + $varNoLower))
  varQuadTotal="$(grep '[[:upper:]]' $varInFile | grep '[[:lower:]]' | grep '[[:digit:]]' | grep '[[:punct:][:space:]]' | wc -l)"
  varBlank="$(grep '^$' $varInFile | wc -l)"

  # Character Type Percentages
  varBlankPercent=$(awk "BEGIN {print $varBlank*100/$varTotal}" | cut -c1-4)%
  varSinglePercent=$(awk "BEGIN {print $varSingleTotal*100/$varTotal}" | cut -c1-4)%
  varDoublePercent=$(awk "BEGIN {print $varDoubleTotal*100/$varTotal}" | cut -c1-4)%
  varTriplePercent=$(awk "BEGIN {print $varTripleTotal*100/$varTotal}" | cut -c1-4)%
  varQuadPercent=$(awk "BEGIN {print $varQuadTotal*100/$varTotal}" | cut -c1-4)%

  if [ "$varDoDict" = "Y" ]; then dict_check; fi
  echo

  echo "  =========================[ character types ]========================="
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
  if [ "$varDoDict" = "Y" ]; then dict_show; fi
  echo "  =========================[ password length ]========================="
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
    --no-dict ) varDoDict="N"
         ;;
    --dict ) shift
         varCustomDict=$1
         if [ ! -f "$varCustomDict" ]; then echo; echo "  Error: Custom dictionary doesn't exist."; usage; fi
         ;;
    --only-custom ) varCustomOnly="Y"
         ;;
    -v ) varVerbose="Y"
         ;;
    -h ) usage
         exit
  esac
  shift
done

# Check custom dict, if --only-custom is used
varCheckCustom=$(wc -l "$varCustomDict" | awk '{print $1}')
if [ "$varCheckCustom" = "0" ] && [ "$varCustomOnly" = "Y" ]; then echo; echo "  Error: --only-custom was used, but $varCustomDict has 0 lines."; usage; fi
varCustomName=$(echo "$varCustomDict" | awk -F '/' '{print $NF}')

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
      pass_survey | tee "$varTempFile"
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

if [ "$varOutFile" != "" ] && [ "$varVerbose" = "N" ]; then
  cat "$varTempFile" | grep -v ' : ' > $varOutFile
  rm "$varTempFile"
fi

if [ "$varOutFile" != "" ] && [ "$varVerbose" = "Y" ]; then
  cat "$varTempFile" > $varOutFile
  rm "$varTempFile"
fi
