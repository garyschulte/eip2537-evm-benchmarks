#! /usr/bin/env bash

for i in {1..32}
do
	PRECOMPILE=g2msm INPUT_COUNT=$i ./benchmark.sh
done

#for i in {64, 128, 256, 512, 1024, 2048}
#do
#	PRECOMPILE=g2msm INPUT_COUNT=$i ./benchmark.sh
#done
