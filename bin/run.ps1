param(
    [switch] $venv,   # Create virtual environment
    [switch] $load,   # Load virtual environment
    [switch] $import, # Import dependencies
    [switch] $preview # Output command preview - no execution
)

Set-StrictMode -Version 3.0
Write-Verbose "Loading $PSCommandPath"

#region Config

$PY_CMD = "python"
$VENV_DIR = ".venv"
$PROJ_DIR = Resolve-Path "$PSScriptRoot\.."
$PACKAGES_FILE = "$PROJ_DIR\.packages"

#endregion

#region Operations

function RunCmd
{
    param(
        [string] $cmd
    )

    $cur_dir = Get-Location
    Set-Location $PROJ_DIR
    Write-Debug "Setting working directory - $cur_dir -> $PROJ_DIR"

    Write-Debug $cmd
    if (!$preview) { Invoke-Expression $cmd }

    Set-Location $cur_dir
}

<#
function CreateEnvironment
{
    Write-Verbose "Creating Python virtual environment.."
    RunCmd "$PY_CMD -m venv $VENV_DIR"
}

function UpdatePackageManager
{
    Write-Verbose "Updating PIP"
    RunCmd "$PY_CMD -m pip install --upgrade pip"
}

function LoadEnvironment
{
    Write-Verbose "Loading virtual environment"
    RunCmd ".\$VENV_DIR\Scripts\Activate.ps1"
}

function ImportLibraries
{
    Write-Verbose "Importing libraries.."
    RunCmd "$PY_CMD setup.py install"
    RunCmd "$PY_CMD -m pip install -r '$PACKAGES_FILE'"
    RunCmd "$PY_CMD -m pip install -e ."
}

function ExportLibraries
{
    Write-Verbose "Exporting environment package list.."
    RunCmd "$PY_CMD -m pip freeze > '$PACKAGES_FILE'"
}
#>

function TextToImage
{
    param(
        [string] $text = "a photograph of a gopher wearing a wizard hat in a forest, vivid, photorealistic, magical, fantasy, 8K UHD, photography",
        [int] $iteration_cnt = 5,
        [int] $sample_cnt = 1,
        [int] $height = 512,
        [int] $width = 512,
        [int] $seed = 42
    )
    Write-Verbose "Executing text to image generation.."
    $py_script = ".\scripts\txt2img.py"
    RunCmd "$PY_CMD $py_script --prompt '$text' --plms --n_iter $iteration_cnt --n_samples $sample_cnt --H $height --W $width --seed $seed"
    # --ddim_steps 50
}

#endregion

#region Execution

Write-Debug "Repository directory - $PROJ_DIR"

#if ($venv) { CreateEnvironment }
#if ($load) { LoadEnvironment }
#if ($import) { ImportLibraries }

Write-Verbose "Execution finished"

#endregion