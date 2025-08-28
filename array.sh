#!/bin/bash

movies=("Bahubali" "RRR" "Globetroting")

echo "First Hit: ${movies[0]}"
echo "ALL Hit: ${movies[@]}"
echo "NO Hit: ${movies[5]}"
