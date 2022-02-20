#!/usr/bin/env bash

# [Git Hook] commit prefix 
# Commit 시 Branch 의 issue number를 자동으로 커밋 메세지에 삽입
# chmod 755 add-issue-to-commit.sh 명령으로 실행 권한 추가 필요

COMMIT_MSG_FILE=$1

org='mint-rare'
issue_repo_prefix='plan'

branch_name=`git rev-parse --abbrev-ref HEAD`
issue_number=`echo ${branch_name} | cut -f2 -d '/' | cut -f1 -d '_'`
first_line=`head -n1 ${COMMIT_MSG_FILE}`
number_re='^[0-9]+$'

echo Branch Name: $branch_name
echo Issue Number: $issue_number
echo First Line: $first_line

if [[ $issue_number =~ $number_re ]]; then
  sed -i.bak "s/${first_line}/[$org\/$issue_repo_prefix#$issue_number] $first_line/" $COMMIT_MSG_FILE
  exit 0
fi
