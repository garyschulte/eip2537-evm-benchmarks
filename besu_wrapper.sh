#!/usr/bin/env bash


# define the number of times you want to repeat the test before reporting results, to give jvm time to warm up
REPEAT=50

# default location of besu graalvm evm binary if not already specified by $BESU_EVM
: "${BESU_EVM:=$HOME/dev/besu/build/install/besu/bin/evmtool}"

# Function to convert hexadecimal to decimal using bc for large numbers
hex_to_dec() {
  echo $((16#${1#0x}))
}


# Initialize variables
CODE_ARG=""
INPUT_ARG=""
OTHER_ARGS=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --codefile)
      CODE_ARG="--code=$(cat "$2")"
      shift 2
      ;;
    --inputfile)
      INPUT_ARG="--input=$(cat "$2")"
      shift 2
      ;;
    --bench)
      shift 1
      ;;
    run)
      shift 1
      ;;
    *)
      OTHER_ARGS="$OTHER_ARGS $1"
      shift
      ;;
  esac
done

# Call the original $GETH_EVM command with translated parameters

CMD="$BESU_EVM $CODE_ARG $INPUT_ARG $OTHER_ARGS --repeat=$REPEAT"
#echo $CMD
OUTPUT=$($CMD)
#echo $OUTPUT

# Extract fields and transform the output to look like geth's `evm --bench run` output
echo $OUTPUT | jq -r --arg gasUsed "$(hex_to_dec $(echo $OUTPUT | jq -r '.gasUsed'))" '
  .timens as $timens |
  .output as $output |
  "EVM gas used:    \($gasUsed)\n" +
  "execution time:  \($timens / 1000)µs\n" +
  "allocations:     0\n" + #dummy placeholder
  "allocated bytes: 0\n" + #dummy placeholder
  "\($output)"
'
