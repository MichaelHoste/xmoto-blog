#!/bin/bash
rsync -ru _site/* deploy@xmoto.io:/home/deploy/apps/xmoto --delete
