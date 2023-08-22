import os
import json
import requests
from github import Github

def download_how_to_use_files(event, context):
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
    except Exception as e:
        print(f"Error downloading files from repo {repo.name}: {e}")
    
    return {
        "statusCode": 200,
        "body": "Downloaded how-to-use files"
    }
