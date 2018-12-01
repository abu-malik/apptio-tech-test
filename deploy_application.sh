#!/bin/bash

artifact=$1;
artifact_download_path="/tmp/$artifact";
envName="apptio-web-app";

artifactSource="s3://techops-interview-webapp/$artifact"
s3appBuilds="apptio-web-app-versions"

aws s3 cp $artifactSource $artifact_download_path

mkdir /tmp/apptio
mv $artifact_download_path /tmp/apptio
cd /tmp/apptio
tar -xf $artifact
rm $artifact
mv public/* .
rm -r public

v_Label=$(aws elasticbeanstalk describe-application-versions --application-name $envName --max-records 1 | grep VersionLabel | awk -F ":" '{ print $2 }' | sed 's/ //g' | sed 's/"//g' | sed 's/,//g')
[ -z "$v_Label" ] && v_Label=0 || v_Label=$v_Label
#echo v_Label is $v_Label
num=1;
versionLabel=$(( $num + $v_Label ))

#echo versionLabel is $versionLabel

zip -r webapp-$versionLabel.zip *

echo "Uploading zip file to appBuilds S3 bucket"
aws s3 cp /tmp/apptio/webapp-$versionLabel.zip s3://$s3appBuilds/webapp-$versionLabel.zip
rm -rf /tmp/apptio
cd /tmp

echo "Creating Application Version label: $versionLabel"
json1=$(aws elasticbeanstalk create-application-version --application-name $envName --version-label $versionLabel --source-bundle S3Bucket=$s3appBuilds,S3Key=webapp-$versionLabel.zip)

echo "Deploying version $versionLabel of $artifact ..."
json2=$(aws elasticbeanstalk update-environment --environment-name $envName --version-label $versionLabel)

echo "Deployment completed successfully..."
