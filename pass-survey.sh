#!/bin/bash
# pass-survery.sh (v2.0)
# v1.1 - 10/24/2015 by Ted R (http://github.com/actuated)
# v2.0 - 11/05/2017
# Script to analyze a list of passwords, one per line
# Overhaul to replace slow while-loop dictionary checks with a faster grep for repeated four+ letter bases
# 11/05/2017 - Changed password length to all instead of top x, removed sorting but left lines commented out for sorting password length breakdown, character type checks by count
# 11/08/2017 - Added --bases option to specify a password base dictionary to check against, instead of the default letters. Top passwords and password bases shouldn't include single results now.
varDateCreated="10/24/2015"
varDateLastMod="11/08/2017"

varInFile="N"
varTopX="10"
varBaseMode="Letters"
varBaseFile="N"

echo
echo "====================[ pass-survey.sh - Ted R (github: actuated) ]===================="

# Check to make sure the input file exists
if [ -f "$1" ]; then
  varInFile="$1"
  shift
else
  echo
  echo "Error: Input file containing passwords must be the first parameter."
  echo
  echo "=======================================[ fin ]======================================="
  echo
  exit
fi

# Read options
while [ "$1" != "" ]; do
  case "$1" in
    # Specify a non-default value for the top x passwords/bases/password lengths
    --top )
      shift
      varTopX=$(echo "$1" | grep -o [[:digit:]]*)
      if [ "$varTopX" = "" ] || [ "$varTopX" -lt "1" ]; then
        echo
        echo "Error: --top must specify a number of 1 or greater."
        echo
        echo "=======================================[ fin ]======================================="
        echo
        exit
      fi
      ;;
    --bases )
      shift
      varBaseFile="$1"
      if [ ! -f "$varBaseFile" ]; then
        echo
        echo "Error: --bases must be used to specify a file that exists."
        echo
        echo "=======================================[ fin ]======================================="
        echo
        exit
      else
        varBaseMode="File"
      fi
      ;;
     # Help/usage information
     * )
       echo
       echo "======================================[ about ]======================================"
       echo
       echo "Analyze a list of passwords (one per line) to get the top passwords, top password"
       echo "bases (four or more letters), and breakdowns for character types and passwod length."
       echo
       echo "Created $varDateCreated, last modified $varDateLastMod."
       echo
       echo "======================================[ usage ]======================================"
       echo
       echo "./pass-survey.sh [input file] [--top [number]] [--bases [file]]"
       echo
       echo "[input file]           Specify an input file containing passwords on each line."
       echo
       echo "--top [number]         Optionally specify the number of top passwords & top password"
       echo "                       bases. Default is 10."
       echo
       echo "--bases [file]         Optionally specify a dictionary of password bases to check. By"
       echo "                       default, the script greps for letters, converts to lowercase,"
       echo "                       removes strings shorter than four characters, and checks for"
       echo "                       reuse. With this option, specify your own list that the script"
       echo "                       will use to do a case-insensitive grep of the input file, and"
       echo "                       check for how often four+ letter strings are reused."
       echo
       echo "                       A list containing lower-case words, names, sports teams, and"
       echo "                       other common password bases is included as bases.txt."
       echo
       echo "=======================================[ fin ]======================================="
       echo
       exit
  esac
  shift
done

# Get total counts
varTotal=$(wc -l < "$varInFile")
echo
printf "%-32s%-s\n" "Input File:" "$varInFile"
printf "%-32s%-s\n" "Total Passwords:" "$varTotal"

echo
echo "======================================[ reuse ]======================================"

# Get total unique passwords
varCountUniq=$(sort "$varInFile" | uniq | wc -l)
echo
printf "%-32s%-10s\n" "Unique Passwords:" "$varCountUniq"

# Top X passwords
echo
echo "Top $varTopX Passwords:"
echo
sort "$varInFile" | uniq -cd | sort -nr | head -n "$varTopX" | awk '{printf("%-32s%-10s\n", $2, $1)}'

# Top X password bases
echo
if [ "$varBaseMode" = "Letters" ]; then 
  echo "Top $varTopX Password Bases (4+ Letters):"
  echo
  grep -o '[[:alpha:]]*' "$varInFile" | grep .... | tr 'A-Z' 'a-z' | sort | uniq -cd | sort -nr | head -n "$varTopX" | awk '{printf("%-32s%-10s\n", $2, $1)}'
elif [ "$varBaseMode" = "File" ]; then 
  echo "Top $varTopX Password Bases ($varBaseFile):"
  echo
  grep -io -F -f "$varBaseFile" "$varInFile" | grep .... | tr 'A-Z' 'a-z' | sort | uniq -cd | sort -nr | head -n "$varTopX" | awk '{printf("%-32s%-10s\n", $2, $1)}'
fi

echo
echo "=================================[ password length ]================================="

# Get average length
varAverageLength=$(awk '{ cnt += length($0) } END { print cnt / NR }' "$varInFile" | cut -c1-4)
echo
printf "%-32s%-s\n" "Average Length:" "$varAverageLength"

echo
#echo "Top $varTopX Password Lengths:"
echo "Password Length Breakdown:"
echo
#awk '{++a[length()]} END{for (i in a) print i " Characters" "\t\t\t_" a[i] "_\t" a[i]*100/'$varTotal'"%"}' "$varInFile" | sort -t_ -k2 -nr  | tr -d '_' | head -n "$varTopX"
awk '{++a[length()]} END{for (i in a) print i " Characters" "\t\t\t" a[i] "\t" a[i]*100/'$varTotal'"%"}' "$varInFile"

echo
echo "=================================[ character types ]================================="

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

# Display Character Type Summary
echo
echo "Character Type Summary:"
echo
function fnCharacterSummary {
  printf "%-33s%-8s%-8s\n" "Blank Passwords_" "$varBlank" "_$varBlankPercent"
  printf "%-33s%-8s%-8s\n" "Only One Character Type_" "$varSingleTotal" "_$varSinglePercent"
  printf "%-33s%-8s%-8s\n" "Only Two Character Types_" "$varDoubleTotal" "_$varDoublePercent"
  printf "%-33s%-8s%-8s\n" "Only Three Chracter Types_" "$varTripleTotal" "_$varTriplePercent"
  printf "%-33s%-8s%-8s\n" "All Four Character Types_" "$varQuadTotal" "_$varQuadPercent"
}
#fnCharacterSummary | sort -t_ -k2 -nr | tr -d '_'
fnCharacterSummary |  tr -d '_'

# Display Character Type Breakdown
echo
echo "Character Type Breakdown:"
echo
function fnCharacterBreakdown {
  if [ $varBlank != 0 ]; then printf "%-33s%-8s\n" "Blank Passwords_" "$varBlank"; fi
  if [ $varLowerOnly != 0 ]; then printf "%-33s%-8s\n" "abc_" "$varLowerOnly"; fi
  if [ $varUpperOnly != 0 ]; then printf "%-33s%-8s\n" "ABC_" "$varUpperOnly"; fi
  if [ $varDigitOnly != 0 ]; then printf "%-33s%-8s\n" "123_" "$varDigitOnly"; fi
  if [ $varLettersOnly != 0 ]; then printf "%-33s%-8s\n" "abc + ABC_" "$varLettersOnly"; fi
  if [ $varLowerDigitOnly != 0 ]; then printf "%-33s%-8s\n" "abc + 123_" "$varLowerDigitOnly"; fi
  if [ $varUpperDigitOnly != 0 ]; then printf "%-33s%-8s\n" "ABC + 123_" "$varUpperDigitOnly"; fi
  if [ $varDigitSpecOnly != 0 ]; then printf "%-33s%-8s\n" "123 + !@#_" "$varDigitSpecOnly"; fi
  if [ $varLowerSpecOnly != 0 ]; then printf "%-33s%-8s\n" "abc + !@#_" "$varLowerSpecOnly"; fi
  if [ $varUpperSpecOnly != 0 ]; then printf "%-33s%-8s\n" "ABC + !@#_" "$varUpperSpecOnly"; fi
  if [ $varNoSpec != 0 ]; then printf "%-33s%-8s\n" "abc + ABC + 123_" "$varNoSpec"; fi
  if [ $varNoDigit != 0 ]; then printf "%-33s%-8s\n" "abc + ABC + !@#_" "$varNoDigit"; fi
  if [ $varNoUpper != 0 ]; then printf "%-33s%-8s\n" "abc + 123 + !@#_" "$varNoUpper"; fi
  if [ $varNoLower != 0 ]; then printf "%-33s%-8s\n" "ABC + 123 + !@#_" "$varNoLower"; fi
  if [ $varQuadTotal != 0 ]; then printf "%-33s%-8s\n" "abc + ABC + 123 + !@#_" "$varQuadTotal"; fi
}
#fnCharacterBreakdown | sort -t_ -k2 -nr | tr -d '_'
fnCharacterBreakdown | tr -d '_'

echo
echo "Legend:"
echo
echo -e "abc - Lowercase\t\t\tABC - Uppercase\t"
echo -e "123 - Numbers\t\t\t!@# - Special Characters"

echo
echo "=======================================[ fin ]======================================="
echo
