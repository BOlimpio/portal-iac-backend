import os
import json
from github import Github
import configparser

def get_number_of_modules(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    module_repositories = []
    user = github.get_user()
    for repo in user.get_repos():
        if repo.name.startswith("m-portal-"):
            module_repositories.append(repo)
    
    num_modules_in_progress = 0
    num_modules_done = 0

    for repo in module_repositories:
        module_status = get_module_status(repo)
        if module_status == "InProgress":
            num_modules_in_progress += 1
        elif module_status == "Done":
            num_modules_done += 1

    return {
        "statusCode": 200,
        "body": json.dumps({
            "num_modules_in_progress": num_modules_in_progress,
            "num_modules_done": num_modules_done
        })
    }

def get_module_status(repo):
    try:
        content = repo.get_contents("module-data.conf")
        data = content.decoded_content.decode("utf-8")
        config = configparser.ConfigParser()
        config.read_string(data)
        
        if "module-info" in config:
            if config.get("module-info", "Portal", fallback="false").lower() == "true":
                return config.get("module-info", "Status")
    except Exception as e:
        print(f"Error reading module data for repo {repo.name}: {e}")
    return None
