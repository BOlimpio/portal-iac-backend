import os
import json
import requests
from github import Github
import configparser

class PortalBackend:
    def __init__(self, github_token):
        self.github = Github(github_token)
        self.module_repositories = self.get_module_repositories()

    # Fetch GitHub Repositories with Prefix "m-portal-"
    def get_module_repositories(self):
        module_repositories = []
        user = self.github.get_user()
        for repo in user.get_repos():
            if repo.name.startswith("m-portal-"):
                module_repositories.append(repo)
        return module_repositories
    
     # Fetches and returns specific information for all modules in found repositories
    def get_module_data(self):
        module_data_list = []
        for repo in self.module_repositories:
            module_data = self.read_module_data(repo)
            module_data_list.append(module_data)
        return module_data_list
    
    # Read module-data.conf file from each repository
    def read_module_data(self, repo):
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
                    module_data["cloud_provider"] = config.get("module-info", "Cloud Provider")
                    module_data["version"] = config.get("module-info", "Versão")
                    module_data["developers"] = config.get("module-info", "Desenvolvedores").split(";")
        except Exception as e:
            print(f"Error reading module data for repo {repo.name}: {e}")
        return module_data
    
    # # Check for New Commits
    # def has_new_commits(self, repo, last_commit_count):
    #     current_commit_count = repo.get_commits().totalCount
    #     return current_commit_count > last_commit_count
    
    # Downloading files from the "how-to-use" folder
    def download_how_to_use_files(self, repo):
        try:
            contents = repo.get_contents("how-to-use")
            for content in contents:
                if content.type == "file":
                    url = content.download_url
                    file_name = os.path.join(content.name)
                    response = requests.get(url)
                    if response.status_code == 200:
                        with open(file_name, "wb") as file:
                            file.write(response.content)
                        print(f"Downloaded: {content.name}")
        except Exception as e:
            print(f"Error downloading files from repo {repo.name}: {e}")


# Main code
if __name__ == "__main__":
    config = configparser.ConfigParser()
    config.read("config.ini")
    github_token = config.get("github", "token")
    
    backend = PortalBackend(github_token)
    
    module_data_list = backend.get_module_data()
    print(json.dumps(module_data_list, indent=2, ensure_ascii=False))
    
    # for repo in backend.module_repositories:
    #     backend.download_how_to_use_files(repo, "/home/bruno/Documents/portal-iac/portal-iac-backend/")