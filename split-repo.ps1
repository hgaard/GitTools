# from http://stackoverflow.com/questions/359424/detach-subdirectory-into-separate-git-repository/17864475#17864475

t turns out that this is such a common and useful practice that the overlords of git made it really easy, but you have to have a newer version of git (>= 1.7.11 May 2012). See the appendix for how to install the latest git. Also, there's a real-world example in the walkthrough below.

Prepare the old repo

pushd <big-repo>
git subtree split -P <name-of-folder> -b <name-of-new-branch>
popd
Note: <name-of-folder> must NOT contain leading or trailing characters. For instance, the folder named subproject MUST be passed as subproject, NOT ./subproject/

Create the new repo

mkdir <new-repo>
pushd <new-repo>

git init
git pull </path/to/big-repo> <name-of-new-branch>
Link the new repo to Github or wherever

git remote add origin <git@github.com:my-user/new-repo.git>
git push origin -u master
Cleanup, if desired

popd # get out of <new-repo>
pushd <big-repo>

git rm -rf <name-of-folder>
Note: This leaves all the historical references in the repository.See the Appendix below if you're actually concerned about having committed a password or you need to decreasing the file size of your .git folder.

...
