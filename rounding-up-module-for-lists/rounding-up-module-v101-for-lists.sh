#!/bin/bash
#Rounds lists of numbers up to the nearest (multiple of) specified decimal(s).
#
#github.com/bveldhuyzen
#2021
#
#
#To be configured before use is marked with ###
#
#The script works as followed:
#
#1. The numerical value (number from list) that is to be rounded up becomes a variable; this is called the FULL_NUMBER // see line 27
#2. The numerical value (decimal(s)) to which [1] has to be rounded up to is obtained; the module will round up to the nearest (multiple of) specified decimal(s) // see line 33-34
#3. Of the numerical value [1] is obtained its integer, for which a new variable is created
#4. Of the numerical value [1] are obtained the decimals, for which a new variable is created
#5. A multiplication factor is generated; how many times does [2] fit into [4].
#6. In case the multiplication factor is not a whole number, the multiplication factor will be its integer + 1
#7. The numerical value to round up to at [2] is multiplied by the multiplication factor of [5], resulting in a new (decimal) numerical value that is rounded up to [2]
#8. And so we can add up: INTEGER + NEW_DECIMALS = ROUNDED_NUMBER
#9. ROUNDED_NUMBER is then logged into a text file
#
#All steps/significances are logged into temporary text files for validation purposes


#!/bin/bash

FULL_NUMBER=$(<full_number_1.txt)

echo "0.75" > round_to_this.txt
ROUND_TO_THIS=$(<round_to_this.txt)

calc -d "$FULL_NUMBER / $ROUND_TO_THIS" > MPF.txt
MPF=$(<MPF.txt)

echo $MPF | awk '{print int($0)}' > MPF_total.txt
MPF_TOTAL=$(<MPF_total.txt)

calc -d "$MPF - $MPF_TOTAL" > steps_leftover_decimals.txt
STEPS_LEFTOVER_DECIMALS=$(<steps_leftover_decimals.txt)

awk '$1>0 {$1=1} 1' steps_leftover_decimals.txt > steps_leftover_decimals_1.txt
STEPS_LEFTOVER_DECIMALS_1=$(<steps_leftover_decimals_1.txt)

if [[ $STEPS_LEFTOVER_DECIMALS_1 -eq 1 ]]
then
calc -d "$MPF_TOTAL + 1" > MPF_done.txt
else
head -1 MPF_total.txt > MPF_done.txt
fi

MULTIPLICATION_FACTOR_TOTAL_DONE=$(<MPF_done.txt)

calc -d "$MULTIPLICATION_FACTOR_TOTAL_DONE * $ROUND_TO_THIS" > rounded_up_number.txt
ROUNDED_UP_NUMBER=$(<rounded_up_number.txt)

bash -c "[ -d LIST_DATE_TEST_2.txt ] && rm LIST_DATE_TEST_2.txt"
touch LIST_DATE_TEST_2.txt
echo "$ROUNDED_UP_NUMBER" >> LIST_DATE_TEST_2.txt

rm full_number_1.txt round_to_this.txt MPF.txt MPF_total.txt MPF_done.txt steps_leftover_decimals.txt steps_leftover_decimals_1.txt rounded_up_number.txt

#V
