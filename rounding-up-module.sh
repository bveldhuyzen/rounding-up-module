#!bin/bash
#Rounding down script, free for use
#bveldhuyzen [at] gmail dot com
#2021

#This script rounds numbers up to any decimal ceilig you want

#echo the number that has to be rounded down here
#e.g. 10, 10.01, 10.10, 1050.11493759834, or whatever
echo "0.5687576465476" > full_number_1.txt
FULL_NUMBER=$(<full_number_1.txt)

#echo the decimals to which the module has to round down to
echo "0.020" > round_to_this.txt
ROUND_TO_THIS=$(<round_to_this.txt)

#rounding down to integer
echo $FULL_NUMBER | awk '{print int($0)}' > integer.txt
INTEGER=$(<integer.txt)

#leftover decimals
calc -d "$FULL_NUMBER - $INTEGER" > leftover_decimals.txt
DECIMALS=$(<leftover_decimals.txt)

#steps to take into integer
calc -d "$DECIMALS / $ROUND_TO_THIS" > steps_into_integer.txt
STEPS_INTO_INTEGER=$(<steps_into_integer.txt)

echo $STEPS_INTO_INTEGER | awk '{print int($0)}' > steps_into_integer_total.txt
STEPS_INTO_INTEGER_TOTAL=$(<steps_into_integer_total.txt)

calc -d "$STEPS_INTO_INTEGER - $STEPS_INTO_INTEGER_TOTAL" > steps_leftover_decimals.txt
STEPS_LEFTOVER_DECIMALS=$(<steps_leftover_decimals.txt)

awk '$1>0 {$1=1} 1' steps_leftover_decimals.txt > steps_leftover_decimals_1.txt
STEPS_LEFTOVER_DECIMALS_1=$(<steps_leftover_decimals_1.txt)

if [[ $STEPS_LEFTOVER_DECIMALS_1 -eq 1 ]]
then
calc -d "$STEPS_INTO_INTEGER_TOTAL + 1" > steps_into_integer_done.txt
else
head -1 steps_into_integer_total.txt > steps_into_integer_done.txt
fi

STEPS_INTO_INTEGER_TOTAL_DONE=$(<steps_into_integer_done.txt)
#echo "steps to take into integer = $STEPS_INTO_INTEGER_TOTAL_DONE"

#rounding of some sort
calc -d "$STEPS_INTO_INTEGER_TOTAL_DONE * $ROUND_TO_THIS" > new_decimals.txt
NEW_DECIMALS=$(<new_decimals.txt)

#new rounded number
calc -d "$INTEGER + $NEW_DECIMALS" > rounded_number.txt
cat rounded_number.txt

read -p 'pause'

rm full_number_1.txt round_to_this.txt integer.txt leftover_decimals.txt steps_into_integer.txt steps_into_integer_total.txt new_decimals.txt rounded_number.txt steps_leftover_decimals_1.txt steps_leftover_decimals.txt steps_into_integer_done.txt
