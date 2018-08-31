pipeline {
  agent {
    dockerfile true
  }
  stages {
    stage('Clone') {
      steps {
        checkout scm
      }
    }
    stage('Deploy-TF-Backend') {
      steps {
        withCredentials(bindings: [[
                      $class: 'AmazonWebServicesCredentialsBinding',
                      credentialsId: 'CH Sanbox AWS Access Key and Secret Key'
                  ]]) {
            sh '''
            cd config/backend
            terraform init
            terraform apply               -auto-approve               -var "aws_region=${AWS_REGION}"               -var "lock_table_name=${LOCK_TABLE_NAME}"               -var "s3_bucket_name=${S3_BUCKET_NAME}"
          '''
          }

        }
      }
      stage('Commit-TF-Backend-State') {
        steps {
          withCredentials(bindings: [[
                        $class: 'UsernamePasswordMultiBinding',
                        credentialsId: 'GitHub Username and Access Token',
                        usernameVariable: 'REPO_USER',
                        passwordVariable: 'REPO_PASS'
                    ]]) {
              sh '''
            git add config/backend/terraform.tfstate
            git               -c user.name="Angelo Hernandez"               -c user.email="angelo.hernandez@cloudhesive.com.com"               commit               -m "terraform backend state update from Jenkins"
            git push https://${REPO_USER}:${REPO_PASS}@github.com/angeloch1365/node-app master
          '''
            }

          }
        }
        stage('Build-Node-App') {
          steps {
            withCredentials(bindings: [[
                          $class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'CH Sanbox AWS Access Key and Secret Key'
                      ]]) {
                sh '''
            packer validate               -var "aws_region=${AWS_REGION}"               ami.json
          '''
                sh '''
            packer build               -var "aws_region=${AWS_REGION}"               ami.json
          '''
              }

            }
          }
          stage('Deploy-Node-App') {
            steps {
              withCredentials(bindings: [[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'CH Sanbox AWS Access Key and Secret Key'
                        ]]) {
                  sh '''
            cd config/node-app
            terraform init               -backend-config="region=${AWS_REGION}"               -backend-config="bucket=${S3_BUCKET_NAME}"               -backend-config="dynamodb_table=${LOCK_TABLE_NAME}"
            terraform apply               -auto-approve               -var "aws_region=${AWS_REGION}"
          '''
                }

              }
            }
          }
          environment {
            AWS_REGION = 'us-east-1'
            S3_BUCKET_NAME = 'node-app-tf-state-nm1ruznhbx2l'
            LOCK_TABLE_NAME = 'tf-state-lock'
          }
        }