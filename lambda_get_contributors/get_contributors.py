import os
import json
from github import Github

def get_contributors_data(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    contributors_data_list = []

    # Repositório onde os contribuidores estão
    repo_name = "portal-iac-data"
    contributors_path = "contributors"

    try:
        repo = github.get_repo(repo_name)
        contributors_dir = repo.get_contents(contributors_path)

        for contributor_file in contributors_dir:
            if contributor_file.type == "file" and contributor_file.name.endswith(".json"):
                contributor_data = read_contributor_data(contributor_file)
                contributors_data_list.append(contributor_data)

    except Exception as e:
        print(f"Error reading contributors data from repo {repo_name}: {e}")

    return {
        "statusCode": 200,
        "body": json.dumps(contributors_data_list, indent=2, ensure_ascii=False)
    }

def read_contributor_data(contributor_file):
    contributor_data = {}
    try:
        data = contributor_file.decoded_content.decode("utf-8")
        contributor_data = json.loads(data)
    except Exception as e:
        print(f"Error reading contributor data for file {contributor_file.name}: {e}")
    return contributor_data
