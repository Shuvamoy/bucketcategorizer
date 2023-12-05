#!/bin/bash

private_buckets_file="privatebuckets.txt"
public_buckets_file="publicbuckets.txt"
buckets_file="buckets.txt"

aws s3 ls > s3_buckets.txt

cat s3_buckets.txt| cut -d ' ' -f 3-  > buckets.txt
rm s3_buckets.txt

# Function to check if a bucket is publicly accessible
check_bucket_access() {
    local bucket=$1
    local is_public=$(aws s3api get-bucket-acl --bucket "$bucket" --query "Grants[?Grantee.URI=='http://acs.amazonaws.com/groups/global/AllUsers'].Permission" --output text)

    if [[ "$is_public" == "READ" ]]; then
        echo "Bucket $bucket is public"
        echo "$bucket" >> "$public_buckets_file"
    else
        echo "Bucket $bucket is private"
        echo "$bucket" >> "$private_buckets_file"
    fi
}

# Ensure the output files are empty
> "$public_buckets_file"
> "$private_buckets_file"

# Read buckets from the file and process them in parallel
while IFS= read -r bucket; do
    check_bucket_access "$bucket" &
done < "$buckets_file"

# Wait for all background processes to finish
wait

# Count the number of public and private buckets
public_count=$(wc -l < "$public_buckets_file")
private_count=$(wc -l < "$private_buckets_file")

echo "Summary:"
echo "Public buckets -->publicbuckets_sorted.txt: $public_count"
echo "Private buckets -->privatebuckets_sorted.txt: $private_count"

awk '{print $1 ".s3.amazonaws.com"}' privatebuckets.txt > privatebuckets_sorted.txt
awk '{print $1 ".s3.amazonaws.com"}' publicbuckets.txt > publicbuckets_sorted.txt
rm privatebuckets.txt
rm publicbuckets.txt
