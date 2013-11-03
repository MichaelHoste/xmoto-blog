#!/bin/bash
rsync -ru _site/* deploy@xmoto.io:/home/deploy/apps/xmoto --delete
ssh deploy@xmoto.io 'chmod -R +r /home/deploy/apps/xmoto'
