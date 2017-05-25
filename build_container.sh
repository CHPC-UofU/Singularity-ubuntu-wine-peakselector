prg=wine_peakselector
rm -f ubuntu_${prg}.img
sudo singularity create --size 2500 ubuntu_${prg}.img
sudo singularity bootstrap ubuntu_${prg}.img Singularity
