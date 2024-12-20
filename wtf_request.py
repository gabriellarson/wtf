import sys
import requests
import argparse

def send_to_ollama(command, output, user_input=None):
    prompt = f"""You are my windows powershell assistant. I will give you my last powershell command and it's output, and you will analyze it. There will be no opportunity for follow up.
command: {command}
output: {output}"""

    # Add user input to prompt if provided
    if user_input:
        prompt += f"\n additional instructions from user: {user_input}"

    try:
        response = requests.post('http://localhost:11434/api/generate', 
                               json={
                                   "model": "qwen2.5-coder:7b",
                                   "prompt": prompt,
                                   "stream": False
                               })
        
        if response.status_code == 200:
            print("")
            print("")
            print(response.json()['response'])
            print("")
            print("")
        else:
            print("Error: Unable to connect to Ollama server. Make sure it's running on localhost:11434")
    except Exception as e:
        print(f"Error connecting to Ollama: {str(e)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process PowerShell command and output')
    parser.add_argument('--cmd-file', required=True, help='File containing the last command')
    parser.add_argument('--output-file', required=True, help='File containing the command output')
    parser.add_argument('--user-input-file', help='File containing additional user input')
    
    args = parser.parse_args()
    
    try:
        # Read command and output
        with open(args.cmd_file, 'r', encoding='utf-8') as f:
            command = f.read().strip()
        with open(args.output_file, 'r', encoding='utf-8') as f:
            output = f.read().strip()
        
        # Read user input if provided
        user_input = None
        if args.user_input_file:
            with open(args.user_input_file, 'r', encoding='utf-8') as f:
                user_input = f.read().strip()
        
        send_to_ollama(command, output, user_input)
    except Exception as e:
        print(f"Error reading files: {str(e)}")