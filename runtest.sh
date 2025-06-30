#!/bin/bash
#declare -a optimizerValues=("adam", "sgdm", "rmsprop");
#declare -a learnRateValues=("0.001", "0.0005", "0.00001");
#declare -a dropFactorValues=("0.1", "0.2", "0.3");
#declare -a dropPeriodValues=("1", "5", "10");
#declare -a epochValues=("1", "50", "100", "250");
#declare -a minibatchValues=("4", "6", "8", "10");
#declare -a encoderDepthValues=("2", "3", "4");
#declare -a momentumValues=("0.5", "0.7", "0.9");
#testArray=(optimizerValues, learnRateValues, dropFactorValues, dropPeriodValues, epochValues,
#	   minibatchValues, encoderDepthValues, momentumValues);
testValues=("2" "3");
for item in "${testValues[@]}"; do
	/usr/bin/matlab -nodesktop -nosplash -r "unetTest(Optimizer="adam", LearnRate=0.001, LearnDropFactor=0.2, LearnDropPeriod=5, MaxEpochs=1, BatchSize=4, EncoderDepth=$item, Momentum=0.9); exit;"
done

