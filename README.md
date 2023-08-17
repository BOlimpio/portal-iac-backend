# Portal Backend Integration Script [IN PROGRESS :hourglass:]

This Python script facilitates the integration between the Portal IAC frontend and GitHub, allowing data retrieval, parsing, and file downloading from specific repositories. The script is designed to provide dynamic content display on the portal.

## Features

- Fetches GitHub repositories with the prefix "portal-"
- Retrieves specific information for all modules in found repositories
- Reads module data from the "module-data.conf" file in each repository
- Checks for new commits in repositories
- Downloads files from the "how-to-use" folder in repositories

## Prerequisites

- Python 3.x
- Required Python packages: `github`, `requests`

## Setup

1. Clone or download the script to your local machine.
2. Create a `config.ini` file in the same directory with the following content:

    ```ini
    [github]
    token = YOUR_GITHUB_TOKEN
    ```

3. Replace YOUR_GITHUB_TOKEN with your GitHub API token.

## Usage

1. Open a terminal and navigate to the script's directory.
2. Run the script using the following command:
    ```
    python github_integration.py
    ```
3. The script will fetch repository data, read module information, and download relevant files.

## Notes
- This script assumes that repositories follow the naming convention **"portal-"**.
- Ensure that the config.ini file is kept secure and not shared.

## Future Steps :rocket::rocket:
- As the Portal IAC project evolves, this integration script is planned to be further optimized and transformed into **AWS Lambda functions** for enhanced scalability and efficiency.