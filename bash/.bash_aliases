alias dc="docker-compose"
alias dcc="docker-compose"
alias startportainer="docker run --name portainer --privileged -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer"
alias chrome-insecure="'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --disable-web-security --user-data-dir=${HOME}/dev/chrome_data_dir --no-default-browser-check"
alias k="kubectl"
alias kpods="kubectl get pods"
alias mongosh-nonprod='mongosh "mongodb+srv://us-non-prod.mbaexz.mongodb.net/" --username paul_c'
alias mongosh-prod='mongosh "mongodb+srv://lt-cs.1wgmb.mongodb.net/" --username paul_mongosh'
alias mongosh-prod-a='mongosh "mongodb+srv://prod-a.1wgmb.mongodb.net/"  --username paul_mongosh'
alias mongosh-prod-ht='mongosh "mongodb+srv://ht-ncs.1wgmb.mongodb.net/"  --username paul_mongosh'

# gcloud GKE get-credentials: ALIAS  CLUSTER / REGION
alias kube-eu-prod='gcloud container clusters get-credentials "eu-prod-gke-cluster" --location "europe-west1" --project gstore-production'
alias kube-us-prod='gcloud container clusters get-credentials "kalama-gke-cluster" --location "us-central1" --project gstore-production'
alias kube-eu-dev='gcloud container clusters get-credentials "kalama-dev-gke-eu-cluster" --location "europe-west1" --project gstore-development'
alias kube-us-dev='gcloud container clusters get-credentials "kalama-dev-gke-cluster" --location "us-central1" --project gstore-development'
alias kube-eu-nonprod='gcloud container clusters get-credentials "eu-west1-non-prod" --location "europe-west1" --project gstore-development'
alias kube-us-nonprod='gcloud container clusters get-credentials "us-central1-non-prod" --location "us-central1" --project gstore-development'
alias casstunnelstage="ssh -A -L 9042:10.0.11.98:9042 -L 9160:10.0.11.98:9160 -L 9142:10.0.11.98:9142 ec2-3-223-136-203.compute-1.amazonaws.com"
# homebrew vim on macOS only; this file is shared with linux
[[ -x /opt/homebrew/bin/vim ]] && alias vi="/opt/homebrew/bin/vim"
alias ecr-login-stage="AWS_PROFILE=awsaml-606696011804 aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 606696011804.dkr.ecr.us-east-1.amazonaws.com"
alias pivnc-forward="ssh -L 5900:localhost:5901  pi@10.18.1.13"
alias pivnc="echo 'be sure to port forward with pivnc-forward'; open vnc://10.18.1.13:5900"
alias k8sproxy="kubectl run --restart=Never --image=alpine/socat temp-paul -- -d -d tcp-listen:5432,fork,reuseaddr tcp-connect:172.20.64.93:5432"
alias activate-nvm=". $NVM_DIR/nvm.sh"
alias git-gone="git branch -vv | grep \": gone]\" | awk '{ print $1 }' | xargs -n 1 git branch -D"

#####
alias set-cdn-key-qa='export FLOORPLAN_API_KEY=$(gcloud secrets versions access latest --secret floorplan-map-development-api-keys --project gstore-development)'
alias set-cdn-server-qa='export FLOORPLAN_SERVER="https://floorplan-map-development-wyvzevyrta-uc.a.run.app"'
