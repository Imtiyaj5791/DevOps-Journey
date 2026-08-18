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

# Git Additional Scenario-Based Interview Questions

## 1. You accidentally committed a password or secret key to Git. What will you do?

First, I will remove the secret from the code and immediately **rotate or revoke the exposed credential** because once a secret is committed, we should consider it compromised.

Then I will move the secret to a secure location such as environment variables or a secret management solution.

I will also add the sensitive file to `.gitignore` to avoid committing it again.

Example:

```text
.env
password.txt
```

Important:

`.gitignore` only prevents untracked files from being added in future.

If the secret is already committed or pushed, adding it to `.gitignore` will **not remove it from Git history**.

For removing sensitive data from repository history, I will follow the organization's approved process and coordinate with the repository/admin team if required.

### Interview Answer

If I accidentally commit a password or secret, first I will rotate or revoke the exposed credential.

Then I will remove the secret from the code and store it securely.

I will also add the sensitive file to `.gitignore` so that it is not committed again.

If it is already pushed to the remote repository, I will follow the approved process to remove it from Git history.

---

## 2. You committed changes to the wrong branch. How will you move the commit to the correct branch?

First, I will identify the commit ID.

```bash
git log
```

Then I will switch to the correct branch.

```bash
git checkout <correct-branch>
```

I will apply that specific commit using:

```bash
git cherry-pick <commit-id>
```

After verifying the changes, I can push the correct branch.

```bash
git push
```

Then I will safely remove/undo the wrong commit from the original branch based on whether it has already been pushed.

### Interview Answer

If I commit the changes to the wrong branch, first I will identify the commit ID using `git log`.

Then I will switch to the correct branch and use `git cherry-pick` to apply that specific commit.

After that, I will verify and push the changes.

```text
Wrong Branch Commit
       ↓
Get Commit ID
       ↓
Switch Correct Branch
       ↓
git cherry-pick <commit-id>
       ↓
Verify
       ↓
Push
```

---

## 3. Your local branch is behind the remote branch and git push is rejected. What will you do?

First, I will check the current branch and status.

```bash
git status
```

Then I will get the latest changes from the remote repository.

```bash
git pull
```

If there is a merge conflict, I will resolve the conflict, add the resolved files and complete the merge.

```bash
git add <filename>
git commit
```

After verifying everything, I will push my changes again.

```bash
git push
```

### Interview Answer

If my push is rejected because my local branch is behind the remote branch, first I will pull the latest changes.

If there is any conflict, I will resolve it and verify the code.

After that, I will push my changes again.

```text
Push Rejected
     ↓
git pull
     ↓
Resolve Conflict if any
     ↓
Verify
     ↓
git push
```

---

## 4. A bad commit has already been pushed to the main branch. How will you safely undo it?

If the commit is already pushed to the shared or main branch, I will prefer **git revert** instead of git reset.

First, I will identify the bad commit.

```bash
git log
```

Then I will revert that commit.

```bash
git revert <commit-id>
```

Git revert creates a **new commit that reverses the changes** from the bad commit.

Then I will verify and push the revert commit.

```bash
git push
```

### Interview Answer

If a bad commit is already pushed to the main branch, I will use `git revert`.

I will identify the commit ID and revert it.

Git revert creates a new commit to undo the changes without deleting the existing commit history, so it is safer for a shared branch.

```text
Bad Commit Already Pushed
        ↓
git log
        ↓
git revert <commit-id>
        ↓
Verify
        ↓
git push
```

---

## 5. Developer says, "My code is missing after pull or merge." How will you investigate?

First, I will check the current branch and working directory status.

```bash
git status
```

Then I will verify which branch the developer is currently using.

```bash
git branch
```

After that, I will check the commit history.

```bash
git log
```

If required, I will check Git reflog.

```bash
git reflog
```

`git reflog` helps us check recent Git activities such as commits, resets, checkouts and branch movements in the local repository.

Based on the history, I will identify where the changes were present and take the required recovery action.

### Interview Answer

First, I will check `git status` and verify the current branch.

Then I will check `git log` to find the commit history.

If I still cannot find the changes, I will use `git reflog` to check recent local Git activities and identify where the changes were lost.

```text
Code Missing
    ↓
git status
    ↓
Check Branch
    ↓
git log
    ↓
git reflog
    ↓
Identify Changes
```

---

## 6. What is git log and how do you check commit history?

`git log` is used to check the commit history of a Git repository.

Command:

```bash
git log
```

It provides information such as:

- Commit ID
- Author
- Date
- Commit message

For a shorter view, we can use:

```bash
git log --oneline
```

Example:

```text
a1b2c3d Fix login issue
d4e5f6g Update configuration
h7i8j9k Initial commit
```

### Interview Answer

`git log` is used to check the commit history.

It shows details like commit ID, author, date and commit message.

For a short and simple history, I can use:

```bash
git log --oneline
```

---

# Quick Revision

```text
Secret Committed
→ Rotate/Revoke → Remove Secret → Secure Storage → .gitignore

Commit on Wrong Branch
→ git log → Correct Branch → cherry-pick → Verify

Push Rejected
→ git pull → Resolve Conflict → Verify → git push

Bad Commit Already Pushed
→ git log → git revert → Verify → git push

Code Missing
→ git status → Branch → git log → git reflog

Commit History
→ git log / git log --oneline
```

---


