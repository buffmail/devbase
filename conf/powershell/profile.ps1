$additionalPaths = @(
	".",
	"C:\Program files\Subversion\bin",
	"C:\Programs\Vim\vim73",
	"C:\Programs\Python27\",
	"C:\Programs\ntemacs24\bin",
    "C:\Program Files (x86)\MSBUILD\12.0\Bin"
    "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\"
	"D:\Work\Scripts"
)
$workbase = "C:\Work\X3\Code"
if ( $env:COMPUTERNAME -ne "XL0347-P5" )
{
	$workbase = "D:/"
}

foreach ( $path in $additionalPaths )
{
	$env:path += ";" + $path
}

Set-Alias tp TortoiseProc
Remove-Item Alias:cd
function cd 
{ 
	if ($args[0] -eq '-') 
	{ 
		$pwd=$OLDPWD; 
	} 
	else 
	{ 
		$pwd=$args[0]; 
	} 
	$tmp=pwd; 
	if ($pwd) 
	{ 
		Set-Location $pwd; 
	} 
	Set-Variable -Name OLDPWD -Value $tmp -Scope global; 
}
Get-Item function:cd

function gitlog
{
	git log -n 10 --oneline
	Write-host ''
}

Set-Variable SVN_EDITOR gvim.exe
cd $workbase

Write-host "home dir : "
Write-host $env:HOME

function ls-changed($minute)
{
	ls *.h -R | where {$_.LastWriteTime -gt ((Get-Date).AddMinutes(-$minute))} | select DirectoryName, Name, LastWriteTime
}

# -------------------------------------------------------------------------
# Function called by Emacs to do tab expansions that work just like the
# built in tab expansion of powershell.exe in a console window.
# -------------------------------------------------------------------------
function TabExpansionEmacs
{
	param( $line, $lastWord )

    $currDir = Get-Location
    $currDir = $currDir.ToString() + "\"
    write-host ""
    write-host ""
    write-host ""
	$ret = $(resolve-path -path ($lastWord + "*"))
	if ($ret -eq $NULL)
	{
		write-host $lastWord
		return
	}
	$ret | foreach-object {
		$entry = $_.ToString()
		if (Test-Path $_ -pathtype container)
		{
			$entry += '\'
		}
		Write-host $entry.Replace($currDir, "")
	}
}

function p 
{ 
	$argList = [System.Collections.ArrayList]$args
	if ($argList.Count -eq 0){
		echo "Argument is null"
		return
	}

	if (-Not (Test-Path($argList[0]))){
		$argList[0] = 'D:/Work/Scripts/' + $argList[0]
	}

	$cmdLine = 'python ' + ($argList -Join ' ')
	echo $cmdLine
	Invoke-Expression -command $cmdLine
}
