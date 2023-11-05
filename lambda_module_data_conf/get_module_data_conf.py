import os
import json
from github import Github
import configparser

def get_module_data_conf(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    module_repositories = []
    user = github.get_user()
    for repo in user.get_repos():
        if repo.name.startswith("m-portal-"):
            module_repositories.append(repo)
    
    module_data_list = [read_module_data(repo) for repo in module_repositories]
    
    # Filtra os objetos vazios da lista
    module_data_list = [module_data for module_data in module_data_list if module_data]
    
    return {
        "statusCode": 200,
        "body": json.dumps(module_data_list, indent=2, ensure_ascii=False)
    }

def read_module_data(repo):
    module_data = {}
    try:
        content = repo.get_contents("module-data.conf")
        data = content.decoded_content.decode("utf-8")
        config = configparser.ConfigParser()
        config.read_string(data)
        
        if "module-info" in config:
            if config.get("module-info", "Portal", fallback="false").lower() == "true":
                module_data["title"] = config.get("module-info", "Titulo")
                module_data["description"] = config.get("module-info", "Descrição")
                module_data["status"] = config.get("module-info", "Status")
                module_data["cloudProvider"] = config.get("module-info", "Cloud Provider")
                module_data["version"] = config.get("module-info", "Versão")
                module_data["developers"] = config.get("module-info", "Desenvolvedores").split(";")
                module_data["github_link"] = f"https://github.com/{repo.owner.login}/{repo.name}"
    except Exception as e:
        print(f"Error reading module data for repo {repo.name}: {e}")
    
    # Retorna o objeto vazio apenas se todos os campos estiverem vazios
    return module_data if any(module_data.values()) else None