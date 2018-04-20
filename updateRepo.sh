echo "Checking if repo needs to be updated"
export ORG="IBM-Swift"
export REPO="generator-swiftserver-projects"
export FILES="README.md foo.txt bar.txt"
export GH_REPO="github.com/${ORG}/${REPO}.git"
export BRANCH="init"
export projectName="generator-swiftserver-projects"

cd ${TRAVIS_BUILD_DIR}
mkdir current
cd current
git clone -b ${BRANCH} "https://github.com/${ORG}/${REPO}.git"
export currentProject=`pwd`

mkdir -p ../new/${projectName}
cd ../new/${projectName}
yo swiftserver --init --skip-build
cd ../
export newProject=`pwd`

if diff -x '.git' -r ${currentProject}/${projectName} ${newProject}/${projectName}
then
  echo "Project does not need to be updated"
  rm -rf ${currentProject}/${projectName} ${newProject}/${projectName}
  exit 1
fi

echo "Project needs to be updated"
cp -r ${newProject}/${projectName}/. ${currentProject}/${projectName}
git add $(git diff --name-only)
git commit -m "CRON JOB: Updating generated project"
git push origin ${BRANCH}