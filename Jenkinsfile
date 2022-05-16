pipeline {

	agent { 
		dockerfile {
			label 'win-agent'
	      	}
	}
	

	
	stages {
		stage ('powershell run') {
			steps ('MyWindowsSlave') {
     				powershell(script:".\\build.ps1")
			}
		}
			
	}
}


