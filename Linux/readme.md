Scripts
=========

Usage: `source script-name.sh`  
OR `curl -L https://github.com/Kajal4414/Scripts/Linux/raw/master/script-name.sh | bash`

Bunch of homemade bash scripts which I often use to make my life easier :)  
Feel free to fork it for your own use, and I'm open to PRs if you'd like to improve something or fix issues!

* `build-rom.sh`: Builds any android ROM for any device, and uploads it to transfer.sh

* `ubuntu-setup.sh`: Sets up an Ubuntu 18.04+ server or PC for android builds

* `merge-aosp-tag.sh`: Merges the specified AOSP tag in a ROM source in all repos that are not tracked directly from AOSP

* `merge-caf-tag.sh`: Merges the specified CAF tag in a ROM source in all repos that are not tracked directly from CAF

* `jenkins-setup-gce.sh`: Set up jenkins at port 80 (HTTP port) in a GCE instance running Ubuntu

* `merge-aosp-tag-legacy.sh`: Merge specified AOSP tag in [AOSP-LEGACY](https://github.com/AOSP-LEGACY) ROM source; enhanced version of `merge-aosp-tag.sh`

* `merge-aosp-tag-arrow.sh`: Merge specified AOSP tag in [ArrowOS](https://github.com/ArrowOS) ROM source; enhanced version of `merge-aosp-tag.sh`

* `merge-caf-tag-ginkgo.sh`: Merge specified CAF QSSI or vendor tag in [caf-ginkgo](https://github.com/caf-ginkgo) ROM source; enhanced rewritten version of `merge-caf-tag.sh`. Also automatically pushes succesfully merged repos.
