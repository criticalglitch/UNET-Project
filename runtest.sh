#!/bin/bash
#declare -a optimizerValues=("adam" "sgdm" "rmsprop");
#declare -a learnRateValues=("0.001" "0.0005" "0.00001");
#declare -a epochValues=("1" "50" "100" "250");
#declare -a minibatchValues=("4" "6" "8" "10");
#declare -a learnSchedValues=("piecewise", "exponential");
#declare -a dropFactorValues=("0.1" "0.2" "0.3");
#declare -a dropPeriodValues=("1" "5" "10");
#declare -a momentumValues=("0.5" "0.7" "0.9");
#declare -a encoderDepthValues=("2" "3" "4");
#declare -a numFiltersValues=("32" "64" "128");
#declare -a filterSizeValues=("3" "4" "5");
#testArray=(optimizerValues learnRateValues dropFactorValues dropPeriodValues epochValues
#	   minibatchValues momentumValues encoderDepthValues numFiltersValues filterSizeValues);
testValues=("5" "10" "20");
#optimizer="adam";
#scheduler="piecewise";
LOG_FILE="logfile.log";

# Redirect all stdout and stderr to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# ls -l /nonexistent_directory # This error will also be logged
for item in "${testValues[@]}"; do
	echo "Appending run with value $item to logfile."
	/usr/bin/matlab -nodesktop -nosplash -r "unetTest(LearnRate=0.001, MaxEpochs=$item, BatchSize=4, LearnDropFactor=0.2, LearnDropPeriod=5, Momentum=0.9, EncoderDepth=4, NumFirstEncoderFilters=64, FilterSize=3); exit;"
done