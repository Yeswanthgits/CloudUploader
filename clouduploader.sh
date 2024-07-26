#!/bin/bash


function clouduploader() {
	local file="$1"
	local bucket="$2"
	local retry_attempt=3
	if [ ! -f "$file" ]; then
		echo "Error!! File $file not found!"
		exit 1
	fi
	for((i=0; i<retry_attempt; i++)); do
		if pv -pterb "$file" | aws s3 cp "$file" "s3://$bucket/" 2>/dev/null; then
			echo "File Uploaded Successfully"
			return 0
		fi
		echo "Upload Failed! Retrying in 3 seconds. Please wait..."
		sleep 3
	done
	echo "Uploading Failed after $retry_attempt times"
	exit 1
}

clouduploader "$1" "$2"
