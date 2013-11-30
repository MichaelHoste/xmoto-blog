#!/bin/bash
rsync -ru _site/* deploy@xmoto.io:/home/deploy/apps/xmoto --delete
rsync -ru data/* deploy@xmoto.io:/home/deploy/apps/xmoto/data --delete
ssh deploy@xmoto.io 'chmod -R +r /home/deploy/apps/xmoto'
