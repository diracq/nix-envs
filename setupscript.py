from git import Repo

print("Hello from nix run python!")


repo_url = (
    "https://github.com/"
    "gitpython-developers/QuickStartTutorialFiles.git"
)

repo = Repo.clone_from(repo_url, "testrepo")
