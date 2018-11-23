function New-GitHubRepo {
	Param(
		[parameter(Mandatory=$true, Position=0)] [String] $RepoName,
		[String] $Description,
		[Switch] $Private
	)
	
	$PostParamsHash = @{
		name=$RepoName;
		description=$Description;
		private=$(If ($Private) {"true"} Else {"false"}) 
	}
	
	$PostParams = $PostParamsHash | ConvertTo-Json
	
	# https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
	$user = 'aryan-gupta'
	$pass = '***REMOVED***'
	$pair = "$($user):$($pass)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
	$basicAuthValue = "Basic $encodedCreds"
	$Headers = @{
		Authorization = $basicAuthValue
	}

	Invoke-WebRequest -ContentType "application/json" -URI "https://api.github.com/user/repos" -Method POST -Body $PostParams -Headers $Headers
	
}

function SetupGitSCM {
	Param(
		[parameter(Mandatory=$true, Position=0)] [String] $RepoName
	)

	# Sample: https://github.com/aryan-gupta/WINSetup.git
	$GitLink = ('https://github.com/aryan-gupta/' + $RepoName + '.git')
	git init
	git remote add origin $GitLink
}

function CreateInitialCommit {
	git add *
	git commit -m "Initial Commit"
}

function CreateFolders {
	$RootDir = (Resolve-Path ".\").Path
	New-Item -Type "Directory" -Path $RootDir -Name 'src' -Force # cpp and h files
	New-Item -Type "Directory" -Path $RootDir -Name 'bin' -Force # final EXE and dlls
	New-Item -Type "Directory" -Path $RootDir -Name 'build' -Force # obj directory
	# New-Item -Type "Directory" -Path $RootDir -Name 'ext' -Force
	New-Item -Type "Directory" -Path $RootDir -Name 'test' -Force # tests
	New-Item -Type "Directory" -Path $RootDir -Name 'doc' -Force # documentation
}

function CreateFiles {
	
	Param(
		[parameter(Mandatory=$true,Position=0)] [String] $ProjName
	)
	
	$RootDir = (Resolve-Path '.\').Path
	

	
	# Main CPP
	New-Item -Force -Type "File" -Path ($RootDir + '\src') -Name 'main.cpp' -Value ($FileHeader + '`n' + $MainText)
	
	# Main Header

	New-Item -Force -Type "File" -Path ($RootDir + '\src') -Name 'main.cpp' -Value ($FileHeader + '`n' + $MainHText)
	
	# Readme

	New-Item -Force -Type file -Path $RootDir -Name 'README.md' -Value $ReadMe
	# Licence
	
	# .gitignore
	
	# Resource script
	
	# makefile
	
	# info Header
	
	# .gitkeep
	
}


function New-Project {
	Param(
		[parameter(Mandatory=$true, Position=0)] [String] $ProjName,
		[String] $Description,
		[Switch] $Private
	)

	if ($Private) {
		Create-GitHubRepo -RepoName $ProjName -Description $Description -Private
	} else {
		Create-GitHubRepo -RepoName $ProjName -Description $Description
	}

	Setup-GitSCM $ProjName
	Create-Folders
	Create-Files
	Create-InitialCommit
}

Export-ModuleMember *-*