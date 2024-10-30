import os
from huggingface_hub import InferenceClient

# Initialize the client with your API key from environment variable
api_key = os.getenv("HUGGINGFACE_API_KEY")

client = InferenceClient(api_key=api_key)
# Provide a prompt asking for a Linux command
mess = input("myshell_NLP>")
messages = [
    { 
        "role": "user", 
        "content": f"Please convert this instruction to a Linux command: '{mess}'. Do not include any explanations." 
    }
]


# Generate the response with the model, streaming the output for real-time results
stream = client.chat.completions.create(
    model="meta-llama/Llama-3.2-3B-Instruct", 
    messages=messages, 
    max_tokens=100,  # Adjust as needed
    stream=True
)

# Collect each chunk of the response
# Collect each chunk of the response
output = ""


for chunk in stream:
    # print(chunk)
    content = chunk.choices[0].delta.content
    output+=content

# Write the final command to nlp_response.txt
with open("nlp_response.txt", "w") as file:
    file.write(output.strip())  # Strip any leading/trailing whitespace
# Update the last chunk processed
