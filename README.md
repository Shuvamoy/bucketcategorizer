Once you obtain an Access Key and Secret Key, run the below tool, it will scan for all the available s3 buckets and tell you which ones are public and which are private and sort them in separate files.

Where should you use this ?

Internal/External Pentest Engagement where you have obtained Access Key and Secret Key

Why should you use this ?

After getting a list of buckets this helps you to sort out what to test next by excluding the rest. Saves time and effort.
Although written in bash, it still runs resl fast since parallel has been implemented.
