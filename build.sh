#!/bin/bash
read -p 'Release Version: ' releaseversion

# Build docker images based on file that you have.
docker build --platform linux/amd64 . -f strapi.Dockerfile -t cygnus:$releaseversion

# Tag docker image that you build to be uploaded to ECR
docker tag cygnus:$releaseversion 754405019766.dkr.ecr.ap-south-1.amazonaws.com/cygnus:$releaseversion

# Login to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 754405019766.dkr.ecr.ap-south-1.amazonaws.com/cygnus

# Push image to ecr
docker push 754405019766.dkr.ecr.ap-south-1.amazonaws.com/cygnus:$releaseversion

# Get current task definition json
#TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "ck-backend-worker-prod-amd64" --region "ap-south-1")

# Update the new docker version that you updated above to task definition json. Delete fields not required during upload
#NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION | jq --arg IMAGE "754405019766.dkr.ecr.ap-south-1.amazonaws.com/ck-backend-server:$releaseversion" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) |  del(.registeredAt) | del(.registeredBy)')

# Update the new task definition to the ECS
#TASK_DEFINITION_RESULT=$(aws ecs register-task-definition --region "ap-south-1" --cli-input-json "$NEW_TASK_DEFINTIION")

# Get the revision from the Task definition 
#REVISION=$(echo $TASK_DEFINITION_RESULT | jq '.taskDefinition.revision')


#Below code is to kill the tasks of service in cluster. If you are on rolling release you don't need to kill.
# It will automatically get killed once the new version of service deployed
# ACTIVE_TASKS=$(aws ecs list-tasks --cluster "ck-backend-worker-prod" --desired-status RUNNING --family "ck-backend-worker-prod")
# echo $ACTIVE_TASKS | jq -c '.taskArns[]' | while read i; do
#     echo $i
# done

#Update the service with the new version. This create 1 task of the new service definition killing any previous task
#UPDATE_SERVICE_RESULT=$(aws ecs update-service --cluster "ck-backend-worker-prod-amd64" --service "bull-background-worker" --task-definition ck-backend-worker-prod-amd64:$REVISION --desired-count 2)

# Below code is if you want to remove the service family from the cluster
# STOP_SERVICE_RESULT=$(aws ecs delete-service --cluster ck-backend-worker-prod --service bull-background-worker --force)