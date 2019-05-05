pipeline 
{
    agent any
    tools 
    {
        maven 'Maven 3.3.9'
       
    }
    stages
    {
        def customImage
      
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
                                
                 '''
                 docker.withRegistry('https://registry.example.com', 'anurag4516')
                  {
                 customImage = docker.build("anurag4516/helloworld:${env.BUILD_ID}")
                 }
            }
        }
        
        
        stage("Push Docker Image to registory")
        {
            steps 
            {
             sh '''
                echo "Push Docker Image to registory"
                                
                 '''
           docker.withRegistry('https://registry.example.com', 'anurag4516')
           {
               customImage.push()

           }
         }
        }
        
    }
   
    

}
