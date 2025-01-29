 #!/usr/bin/env bash

# Copyright 2018 Ryan Wick (rrwick@gmail.com)
# https://github.com/rrwick/Bacsort

# This script runs FastANI in parallel to build a distance matrix between all assembly clusters. It
# takes one argument: the number of threads.

# This file is part of Bacsort. Bacsort is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version. Bacsort is distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details. You should have received a copy of the GNU General Public License along with
# Bacsort. If not, see <http://www.gnu.org/licenses/>.


# Cria o diretório tree
mkdir -p ../genomas/8-fastani_mash/tree

printf "\n"
echo "Find pairwise distances with FastANI"
echo "------------------------------------------------"

cd ../genomas/7-mash/distance_mash/clusters

ls *.fna > cluster_list

total_count=$(wc -l < cluster_list)
count_per_file=$(perl -w -e "use POSIX; print ceil($total_count/$1), qq{\n}")

cat cluster_list | shuf > split.tmp
split -a 4 -dl $count_per_file split.tmp cluster_list_
rm split.tmp

for q in cluster_list_*; do
    q_num=$(echo $q | sed 's/cluster_list_//')
    for r in cluster_list_*; do
        r_num=$(echo $r | sed 's/cluster_list_//')
        echo "Running FastANI on clusters $q_num and $r_num"
        ../../../../8-fastani_mash/tree/fastani_output_"$q_num"_"$r_num" & > ../../../../8-fastani_mash/tree/fastani_stdout_"$q_num"_"$r_num" &
    done
    printf "Waiting for results... "
    wait
    echo "done"
done

cd ../../../../8-fastani_mash/tree/
cat fastani_output_* > fastani_output
rm fastani_output_* fastani_stdout_*