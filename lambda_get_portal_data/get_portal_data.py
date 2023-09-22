import os
import json
from github import Github

def get_data_from_folder(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    
    # Nome do repositório que contém os dados
    repo_name = "portal-iac-data"
    # Nome da pasta onde os arquivos JSON estão localizados (passado como parâmetro)
    folder_name = event.get('queryStringParameters', {}).get('folder_name')
    
    try:
        # Obtém o conteúdo da pasta do repositório
        repo = github.get_repo(repo_name)
        contents = repo.get_contents(folder_name)
        
        # Inicializa uma lista para armazenar os dados dos arquivos JSON
        data_list = []
        
        # Itera sobre os arquivos na pasta
        for content in contents:
            if content.type == "file" and content.name.endswith(".json"):
                # Lê o conteúdo do arquivo JSON
                data = read_data_from_file(content)
                data_list.append(data)
        
        # Retorna a lista de dados como resposta
        return {
            "statusCode": 200,
            "body": json.dumps(data_list, indent=2, ensure_ascii=False)
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Erro ao obter os dados: {str(e)}"
        }

def read_data_from_file(data_file):
    data = {}
    try:
        data_content = data_file.decoded_content.decode("utf-8")
        data = json.loads(data_content)
    except Exception as e:
        print(f"Error reading data from file {data_file.name}: {e}")
    return data
