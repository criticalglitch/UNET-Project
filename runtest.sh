#!/bin/bash
declare -a testValues;
testValues=("0.001" "0.0005" "0.0001" "0.00005" "0.00001");
for item in "${testValues[@]}"; do
	/usr/bin/matlab -nodesktop -nosplash -r "unetTest(LearnRate=$item); exit;"
done

