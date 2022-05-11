pipeline {

	agent { 
		dockerfile true 
	      	node { label 'win-agent' }
	      }

	stages {
		steps { powershell('build.ps1') }
	}
}
