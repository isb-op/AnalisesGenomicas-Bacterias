#!/usr/bin/env python3
"""
USAGE: ./cluster_genera.py <folder_name>
Example: ./cluster_genera.py 4-clustering-genomes

When run, it clusters genomes in each genus and copies one genome per cluster to the
clusters directory.
"""

import argparse
import collections
import gzip
import os
import pathlib
import re
import shutil


def get_arguments():
    parser = argparse.ArgumentParser(description='Cluster assemblies in each genus')

    parser.add_argument('assembly_dir', type=str,
                        help='Assembly directory (should contain one subdirectory per genus)')

    parser.add_argument('--threshold', type=float, required=False, default=0.005,
                        help='Mash distance clustering threshold')
    args = parser.parse_args()
    return args


def main():
    args = get_arguments()

    genera = sorted(os.path.basename(str(x)) for x in pathlib.Path(args.assembly_dir).iterdir()
                    if x.is_dir())

    for genus in genera:
        print()
        print('Clustering ' + genus)
        print('------------------------------------------------')

        distance_filename = args.assembly_dir + '/' + genus + '/mash_distances'
        if not pathlib.Path(distance_filename).is_file():
            print('Could not find pairwise distances file - skipping genus')
            print()
            continue

        assemblies, graph = create_graph_from_distances(distance_filename, args.threshold)
        clusters = cluster_assemblies(assemblies, graph)

        if not pathlib.Path(args.assembly_dir + '/' + 'clusters').is_dir():
            os.makedirs(args.assembly_dir + '/' + 'clusters')

        print()
        cluster_num_digits = len(str(len(clusters)))
        cluster_num_format = '%0' + str(cluster_num_digits) + 'd'
        with open(args.assembly_dir + '/' + 'cluster_accessions', 'at') as cluster_accessions_file:
            for num, assemblies in clusters.items():
                cluster_name = genus + '_' + (cluster_num_format % num)

                # Choose representative for each cluster by N50.
                if len(assemblies) == 1:
                    representative = assemblies[0]
                else:
                    representative = sorted([(get_assembly_n50(args.assembly_dir + '/' + genus + '/' + a), a)
                                             for a in assemblies])[-1][1]

                out_line = cluster_name + '\t' + representative + '\t' + \
                    ','.join([(a + '*' if a == representative else a) for a in assemblies])
                cluster_accessions_file.write(out_line)
                cluster_accessions_file.write('\n')
                print(out_line)

                shutil.copyfile(args.assembly_dir + '/' + genus + '/' + representative,
                                args.assembly_dir + '/' + 'clusters/' + representative)
        print()


def create_graph_from_distances(distance_filename, threshold):
    print('Loading distances...', end='', flush=True)

    assemblies = set()
    graph = collections.defaultdict(set)
    all_connections = collections.defaultdict(set)

    with open(distance_filename, 'rt') as distance_file:
        for line in distance_file:
            parts = line.split('\t')

            assembly_1 = parts[0]
            assembly_2 = parts[1]
            distance = float(parts[2])

            # Skip this line if either assembly has been excluded. We check the first 13 characters
            # of the assembly name because that's the accession up to the version number. E.g. the
            # full assembly name might be GCF_002053395.1.fna.gz but we just check the first 13
            # characters (GCF_002053395).
            #if assembly_1[:13] in excluded or assembly_2[:13] in excluded:
                #continue

            assemblies.add(assembly_1)
            assemblies.add(assembly_2)

            if assembly_1 == assembly_2:
                continue

            all_connections[assembly_1].add(assembly_2)
            all_connections[assembly_2].add(assembly_1)

            if distance < threshold:
                graph[assembly_1].add(assembly_2)
                graph[assembly_2].add(assembly_1)

    assemblies = sorted(assemblies)
    assembly_count = len(assemblies)

    noun = ('assembly' if assembly_count == 1 else 'assemblies')
    print(' found', assembly_count, noun)

    # Sanity check: make sure we have all the connections.
    for assembly in assemblies:
        assert len(all_connections[assembly]) == assembly_count - 1

    return assemblies, graph


def cluster_assemblies(assemblies, graph):
    visited = set()
    i = 0
    clusters = {}
    for assembly in assemblies:
        if assembly in visited:
            continue
        i += 1
        connected = dfs(graph, assembly)
        clusters[i] = sorted(connected)
        visited |= connected
    return clusters


def dfs(graph, start):
    visited, stack = set(), [start]
    while stack:
        vertex = stack.pop()
        if vertex not in visited:
            visited.add(vertex)
            stack.extend(graph[vertex] - visited)
    return visited


def get_assembly_n50(filename):
    contig_lengths = sorted(get_contig_lengths(filename), reverse=True)
    total_length = sum(contig_lengths)
    target_length = total_length * 0.5
    length_so_far = 0
    for contig_length in contig_lengths:
        length_so_far += contig_length
        if length_so_far >= target_length:
            return contig_length
    return 0


def get_contig_lengths(filename):
    lengths = []
    with open(filename, 'rt') as fasta_file:
        name = ''
        sequence = ''
        for line in fasta_file:
            line = line.strip()
            if not line:
                continue
            if line[0] == '>':  # Header line = start of new contig
                if name:
                    lengths.append(len(sequence))
                    sequence = ''
                name = line[1:].split()[0]
            else:
                sequence += line
        if name:
            lengths.append(len(sequence))
    return lengths


if __name__ == '__main__':
    main()