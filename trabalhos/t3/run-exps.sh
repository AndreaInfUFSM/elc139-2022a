#!/bin/bash

#WEKASH=~/Downloads/weka-3-8-6/weka.sh
WEKASH=~/Downloads/weka-3-8-6/wekajfr.sh 
DATASET_DIR=~/Downloads
RESULTS_DIR=./results
TIMES_FILE=times.csv
VARS_FILE=exp-vars.csv
JFRSETTINGS_FILE=./profile.jfc
MEMORY=32g

# Create the output folder 
mkdir -p $RESULTS_DIR

# Create file to log run times
echo "outprefix,dataset,njobs,timeinsecs" > $RESULTS_DIR/$TIMES_FILE

# Read experiment variables and run each experiment
tail -n +2 $VARS_FILE | while IFS='|' read -r learner dataset njobs learnerparams wekaparams outprefix; do

	# Clean up CSV fields
	learner=$(echo $learner | sed 's/\"//g')
  dataset=$(echo $dataset | sed 's/\"//g')
  learnerparams=$(echo $learnerparams | sed 's/\"//g') # must finish with n_jobs=, otherwise... crash!
	njobs=$(echo $njobs | sed 's/\"//g')	# decoupled from $learnerparams, for convenience
	wekaparams=$(echo $wekaparams | sed 's/\"//g')
	outprefix=$(echo $outprefix | sed 's/\"//g')
	
	echo "Running "$outprefix-$dataset-$njobs
	trap "exit" SIGINT  # to be able to stop this script with a single Ctrl-C

  wekaout=$RESULTS_DIR/$outprefix-$dataset-$njobs-`date +"%Y%m%d%H%M%S"`.txt
	start=`date +%s.%N`		
	$WEKASH -memory $MEMORY -main weka.Run weka.classifiers.sklearn.ScikitLearnClassifier $wekaparams -learner $learner -parameters "$learnerparams$njobs" -t $DATASET_DIR/$dataset.arff -py-command python3 > $wekaout 
	end=`date +%s.%N`
	runtime=$( echo "$end - $start" | bc -l )
	echo $outprefix","$dataset","$njobs","$runtime >> $RESULTS_DIR/$TIMES_FILE

  outprefix=$(echo jfr-$outprefix)
  jfrout=$RESULTS_DIR/$outprefix-$dataset-$njobs.jfr
  wekaout=$RESULTS_DIR/$outprefix-$dataset-$njobs-`date +"%Y%m%d%H%M%S"`.txt
	start=`date +%s.%N`		
	$WEKASH -memory $MEMORY -jfr "filename="$jfrout",settings="$JFRSETTINGS_FILE -main weka.Run weka.classifiers.sklearn.ScikitLearnClassifier $wekaparams -learner $learner -parameters "$learnerparams$njobs" -t $DATASET_DIR/$dataset.arff -py-command python3 > $wekaout 
	end=`date +%s.%N`
	runtime=$( echo "$end - $start" | bc -l )
	echo $outprefix","$dataset","$njobs","$runtime >> $RESULTS_DIR/$TIMES_FILE

  # Alternative commands (left here as examples)
	#/usr/bin/time -f'Time (wallclock): %E' $WEKASH -memory $MEMORY -main weka.Run weka.classifiers.sklearn.ScikitLearnClassifier $wekaparams -learner $learner -parameters "$learnerparams$njobs" -t $DATASET_DIR/$dataset.arff -py-command python3 > $RESULTS_DIR/$outprefix-$dataset-$njobs-`date +"%Y%m%d%H%M%S"`.txt 2>&1
	#$WEKASH -memory $MEMORY -main weka.Run weka.classifiers.sklearn.ScikitLearnClassifier $wekaparams -learner $learner -parameters "$learnerparams$njobs" -t $DATASET_DIR/$dataset.arff -py-command python3 > $RESULTS_DIR/$outprefix-$dataset-$njobs-`date +"%Y%m%d%H%M%S"`.txt
	
	
done
