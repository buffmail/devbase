$additionalPaths = @(
	".",
	"C:\Program Files\Microsoft Visual Studio 8\Common7\IDE",
	"C:\Program files\Subversion\bin",
	"C:\Program Files\Microsoft Visual Studio 8\Common7\Tools",
	"C:\Windows\Microsoft.NET\Framework\v4.0.30319\",
	"C:\Program Files (x86)\Git\bin",
	"C:\Program Files\TortoiseHG",
	"C:\Program Files\Vim\vim73",
	"C:\Python26\",
	"C:\Python32\",
	"C:\Program Files\Subversion\bin",
	"D:\ThirdPartyProgs\bin",
	"D:\ThirdPartyProgs\UnxUtils\usr\local\wbin",
	"D:\ThirdPartyProgs\UnxUtils\bin",
	"D:\ThirdPartyProgs\ntemacs24\bin",
	"C:\Program Files\ntemacs24\bin",
	"D:\Scripts",
	"D:\external\gitblit\",
	"D:\adt-bundle-windows-x86_64\sdk\platform-tools"
)
$workbase = "C:\Work\X3_340\Code"
if ( $env:COMPUTERNAME -ne "XL0347-P1" )
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
	$ret | foreach-object { Write-host $_.ToString().Replace($currDir, "")}
}

