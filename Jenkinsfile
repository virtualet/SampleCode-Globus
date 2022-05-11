pipeline {

	agent { 
		dockerfile true 
	      }

	stages {
		stage ('powershell run') {
		       steps { powershell('build.ps1') 
			     }
	}
			
	}
}
