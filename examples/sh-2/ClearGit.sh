#!/usr/bin/env
# Now 466
# git verify-pack -v .git/objects/pack/pack-*.idx | sort -k 3 -g | tail -10
# git rev-list --objects --all | grep <大文件id>



# Largest File Top 5
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch 7b4400a5f3537f07f0a0198dd3e628198b18638a' --prune-empty --tag-name-filter cat -- --all
git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch big-file.jar' --prune-empty --tag-name-filter cat -- --all
git push origin master --force 	# Force Push to Repo
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now # Clear File
git gc --aggressive --prune=now
# git filter-branch --force --index-filter \
#   'git rm --cached --ignore-unmatch <无用的大文件>' \
#   --prune-empty --tag-name-filter cat -- --all
