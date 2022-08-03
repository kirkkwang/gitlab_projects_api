## Summary
This is a very basic imperative Ruby script to interact with the Gitlab API.  What it should do is:
- Given a Group ID (default is the Notch8 group)
- Given a token (assuming the correct permissions)
- Output the name, visibility, and members of each project in the terminal

## Instructions

- Make sure Ruby (I used 2.7.5 but anything 2.3.0 or higher should work)
- Clone down this repo with:
```shell
git clone https://github.com/kirkkwang/gitlab_projects_api.git
cd gitlab_projects_api
```
- Open `gitlab_projects_api.rb` and set the `token` variable with your token from Gitlab. (Make sure to put the token in between the `''`)
  - https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
- Run the script with:
```shell
ruby gitlab_projects_api.rb
```
Hope this is what you need!