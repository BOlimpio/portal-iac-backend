import os
import json
from github import Github

def get_blog_posts(event, context):
    github_token = os.environ["GITHUB_TOKEN"]
    github = Github(github_token)
    
    # Nome do repositório que contém os dados dos blogs
    repo_name = "portal-iac-data"
    # Caminho para a pasta de blogs dentro do repositório
    blogs_folder = "blogs-post"
    
    try:
        # Obtém o conteúdo da pasta de blogs do repositório
        repo = github.get_repo(repo_name)
        contents = repo.get_contents(blogs_folder)
        
        # Inicializa uma lista para armazenar os dados dos blogs
        blog_posts = []
        
        # Itera sobre os arquivos na pasta de blogs
        for content in contents:
            if content.type == "file" and content.name.endswith(".json"):
                # Lê o conteúdo do arquivo JSON
                data = json.loads(content.decoded_content.decode("utf-8"))
                blog_posts.append(data)
        
        # Retorna a lista de blogs como resposta
        return {
            "statusCode": 200,
            "body": json.dumps(blog_posts, indent=2, ensure_ascii=False)
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Erro ao obter os blogs: {str(e)}"
        }
