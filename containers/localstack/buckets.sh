#!/bin/bash
# https://unix.stackexchange.com/a/436713/218238

N=30

for i in {1..2000} ; do
    (
        awslocal s3 mb s3://bucket-$i
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        # now there are $N jobs already running, so wait here for any job
        # to be finished so there is a place to start next one.
        wait -n
    fi

done

# no more jobs to be started but wait for pending jobs
# (all need to be finished)
wait

echo "all done"
