@Library('sharedlibrary') _

pipeline {
    agent { label 'docker' }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Deployment environment')
        booleanParam(name: 'BUILD_ALL', defaultValue: false, description: 'Build all microservices regardless of changes')
        booleanParam(name: 'APPROVAL', defaultValue: false, description: 'Required for staging/prod')
    }

    environment {
        ecrRegistry   = "879381264703.dkr.ecr.ap-south-1.amazonaws.com"
        branchName    = sh(script: 'echo $BRANCH_NAME | sed "s#/#-#"', returnStdout: true).trim()
        gitCommit     = "${env.GIT_COMMIT[0..6]}"
        dockerTag     = "${branchName}-${gitCommit}"
        allServices   = ['frontend','gateway','personalization','orderservice','inventory',
                         'analytics','payments','notifications','auth','userprofile',
                         'search','recommendation','logging','monitoring','admin']
    }

    stages {

        /* 1. Checkout */
        stage('Checkout') {
            steps {
                gitCheckout("$gitRepoURL", "refs/heads/${env.BRANCH_NAME}", 'githubCred')
            }
        }

        /* 2. Detect Changed Services */
        stage('Detect Changed Services') {
            steps {
                script {
                    if (params.BUILD_ALL || env.BUILD_CAUSE == 'TIMERTRIGGER') {
                        changedServices = allServices
                        echo "Full build → building all services"
                    } else {
                        changedServices = detectChangedServices()
                        if (changedServices.isEmpty()) {
                            currentBuild.result = 'SUCCESS'
                            error("No microservices changed")
                        }
                        echo "Incremental build → changed services: ${changedServices}"
                    }
                }
            }
        }

        /* 3. Build & Unit Tests */
        stage('Build & Unit Tests') {
            steps {
                script {
                    changedServices.each { svc ->
                        dir("services/${svc}") {
                            sh "mvn clean verify"
                        }
                    }
                }
            }
        }

        /* 4. SonarQube Analysis */
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh "mvn verify sonar:sonar"
                }
            }
        }

        /* 5. Quality Gate */
        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        /* 6. Docker Build */
        stage('Docker Build') {
            steps {
                script {
                    changedServices.each { svc ->
                        dockerImageBuild("${ecrRegistry}/${svc}", "${dockerTag}")
                    }
                }
            }
        }

        /* 7. Trivy Image Scan */
        stage('Trivy Image Scan') {
            steps {
                script {
                    changedServices.each { svc ->
                        sh """
                        trivy image \
                          --severity CRITICAL,HIGH \
                          --exit-code 1 \
                          -f json \
                          -o reports/trivy-${svc}.json \
                          ${ecrRegistry}/${svc}:${dockerTag}
                        """
                    }
                }
            }
        }

        /* 8. Push Image to Amazon ECR */
        stage('Push Image to Amazon ECR') {
            steps {
                script {
                    changedServices.each { svc ->
                        dockerECRImagePush("${ecrRegistry}/${svc}", "${dockerTag}", "ap-south-1")
                    }
                }
            }
        }

        /* 9. Manual Approval (Staging/Production) */
        stage('Manual Approval') {
            when {
                expression { params.ENVIRONMENT != 'dev' }
            }
            steps {
                script {
                    if (!params.APPROVAL) {
                        error("Approval required for ${params.ENVIRONMENT} deployment")
                    }
                    input message: "Approve deployment to ${params.ENVIRONMENT}?"
                }
            }
        }

        /* 10. Deploy using Helm */
        stage('Deploy using Helm') {
            steps {
                script {
                    changedServices.each { svc ->
                        sh """
                        helm upgrade --install ${svc} ./helm/${svc} \
                          -f helm/${svc}/values-${params.ENVIRONMENT}.yaml \
                          --set image.repository=${ecrRegistry}/${svc} \
                          --set image.tag=${dockerTag} \
                          --namespace ${svc}-${params.ENVIRONMENT} \
                          --create-namespace \
                          --wait \
                          --timeout 6m \
                          --atomic
                        """
                        sh "kubectl rollout status deployment/${svc} -n ${svc}-${params.ENVIRONMENT} --timeout=180s"
                    }
                }
            }
        }

        /* 11. Smoke Test */
        stage('Smoke Test') {
            steps {
                sh "./run-smoke-tests.sh --env ${params.ENVIRONMENT}"
            }
        }

        /* 12. Health Check */
        stage('Health Check') {
            steps {
                script {
                    changedServices.each { svc ->
                        sh "kubectl get pods -n ${svc}-${params.ENVIRONMENT}"
                        sh "kubectl get svc -n ${svc}-${params.ENVIRONMENT}"
                        sh "curl -f https://${params.ENVIRONMENT}.hp.company.com/health || exit 1"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment SUCCESS: ${dockerTag} -> ${params.ENVIRONMENT}"
        }
        failure {
            echo "Deployment FAILED in ${params.ENVIRONMENT}, rolling back"
            script {
                changedServices.each { svc ->
                    sh "helm rollback ${svc} 1 -n ${svc}-${params.ENVIRONMENT} || true"
                }
            }
        }
        always {
            archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
            cleanWs()
        }
    }
}
