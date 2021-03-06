function Prep($dest)
{
    foreach ($file in (ls $dest))
    {
        (Get-Content $file.PSPath) | % {$_ -replace "USE \[DeploymentDB\]", "USE [DemoDb]"} | Set-Content $file.PSPath
    }
}

function CopyAndPrepTable($source,$dest)
{
    
    $ii = (@(ls $dest).Length) + 1
	$files = ls $source
    foreach ($file in $files)
    {
        $n = $file.Name
        $d = "$dest\{0:0000}_$n" -f $ii++
        cp $file.FullName $d
    }
    
    Prep $dest
}

function CopyAndPrep($source,$dest)
{
	cp $source\* $dest
	prep $dest
}

$AWDir = "C:\Users\Scott\Documents\d\CodePlex\PSIS\DDExtract"
$DSDir = "C:\Users\Scott\Documents\d\CodePlex\PSIS\DemoSource"

CopyAndPrepTable  $AWDir\Schemas $DSDir\TableScripts
CopyAndPrepTable  $AWDir\Tables $DSDir\TableScripts

$dirs = & { $args } UserDefinedDataTypes Views StoredProcedures UserDefinedDataTypes UserDefinedFunctions Views XmlSchemaCollections
foreach ($dir in $dirs)
{
	if (! (Test-Path $DSDir\DemoDb\$dir\))
	{
		mkdir $DSDir\DemoDb\$dir\
	}
	CopyAndPrep $AWDir\$dir $DSDir\DemoDb\$dir\
}
#cp $AWDir\UserDefinedDataTypes\* $DSDir\DemoDb\UserDefinedDataTypes\
#cp $AWDir\Views\* $DSDir\DemoDb\Views\
#Prep $DSDir\DemoDb\UserDefinedDataTypes\
#Prep $DSDir\DemoDb\Views\
