#!bin/bash
#Rounds any number up to the nearest (multiple of) specified decimal(s).
#v1.01
#github.com/bveldhuyzen
#2021
#
#
#To be configured before use is marked with ###
#
#Furthermore, the script works as followed:
#
#1. The numerical value (any number) that is to be rounded up is obtained; this is called the FULL_NUMBER // see line 28-29
#2. The numerical value (decimal(s)) to which [1] has to be rounded up to is obtained; the module will round up to the nearest (multiple of) specified decimal(s) // see line 35-36
#3. Of the numerical value [1] is obtained its integer, for which a new variable is created
#4. Of the numerical value [1] are obtained the decimals, for which a new variable is created
#5. A multiplication factor is generated; how many times does [2] fit into [4].
#6. In case the multiplication factor is not a whole number, the multiplication factor will be its integer + 1
#7. The numerical value to round up to at [2] is multiplied by the multiplication factor of [5], resulting in a new (decimal) numerical value that is rounded up to [2]
#8. And so we can add up: INTEGER + NEW_DECIMALS = ROUNDED_NUMBER
#9. ROUNDED_NUMBER is then logged into a temporary text file and presented on screen via cat
#
#All steps/significances are logged into temporary text files for validation purposes


#[1]
###echo the number that has to be rounded up at line 28
#e.g. 10, 10.01, 10.10, 1050.11493759834, or whatever
echo "0.5687576465476" > full_number_1.txt
FULL_NUMBER=$(<full_number_1.txt)

#[2]
#echo the decimals at line 35 to which the module has to round up to
#e.g. 0.05 will make the module round up to the nearest (multiple of) 0.05.
#e.g. 1.899999 will then be rounded up to 1.90
echo "0.022" > round_to_this.txt
ROUND_TO_THIS=$(<round_to_this.txt)

#[3]
#rounding full number down to integer
echo $FULL_NUMBER | awk '{print int($0)}' > integer.txt
INTEGER=$(<integer.txt)

#[4]
#leftover decimals calculated by full number minus integer
calc -d "$FULL_NUMBER - $INTEGER" > leftover_decimals.txt
DECIMALS=$(<leftover_decimals.txt)

#[5]
#how many times to multiply ROUND_TO_THIS in order to reach the leftover decimals
calc -d "$DECIMALS / $ROUND_TO_THIS" > MULTIPLICATION_FACTOR.txt
MULTIPLICATION_FACTOR=$(<MULTIPLICATION_FACTOR.txt)

#[6]
echo $MULTIPLICATION_FACTOR | awk '{print int($0)}' > MULTIPLICATION_FACTOR_total.txt
MULTIPLICATION_FACTOR_TOTAL=$(<MULTIPLICATION_FACTOR_total.txt)

calc -d "$MULTIPLICATION_FACTOR - $MULTIPLICATION_FACTOR_TOTAL" > steps_leftover_decimals.txt
STEPS_LEFTOVER_DECIMALS=$(<steps_leftover_decimals.txt)

awk '$1>0 {$1=1} 1' steps_leftover_decimals.txt > steps_leftover_decimals_1.txt
STEPS_LEFTOVER_DECIMALS_1=$(<steps_leftover_decimals_1.txt)

if [[ $STEPS_LEFTOVER_DECIMALS_1 -eq 1 ]]
then
calc -d "$MULTIPLICATION_FACTOR_TOTAL + 1" > MULTIPLICATION_FACTOR_done.txt
else
head -1 MULTIPLICATION_FACTOR_total.txt > MULTIPLICATION_FACTOR_done.txt
fi

MULTIPLICATION_FACTOR_TOTAL_DONE=$(<MULTIPLICATION_FACTOR_done.txt)

#[7]
#rounding of some sort
calc -d "$MULTIPLICATION_FACTOR_TOTAL_DONE * $ROUND_TO_THIS" > new_decimals.txt
NEW_DECIMALS=$(<new_decimals.txt)

#[8]
#new rounded number is stored into text file and presented on screen via cat
calc -d "$INTEGER + $NEW_DECIMALS" > rounded_number.txt
cat rounded_number.txt
ROUNDED_NUMBER=$(<rounded_number.txt)


#[9]
#you may for example store the rounded number in a file of choice to create a list, e.g.
#
#touch LIST_DATE_TEST_2.txt
#echo "$ROUNDED_NUMBER" >> LIST_DATE_TEST_2.txt
#

rm full_number_1.txt round_to_this.txt integer.txt leftover_decimals.txt MULTIPLICATION_FACTOR.txt MULTIPLICATION_FACTOR_total.txt new_decimals.txt  steps_leftover_decimals_1.txt steps_leftover_decimals.txt MULTIPLICATION_FACTOR_done.txt rounded_number.txt


#V
