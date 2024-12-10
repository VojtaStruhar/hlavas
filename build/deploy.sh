
echo "Deploying to games.vojtechstruhar.com"

rsync -avz \
    -e "ssh -i $HOME/.ssh/hetzner_first" \
    --delete \
    web/ \
    root@vojtechstruhar.com:/var/www/web-games/hlavas
