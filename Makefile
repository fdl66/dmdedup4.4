obj-m += dm-dedup.o
PWD=/home/dear/code/xm/dmdedup-master
dm-dedup-objs := dm-dedup-cbt.o dm-dedup-hash.o dm-dedup-ram.o  dm-dedup-rw.o dm-dedup-target.o
KERNEL_SRC := /usr/src/linux-headers-4.4.0-70
EXTRA_CFLAGS := -I ${KERNEL_SRC}/drivers/md -w

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	modprobe dm_persistent_data
	insmod dm-dedup.ko
	dmesg -c >> dmdedup.log
	./dmdedup.sh
	#dmesg -c >> dmdedup.log
	#mkfs.ext4 /dev/mapper/mydedup
	#dmesg -c >> dmdedup.log
	#mount /dev/mapper/mydedup /mnt
	#dmesg -c >> dmdedup.log
	#sync /dev/mapper/mydedup
	#dmesg -c >> dmdedup.log

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -rf dmdedup.log
	rmmod dm-dedup
	#umount /mnt
	dmsetup remove mydedup
