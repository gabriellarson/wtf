# wtf
A PowerShell utility that helps you understand what just happened with your last command. When things go wrong (or right!), just type wtf and get an AI-powered analysis of your last command and its output.

This tool integrates with Ollama to provide intelligent analysis of PowerShell commands and their results, helping you debug issues, understand errors, or get insights about command output.

<div align="center">
 <img alt="demo" height="390px" src="https://github.com/gabriellarson/wtf/blob/main/demo.JPG">
</div>

# Usage

Run any PowerShell command:

```python script.py```


Then if you want to understand what happened, just type:

```wtf```


You can also ask specific questions:

```wtf why did this error occur?```

```wtf how can I fix this?```

```wtf explain the output```


# Requirements
Ollama running locally: https://github.com/ollama/ollama


# Installation

Copy the PowerShell profile script to your PowerShell profile location ($PROFILE)

Place wtf_request.py in C:\Users\YourUsername\CustomCommands\ (or place it anywhere you like and edit the PowerShell profile accordingly)

Ensure Ollama is running. Port 11434 and model qwen2.5-coder:7b are selected by default in wtf_request.py

Restart PowerShell

Now you can use wtf to analyze any command output!
