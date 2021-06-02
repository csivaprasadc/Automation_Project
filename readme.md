# Apache2 Installation and Log Archival Automation

This repo contains a script to install Apache2 if it is not installed in a EC2 instance.
It also checks if apache2 service is running or not and does the restart or start accordingly.
It also creates a tar file of the logs and copies it to the s3 bucket.
