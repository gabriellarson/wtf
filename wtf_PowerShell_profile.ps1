# Variables to store command history
$script:lastCommand = ""
$script:lastOutput = ""

function prompt {
    # Return the prompt string
    return "PS " + (Get-Location) + "> "
}

function wtf {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$UserInput
    )
    
    # Get the last command from history
    $lastCommand = Get-History -Count 1 | Select-Object -ExpandProperty CommandLine
    
    if ($lastCommand -and $lastCommand.Trim() -ne "") {
        # Create temp files for command and output
        $tempDir = [System.IO.Path]::GetTempPath()
        $cmdFile = Join-Path $tempDir "wtf_last_command.txt"
        $outputFile = Join-Path $tempDir "wtf_last_output.txt"
        $userInputFile = Join-Path $tempDir "wtf_user_input.txt"
        
        try {
            # Create a script block that captures both output streams
            $scriptBlock = [ScriptBlock]::Create($lastCommand)
            
            # Capture output and error streams
            $outputBuilder = New-Object System.Text.StringBuilder
            
            try {
                # Run the command and capture all streams
                $result = & $scriptBlock 2>&1
                
                # Process each output item
                foreach ($item in $result) {
                    if ($item -is [System.Management.Automation.ErrorRecord]) {
                        [void]$outputBuilder.AppendLine($item.Exception.Message)
                    } elseif ($item -is [System.Management.Automation.WarningRecord]) {
                        [void]$outputBuilder.AppendLine($item.Message)
                    } else {
                        [void]$outputBuilder.AppendLine($item.ToString())
                    }
                }
            } catch {
                [void]$outputBuilder.AppendLine($_.Exception.Message)
            }
            
            $output = $outputBuilder.ToString()
            if ([string]::IsNullOrWhiteSpace($output)) {
                $output = "Command completed with no output."
            }
            
            # Save command and output to files
            $lastCommand | Out-File -FilePath $cmdFile -Encoding utf8
            $output | Out-File -FilePath $outputFile -Encoding utf8
            
            # Save user input if provided
            $userInputStr = $UserInput -join " "
            if ($userInputStr) {
                $userInputStr | Out-File -FilePath $userInputFile -Encoding utf8
            }
            
            # Call Python script with file paths
            $pythonArgs = @(
                "--cmd-file", $cmdFile,
                "--output-file", $outputFile
            )
            if ($userInputStr) {
                $pythonArgs += @("--user-input-file", $userInputFile)
            }
            
            & python C:\Users\Gabe\CustomCommands\wtf_request.py @pythonArgs
        }
        finally {
            # Clean up temp files
            Remove-Item $cmdFile -ErrorAction SilentlyContinue
            Remove-Item $outputFile -ErrorAction SilentlyContinue
            Remove-Item $userInputFile -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "No previous command found."
    }
}