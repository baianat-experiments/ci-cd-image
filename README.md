# CI

This image is used to build our projects on CI/CD platforms.

## What is included

This image includes the common tools we use in our stack to deploy apps on aws, it includes:

- node (10.x)
- python (3.5.1))
- git
- pip3
- yarn
- npm
- awscli
- awsebcli

## How to use this image

### Use it as a base

```dockerfile
FROM baianat/ci

# RUN YOUR SCRIPTS
```

### ENV

| Variable name         | Value (Examples)     | Description                                                        |
| --------------------- | -------------------- | ------------------------------------------------------------------ |
| AWS_ACCESS_KEY_ID     | AZSADOI21DKAKLD      | IAM User credentials                                               |
| AWS_SECRET_ACCESS_KEY | xxxxxx               | IAM User credentials                                               |
| AWS_DEFAULT_REGION    | eu-central-1         | AWS Region you have choosen for your ElasticBeanstalk application  |
| APPLICATION_NAME      | myapp                | ElasticBeanstalk application name                                  |
| APPLICATION_ENV       | myapp-env            | ElasticBeanstalk application environment                           |

## Examples

### Bitbucket Pipelines

### Deploy to EB using ECR (Docker Project)

```yml
#filename: bitbucket-pipelines.yml

image: baianat/ci

# We want docker for this example
options:
  docker: true

pipelines:
  branches:
    master:
      - step:
         script:
          # login to ecr
          - echo Logging in to Amazon ECR...
          - $(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)

          # build the Docker image (this will use the Dockerfile in the root of your project)
          - echo Building the Docker image..
          - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .

          # tag the docker image
          - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG

          # push the docker image
          - echo Pushing the Docker image...
          - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG

          # Init app using the included script
          - sh /eb-init.sh
          - eb deploy $APPLICATION_ENV

```

## Credits

This image is created after [jobee/pipeline-to-elasticbeanstalk](https://github.com/jobee/pipeline-to-elasticbeanstalk) which we used for a while in our projects.
