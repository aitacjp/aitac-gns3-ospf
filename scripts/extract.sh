#!/bin/sh

. ./configs.txt

cp -R $WORKDIR/* $PROJECT_DIR

for i in $(find $PROJECT_DIR -maxdepth 1 -type d | tail -n +2)
do
        if [ -s $i/images.conf ]; then
                for j in $i/project-files/qemu/*
                do
			qemu-img create -b $IMGDIR/$FRRIMAGE -f qcow2 $j/hda_disk.qcow2
                        sleep 1
                        qemu-nbd -c /dev/nbd0 $j/hda_disk.qcow2
                        sleep 1
                        mount /dev/nbd0p2 /mnt
                        cp $j/frr.conf /mnt/etc/frr/
                        umount /mnt
                        sleep 1
                        killall qemu-nbd
                done
        fi
done
