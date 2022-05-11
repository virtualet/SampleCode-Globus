pipeline {

	agent { 
		dockerfile true 
	      	node { label 'win-agent' }
	      }

	stages {
		stage ('powershell run')
		{
		       steps { powershell('build.ps1') 
		     	}
		}	
	}
