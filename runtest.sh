#!/bin/bash
export PATH=/usr/local/lib/:/usr/local/cuda-12.9/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export NVIDIA_CUDNN=/usr/local/cuda
export NVIDIA_TENSORRT=/usr/local/cuda/TensorRT

#declare -a optimizerValues=("adam" "sgdm" "rmsprop");
#declare -a learnRateValues=("0.001" "0.0005" "0.00001");
#declare -a epochValues=("1" "50" "100" "250");
#declare -a minibatchValues=("4" "6" "8" "10");
#declare -a learnSchedValues=("piecewise", "exponential");
#declare -a dropFactorValues=("0.1" "0.2" "0.3");
#declare -a dropPeriodValues=("1" "5" "10");
#declare -a momentumValues=("0.5" "0.7" "0.9"); % sgdm only
#declare -a encoderDepthValues=("2" "3" "4");
#declare -a numFiltersValues=("32" "64" "128");
#declare -a filterSizeValues=("3" "4" "5");
#declare -a gradientDecayValues=("0.5", "0.7", "0.9"); # adam only
#declare -a squaredGradientValues=("true", "false"); # adam only
#declare -a gradientThresholdValues=("0.1" "0.2" "0.3"); # adam only
#declare -a gradientThresholdMethodValues=("l2norm", "l1norm", "none"); # adam only
#declare -a epsilonValues=("1e-8", "1e-6", "1e-4"); # adam only
#declare -a l2Values=("0.0001", "0.001", "0.01"); # adam only
#testArray=(optimizerValues learnRateValues epochValues minibatchValues learnSchedValues dropFactorValues dropPeriodValues
#	   encoderDepthValues numFiltersValues filterSizeValues gradientDecayValues squaredGradientValues gradientThresholdValues 
#      gradientThresholdMethodValues epsilonValues l2Values);
#testArray=(optimizerValues learnRateValues dropFactorValues dropPeriodValues epochValues
#	   minibatchValues momentumValues encoderDepthValues numFiltersValues filterSizeValues); % sgdm only
testValues=("5" "10" "20");
#optimizer="adam";
#scheduler="piecewise";
LOG_FILE="logfile.log";

# Redirect all stdout and stderr to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# ls -l /nonexistent_directory # This error will also be logged
for item in "${testValues[@]}"; do
	echo "Appending run with value $item to logfile."
	# adam only
	/usr/bin/matlab -nodesktop -nosplash -r "unetTest(LearnRate=0.001, MaxEpochs=$item, BatchSize=4, LearnDropFactor=0.2, LearnDropPeriod=5, EncoderDepth=4, NumFirstEncoderFilters=64, FilterSize=3, GradientDecay=0.9, SquaredGradient=0.999, Epsilon=1e-8, L2=0.0001, GradientThreshold=0.1, GradientThresholdMethod='l2norm'); exit;"
	# sgdm only
#	/usr/bin/matlab -nodesktop -nosplash -r "unetTest(LearnRate=0.001, MaxEpochs=$item, BatchSize=4, LearnDropFactor=0.2, LearnDropPeriod=5, Momentum=0.9, EncoderDepth=4, NumFirstEncoderFilters=64, FilterSize=3); exit;"
done
