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
    
    repo_name = event.get('queryStringParameters', {}).get('repo_name')
    if repo_name is None:
        return {
            "statusCode": 400,
            "body": "O parâmetro 'repo_name' não foi fornecido na solicitação."
        }
    
    try:
        repo = github.get_repo(repo_name)
        zip_file_name = repo_name.split("/")[-1] + "-how-to-use.zip" if repo_name else None
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
                            "message": f"Downloaded '{zip_file_name}' files",
                            "file_name": zip_file_name,
                            "zip_content": base64.b64encode(zip_content).decode('utf-8')
                        }
                    }
    except github.UnknownObjectException:
        return {
            "statusCode": 404,
            "body": f"O repositório '{repo_name}' não foi encontrado no GitHub."
        }
    except requests.exceptions.RequestException as e:
        return {
            "statusCode": 500,
            "body": f"Erro ao baixar arquivos: {str(e)}"
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Erro inesperado: {str(e)}"
        }
    
    return {
        "statusCode": 200,
        "body": "No files downloaded"
    }