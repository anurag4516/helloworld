pipeline 
{
    agent any
    tools 
    {
        maven 'Maven 3.3.9'
       
    }
    stages
    {
        
      
       stage('Checkout external Hellow-world proj')
        {
       
            // I have configured credentials in Jenkins with its id as anurag4516 & set password
            //We can also do ssh cloning for that we need to add public key to git 
            steps
            {
                checkout scm;
            // git branch: 'master',
            //     credentialsId: 'anurag4516',
            //     url: 'https://github.com/kuberguy/helloworld.git'

            sh "ls -lat"
            echo "Successfully Checkout of project "
            }
        
        }
            
         stage("Compile & Build Sources from Maven")
        {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                    mvn clean package
                   
                   
                '''
            }

        }  
        stage("Build Docker Image for generated jar")
         {
            steps 
            {
                sh '''
                echo "Building Image from Output snapshot of Package command"
                docker build -anurag4516/${BUILD_NUMBER} -f Dockerfile .
                
                 '''
            }
        }
        
        
        stage("Push Docker Image to registory")
        {
            steps 
            {
             sh '''
                echo "Building Image from Output snapshot of Package command"
                
                
                 '''
           
            }
        }
        
    }
   
    

}
