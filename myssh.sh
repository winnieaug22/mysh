#!/bin/bash
echo "ssh-keygen -t ed25519 -C \"s149Tgithub\""
echo
echo "eval \"\$(ssh-agent -s)\""
echo "ssh-add ~/.ssh/id_ed25519_s149Tgithub"
