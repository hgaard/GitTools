<#
.SYNOPSIS
Retrieves file versions with their path, hash and repository size
.PARAMETER WorkTreePath
Indicates the local repository (work tree) for the operation
.EXAMPLE
Get-GitRepositoryFileSize

Gets git repository file sizes for the work tree in the current directory
.EXAMPLE
Get-GitRepositoryFileSize C:\Zaphod
Gets git repository file sizes for the work tree in the C:\Zaphod directory
.EXAMPLE
Get-GitRepositoryFileSize | sort -des size | select -first 20
Gets 20 largest files from the repository
#>
function Get-GitRepositoryFileSize 
{
    [CmdletBinding()]
    param(
        [Parameter(Position=1)]
        [string]$WorkTreePath=(pwd)
    )

    $hashes = git --work-tree $WorkTreePath rev-list --objects --all | sls "^\w+\s\w" | ConvertFrom-Csv -Delimiter ' ' -head hash,path | %{$h=@{}}{$h[$_.hash]=$_.path}{$h}

    git --work-tree $WorkTreePath gc

    $indexFile = ".git\objects\pack\" + (".git\objects\pack" | gci -Filter 'pack-*.idx')

    git --work-tree $WorkTreePath verify-pack -v $indexFile | %{$_  -creplace '\s+', ','} | sls "^\w+,blob\W+[0-9]+,[0-9]+,[0-9]+$" | ConvertFrom-Csv -Header hash, type, size | %{New-Object pscustomobject -Property @{Hash=$_.hash; Size=[int]$_.size; Path=$hashes[$_.hash]}}

}

#try these:

#Get-GitRepositoryFileSize | Sort-Object Size -Descending | select -First 20

#help Get-GitRepositoryFileSize -Detailed 

