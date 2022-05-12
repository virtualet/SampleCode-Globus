pipeline {

	agent { 
		dockerfile {
			label 'win-agent'
	      	}
	}
	

	
	stages {
		stage ('powershell run') {
			step ('MyWindowsSlave') {
     				PowerShell(". '.\\build.ps1'")
			}
		}
			
	}
}

			def PowerShell(psCmd) {
				psCmd=psCmd.replaceAll("%", "%%")
    				bat "powershell.exe -NonInteractive -ExecutionPolicy Bypass -Command \"\$ErrorActionPreference='Stop';[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$psCmd;EXIT \$global:LastExitCode\""
			}
