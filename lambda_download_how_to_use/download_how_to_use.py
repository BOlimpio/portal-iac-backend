import os
import json
import requests
from github import Github
import zipfile
import io
import base64

def download_how_to_use(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    
    repo_name = event["repo_name"]
    repo = github.get_repo(repo_name)
    
    try:
        contents = repo.get_contents("how-to-use")
        for content in contents:
            if content.type == "file":
                url = content.download_url
                file_name = os.path.join("/tmp", content.name)
                response = requests.get(url)
                if response.status_code == 200:
                    with open(file_name, "wb") as file:
                        file.write(response.content)
                    print(f"Downloaded: {content.name}")
                    
                    # Zip the downloaded file
                    zip_buffer = io.BytesIO()
                    with zipfile.ZipFile(zip_buffer, 'w') as zipf:
                        zipf.write(file_name, os.path.basename(file_name))
                    
                    # Return the zip file as base64-encoded content
                    zip_content = zip_buffer.getvalue()
                    return {
                        "statusCode": 200,
                        "body": {
                            "message": "Downloaded how-to-use files",
                            "file_name": content.name,
                            "zip_content": base64.b64encode(zip_content).decode('utf-8')
                        }
                    }
    except Exception as e:
        print(f"Error downloading files from repo {repo.name}: {e}")
    
    return {
        "statusCode": 200,
        "body": "No files downloaded"
    }