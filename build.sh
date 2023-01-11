## starting of script

color='\033[0;32m'
color2='\033[0;31m'
nc='\033[0m'

echo -e "${color}Starting environment setup${nc}"
PATH=~/bin:$PATH
source build/envsetup.sh
CCACHE_DIR='/mnt/ccache'
if [ ! -d /mnt/ccache ]
then
sudo mkdir ${CCACHE_DIR}
fi
if [ ! -f /mnt/ccache/ccache.conf ]
then
sudo mount --bind /home/jabiyeff/.ccache ${CCACHE_DIR}
fi
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=${CCACHE_DIR}
sleep 1

echo -e "${color}Updating local manifests${nc}"
cd .repo/local_manifests
git pull --rebase
croot
sleep 1

case $1 in
    "-s"|--sync )
        echo -e "${color2}Syncing sources for test build${nc}"
        repo sync -j$(nproc --all) -c --force-sync --no-clone-bundle --no-tags
        rm -rf kernel/xiaomi/msm8937 ;;
    "-sd"|--sync-device )
        echo -e "${color2}Syncing device sources${nc}"
        repo sync --force-sync android_device_xiaomi_spes android_vendor_xiaomi_spes ;;
    "-n"|--nosync )
        echo -e "${color}Sync abandoned${nc}" ;;
esac
sleep 1

source build/envsetup.sh
sleep 1

#detect crdroid version based on common.mk
croot
cr_check=$(grep -n "CR_VERSION" vendor/lineage/config/version.mk | grep -Eo '^[^:]+')
array=( $cr_check )
crDroid=$(sed -n ${array[0]}'p' < vendor/lineage/config/version.mk | cut -d "=" -f 2 | tr -d '[:space:]')

## Upload files configs ##
device=spes
android=13.0
BuildID="crDroidAndroid-"$android"-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')"-"$device"-v"$crDroid".zip"
BuildID2="crDroidAndroid-"$android"-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')"-"$device"-GMS-v"$crDroid".zip"
BuildID3="crDroidAndroid-"$android"-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')"-"$device"-v"$crDroid"-2.zip"

case $2 in
    "-ce" )
        echo -e "${color}Prepare to start userdebug build${nc}"
        lunch lineage_spes-userdebug
        echo -e "${color}Prepare for clean build${nc}"
        rm -rf out
        echo -e "${color}Starting build${nc}"
        m bacon ;;
    "-de" )
        echo -e "${color}Prepare to start userdebug build${nc}"
        lunch lineage_spes-userdebug
        echo -e "${color}Prepare for dirty build${nc}"
        make installclean
        echo -e "${color}Starting build${nc}"
        m bacon ;;
    "-c" )
        echo -e "${color}Prepare to start build${nc}"
        lunch lineage_spes-user
        echo -e "${color}Prepare for clean build${nc}"
        rm -rf out
        echo -e "${color}Starting build${nc}"
        m bacon ;;
    "-d" )
        echo -e "${color}Prepare to start build${nc}"
        lunch lineage_spes-user
        echo -e "${color}Prepare for dirty build${nc}"
        make installclean
        echo -e "${color}Starting build${nc}"
        m bacon ;;
    "-cwb" )
        echo -e "${color}Prepare to start build${nc}"
        lunch lineage_spes-user
        echo -e "${color}Prepare for dirty build${nc}"
        rm -rf out ;;
    "-dwb" )
        echo -e "${color}Prepare to start build${nc}"
        lunch lineage_spes-user
        echo -e "${color}Prepare for dirty build${nc}"
        make installclean ;;
    "-w" )
        echo -e "${color}Starting build${nc}"
        m bacon ;;
esac

if [ -f out/target/product/$device/$BuildID ] || [ -f out/target/product/$device/$BuildID2 ]
then
case $3 in
    "-t2"|--upload-test2 )
        echo -e "${color}Upload test build from Sourceforge${nc}"
        mv out/target/product/$device/$BuildID2 out/target/product/$device/$BuildID3
        scp -i ~/ssh-key out/target/product/$device/$BuildID3 jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/test/ ;;
    "-t"|--upload-test )
        echo -e "${color}Upload test build from Sourceforge${nc}"
        scp -i ~/ssh-key out/target/product/$device/$BuildID jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/test/ ;;
    "-tr2"|--upload-r-test2 )
        echo -e "${color}Upload test build from Sourceforge${nc}"
        mv out/target/product/$device/$BuildID2 out/target/product/$device/$BuildID3
        scp -i ~/ssh-key out/target/product/$device/$BuildID3 jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/test/ ;;
    "-tg"|--upload-gapps )
        echo -e "${color}Upload test build (Non-Treble) from Sourceforge${nc}"
        scp -i ~/ssh-key out/target/product/$device/$BuildID2 jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/test/ ;;
    "-sr"|--upload-sf-release )
        echo -e "${color}Upload release build from my Sourceforge${nc}"
        scp -i ~/ssh-key out/target/product/$device/$BuildID jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/crDroid-Spes/ ;;
    "-rg"|--upload-release-gapps )
        echo -e "${color}Upload release build (Non-Treble) from my Sourceforge${nc}"
        mv out/target/product/$device/$BuildID out/target/product/$device/$BuildID2
        scp -i ~/ssh-key out/target/product/$device/$BuildID2 jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/crDroid/ ;;
    "-we"|--upload-we )
        echo -e "${color}Upload test build from Wetransfer${nc}"
        wepush out/target/product/$device/$BuildID ;;
    "-o"|--upload-osdn )
        echo -e "${color}Upload test build from OSDN${nc}"
        scp -i ~/ssh-key out/target/product/$device/$BuildID jabiyeff@storage.osdn.net:/storage/groups/j/ja/jabiyeff-build/ ;;
    "-r"|--upload-release )
        echo -e "${color}Upload release build from Sourceforge${nc}"
        mv out/target/product/$device/$BuildID2 out/target/product/$device/$BuildID
        curl --ssl -k -T out/target/product/$device/$BuildID ftp://upme.crdroid.net/files/spes/9.x/ --user uploader:uploader ;;
    "-v"|--vendor )
        echo -e "${color}Creating vendor zip and pushing Sourceforge${nc}"
        cd out/target/product/$device
        rm -rf vendortest
        unzip $BuildID -d vendortest
        cd vendortest
        rm -rf boot.img system.new.dat.br system.transfer.list system.patch.dat install
        sed -i "26d;27d;28d;29d;30d;31d;32d;33d;38d;39d;40d" META-INF/com/google/android/updater-script
        zip -r9 vendor-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip *
        scp -i ~/ssh-key vendor-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/test/
        croot ;;
    "-vw"|--vendor-wepush )
        echo -e "${color}Creating vendor zip and pushing Wetransfer${nc}"
        cd out/target/product/$device
        rm -rf vendortest
        unzip $BuildID -d vendortest
        cd vendortest
        rm -rf boot.img system.new.dat.br system.transfer.list system.patch.dat install
        sed -i "26d;27d;28d;29d;30d;31d;32d;33d;38d;39d;40d" META-INF/com/google/android/updater-script
        zip -r9 vendor-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip *
        wepush vendor-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip
        croot ;;
    "-vg"|--vendor-gsi )
        echo -e "${color}Creating vendor zip and pushing Sourceforge${nc}"
        cd out/target/product/$device
        rm -rf vendortest
        unzip $BuildID -d vendortest
        cd vendortest
        rm -rf system.new.dat.br system.transfer.list system.patch.dat install
        sed -i "4d;5d;6d;7d;8d;9d;10d;11d;12d;13d;14d;15d;17d;26d;27d;28d;29d;30d;31d;32d;33d;39d" META-INF/com/google/android/updater-script
        zip -r9 vendor-gsi-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip *
        scp -i ~/ssh-key vendor-gsi-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip jabiyeff@frs.sourceforge.net:/home/frs/project/jabiyeff-build/test/
        croot ;;
    "-vgw"|--vendor-gsi-wepush )
        echo -e "${color}Creating vendor zip and pushing Wetransfer${nc}"
        cd out/target/product/$device
        rm -rf vendortest
        unzip $BuildID -d vendortest
        cd vendortest
        rm -rf system.new.dat.br system.transfer.list system.patch.dat install
        sed -i "4d;5d;6d;7d;8d;9d;10d;11d;12d;13d;14d;15d;17d;26d;27d;28d;29d;30d;31d;32d;33d;39d" META-INF/com/google/android/updater-script
        zip -r9 vendor-gsi-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip *
        wepush vendor-gsi-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')".zip
        croot ;;
esac
else
echo -e "${color2}Failed to upload files${nc}"
fi

case $4 in
    "-p"|--poweroff )
        sudo shutdown -P +10 ;;
esac
