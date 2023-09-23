import os
import json
from github import Github

def count_files_in_folder(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    
    # Nome do repositório que contém os dados
    repo_name = "BOlimpio/portal-iac-data"
    # Nomes das pastas onde os arquivos estão localizados
    folders = ["contributors", "blogs-post"]
    
    try:
        # Inicializa um dicionário para armazenar o número de arquivos em cada pasta
        folder_counts = {}
        
        # Obtém o conteúdo das pastas do repositório
        repo = github.get_repo(repo_name)
        
        for folder_name in folders:
            contents = repo.get_contents(folder_name)
            # Inicializa um contador para a pasta atual
            count = 0
            # Itera sobre os arquivos na pasta
            for content in contents:
                if content.type == "file":
                    count += 1
            # Armazena o número de arquivos na pasta atual
            folder_counts[folder_name] = count
        
        # Retorna o número de arquivos em cada pasta como resposta
        return {
            "statusCode": 200,
            "body": json.dumps(folder_counts, indent=2, ensure_ascii=False)
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Erro ao contar os arquivos: {str(e)}"
        }
