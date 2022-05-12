pipeline {

	agent { 
		dockerfile {
			label 'win-agent'
	      	}
	}

	stages {
		stage ('powershell run') {
		       steps { 
			       powershell( script:'build.ps1' ) 
			}
		}
			
	}
}
