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
    
    num_modules_in_progress_aws = 0
    num_modules_done_aws = 0
    num_modules_in_progress_azure = 0
    num_modules_done_azure = 0

    for repo in module_repositories:
        module_status = get_module_status(repo)
        cloud_provider = get_cloud_provider(repo)
        if module_status == "InProgress":
            if cloud_provider == "AWS":
                num_modules_in_progress_aws += 1
            elif cloud_provider == "Azure":
                num_modules_in_progress_azure += 1
        elif module_status == "Done":
            if cloud_provider == "AWS":
                num_modules_done_aws += 1
            elif cloud_provider == "Azure":
                num_modules_done_azure += 1

    # Formata os números de módulos em progresso e prontos por provedor de nuvem
    result = {
        "modules_in_progress_aws": num_modules_in_progress_aws,
        "modules_done_aws": num_modules_done_aws,
        "modules_in_progress_azure": num_modules_in_progress_azure,
        "modules_done_azure": num_modules_done_azure
    }

    return {
        "statusCode": 200,
        "body": json.dumps(result, indent=2, ensure_ascii=False)
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

def get_cloud_provider(repo):
    try:
        content = repo.get_contents("module-data.conf")
        data = content.decoded_content.decode("utf-8")
        config = configparser.ConfigParser()
        config.read_string(data)
        
        if "module-info" in config:
            return config.get("module-info", "Cloud Provider", fallback="Unknown")
    except Exception as e:
        print(f"Error reading module data for repo {repo.name}: {e}")
    return "Unknown"
