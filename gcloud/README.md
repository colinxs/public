1. create instance
2. N2D, 8 cpu, 4gb rm
3. 32 gb disk, ubuntu 21.04
4. run main.sh
5. Add ssh keys
<!-- ``` -->
<!-- echo '-----BEGIN OPENSSH PRIVATE KEY----- -->
<!-- -----END OPENSSH PRIVATE KEY-----' > ~/.ssh/id_ed25519 && \ -->
<!-- chmod 600 ~/.ssh/id_ed25519 && \ -->
<!-- echo 'KEY_HERE' > ~/.ssh/id_ed25519.pub && \ -->
<!-- chmod 644 ~/.ssh/id_ed25519.pub -->
<!-- ``` -->
```
echo 'KEY_HERE' >> ~/.config/nix/nix.conf
```
6. Run
```
MACHINE=gcloud nix run 'github:colinxs/bigdata#main' --option tarball-ttl 0 -- -- -d
```
