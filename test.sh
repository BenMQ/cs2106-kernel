#! /bin/bash
for i in `seq 1 7`;
do
    ruby shell.rb < test/$i.in > test/$i.out
    echo "Test Case $i:"
    diff -w -B test/$i.expected test/$i.out
done

