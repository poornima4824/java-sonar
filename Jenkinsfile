//Test1
//Test2
def COMMIT
def BRANCH_NAME
def GIT_BRANCH
pipeline
{
 agent any
 tools
 {
      maven 'maven'
 }   
 stages
 {
     stage('Code checkout')
     {
         steps
         {
             script
             {
                 checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/poornima4824/java-sonar.git']]])
                 COMMIT = sh (script: "git rev-parse --short=10 HEAD", returnStdout: true).trim()  
                 COMMIT_TAG = sh (script: "git tag --contains | head -1", returnStdout: true).trim() 
            }
             
         }
     }
     stage('Build')
     {   
         steps
         {
             sh "mvn clean package"
         }
     }
     stage('mail') {
            steps {
                emailext mimeType: 'text/html',
                subject: "[Jenkins]${currentBuild.fullDisplayName}",
                to: 'naga.poornima22@gmail.com',
                body: '''<a href="${BUILD_URL}input">click to approve for Deployment</a>'''
            }
        }
        
      stage('Approval for deploy') {
           steps {
            input "deploy proceed?"
              }
        }

     stage('Execute Sonarqube Report')
     {
         steps
         {
            withSonarQubeEnv('sonar') 
             {
               // sh "mvn sonar:sonar"
               sh "mvn sonar:sonar -Dsonar.host.url=http://54.159.53.182:9000"
             }  
         }
     }
     stage('Quality Gate Check')
     {
         steps
         {
             timeout(time: 1, unit: 'HOURS') 
             {
                waitForQualityGate abortPipeline: true
            }
         }
     }
     stage('Building docker image') {
            steps {
               script {
                   sh 'docker build -t java-webapp .'
                }
            }
        }
     stage('stop previous containers') {
         steps {
            sh 'docker ps -f name=webcontainer -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fname=webcontainer -q | xargs -r docker container rm'
         }
       }
      stage('Deploy the docker image') {
            steps {
                script {
                   sh "docker run -d -p 9090:8080 --name webcontainer java-webapp "
                }
            }
        }
 }    
}
