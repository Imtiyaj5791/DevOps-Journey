# Git Interview Notes - Part 1


## What is Git? Why do we use Git?

Git is a version control system. It is used to manage source code and track code changes in the local repository. It also helps multiple developers work on the same project.


---

## What do you mean by Version Control System?

Version Control System is used to track and manage changes in source code. It also allows multiple developers to work on the same project without overwriting each other's changes.


---

## What is the difference between Git and GitHub?

Git is a version control system which is used to manage and track source code changes locally.

GitHub is a cloud-based platform where we store Git repositories remotely. It is used to push, pull and collaborate with other developers.


---

## What is a Repository?

A repository is a directory that stores the project source code, project files and the complete version history of the project.


---

## What is the difference between a Local Repository and a Remote Repository?

Local Repository stores the project source code and version history on the local system.

Remote Repository stores the project on a remote server like GitHub, so that multiple developers can access, share and collaborate on the same project.


---

## Explain the Git workflow.

First, the developer writes the code in the Working Directory.

Then he checks the changes using:

```bash
git status
```
After that, he adds the required files to the Staging Area using:

```
git add filename
```

Then he commits the changes using:
```
git commit -m "message"
```

Finally, he pushes the code to the remote repository using:

```
git push
```

## What is the Staging Area? Why do we use it?

Staging Area is a temporary area where we keep the required files before committing.

It allows us to select which files should be included in the next commit.

Example:

```
git add abc.txt
```
Only abc.txt will be added to the staging area.


---


## What is the difference between git fetch and git pull?

git fetch downloads the latest changes from the remote repository, but it does not merge them into the current branch.

Command:
```
git fetch
```

git pull first performs git fetch and then automatically merges the changes into the current branch.

Command:
```
git pull
```

git pull = fetch + merge


---

## What is the difference between git clone and git pull?

Git clone is used to copy the remote repository to the local machine.

Let's assume you are working on a project for the first time. In that case, you will use git clone to copy the repository from GitHub to your laptop.

Command:
```
git clone <repository-url>
```

After that, whenever you need the latest changes, you will use git pull.

Command:
```
git pull
```

---

## What is the difference between git merge and git rebase?

Both are used to merge changes from one branch to another branch.

Git merge works in a non-linear way and creates a merge commit, so the complete branch history is preserved.

Command:
```
git merge branch-name
```

Git rebase works in a linear way. It moves the commits on top of the target branch and creates a clean commit history without a merge commit.

Command:
```
git rebase branch-name
```

---

## What is the difference between git add . and git add <filename>?

git add . adds all modified and new files from the current directory to the staging area.

Command:
```
git add .
```

git add <filename> adds only the specified file.

Command:
```
git add filename
```

Example:

git add abc.txt


In production, I prefer git add <filename> because it gives better control and avoids adding unwanted files.


---

## What is a Git branch, and why do we use branches?

Git branch means providing multiple branches to work for you, like main branch, dev branch and feature branch.

Let assume client says that new feature needs to be added in the project.

First developer works on feature branch, then gets approval. After approval, they merge into the dev branch and finally for production merge into the main branch.

Command to create a branch:
```
git branch feature-branch
```

Command to switch branch:
```
git checkout feature-branch
```

---

## What is a Merge Conflict? When does it occur, and how do you resolve it?

Merge conflict means multiple users are working on the same file or same lines of code.

Git cannot merge the changes automatically.

For resolving it, we open the conflicted file, review the changes, keep the correct code, then run:

git add filename


After that:

git commit


to complete the merge.


---

## What is git stash?

Git stash means saving your temporary work.

Let assume you have worked on a file but suddenly you need to change the branch to work on a different branch.

Your data will be saved in the stash area, and you can switch to another branch and complete your work.

Once you come back to your previous branch, you can start your work from where you left.

Command:
```
git stash
```

To restore the changes:
```
git stash pop
```

---

## What is the difference between git reset and git revert?

Git revert is used when we want to undo a commit that has already been pushed to the remote repository.

It creates a new commit and keeps the commit history.

Example:

Wrong Commit

        |
        v

Revert Commit (Undo Changes)


Git reset is mainly used to move back to a previous state.

Soft reset moves changes to the staging area, mixed reset moves changes to the working directory, and hard reset removes all local changes permanently.


---

#### Explain Git Soft Reset.

Let's assume I have a file abc.txt.

I added the file and committed it:
```
git add abc.txt

git commit -m "Added abc file"
```

Now I realize that I need to make some changes in the commit.

I will use:
```
git reset --soft HEAD~1
```

After soft reset:

- Commit will be removed.
- File will remain in the staging area.
- Code will not be deleted.

State:

Commit ❌

Staging Area ✅

Code ✅


If I do not make any changes in the file, I can directly commit again.

If I modify the file, then I need to add and commit again.

Example:
```
git add abc.txt

git commit -m "Fixed abc file"
```

---

#### Explain Git Mixed Reset.

Let's assume I have a file abc.txt.

I added the file and committed it:
```
git add abc.txt

git commit -m "Added abc file"
```

Now I realize that I need to make changes in the code.

I will use:
```
git reset --mixed HEAD~1
```

After mixed reset:

- Commit will be removed.
- File will be removed from the staging area.
- Code will remain safe.

State:

Commit ❌

Staging Area ❌

Code ✅


Now I need to add the file again before committing.

Example:
```
git add abc.txt

git commit -m "Fixed abc file"
```

---

#### Explain Git Hard Reset.

Let's assume I have a file abc.txt.

I added the file and committed it:

git add abc.txt

git commit -m "Added abc file"


Now I realize that the complete code is not required.

I don't want those changes anymore.

I will use:
```
git reset --hard HEAD~1
```

After hard reset:

- Commit will be removed.
- Staging area will be removed.
- Local code changes will also be removed.

State:

Commit ❌

Staging Area ❌

Code ❌


Hard reset should be used carefully because local changes can be lost permanently.


---

## What is .gitignore file? Why do we use it?

.gitignore file is used to tell Git which files or folders should not be tracked or pushed to the remote repository.

For example, we don't want to push sensitive information like passwords, secret keys, environment files or unnecessary files.

We mention those files inside .gitignore, and Git will ignore them during commit.


Example:

.env

password.txt


---

## What is Git Cherry-pick?

Git cherry-pick is used to take a specific commit from one branch and apply it to another branch.

For example, if a developer has fixed a critical bug in the feature branch, and we need only that particular fix in the production branch without merging the complete branch, then we use git cherry-pick.


Command:
```
git cherry-pick <commit-id>
```

---

## What is a Pull Request (PR)?

Pull Request is a request to merge changes from one branch to another branch.

For example, when a developer completes work on a feature branch, he creates a pull request to merge the changes into the develop or main branch.

Before merging, team members review the code and approve it.


---

## What is Branching Strategy?

In our project, we follow a Git Flow branching strategy.

We have mainly three branches:

- Feature branch
- Develop branch
- Main branch


When a new requirement comes from the client, the developer first creates a feature branch and works on that branch.

After completing the development, the developer creates a pull request.

After code review and approval, the changes are merged into the develop branch for testing.


Once testing is completed and everything is working fine, the changes are merged into the main branch and deployed to the production environment through the CI/CD pipeline.


For any urgent production issue, we create a hotfix branch from the main branch, fix the issue, then merge the changes back into the main branch.

After that, we also merge the same changes into the develop branch to keep both branches in sync.


---


