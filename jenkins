pipeline {
	node { label 'win-agent' }

	agent { dockerfile true }

	stages {
		steps { powershell('build.ps1') }
	}
}
