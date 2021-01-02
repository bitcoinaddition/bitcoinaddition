#!/bin/bash
echo -e "\033[0;32mHow many CPU cores do you want to be used in compiling process? (Default is 1. Press enter for default.)\033[0m"
read -e CPU_CORES
if [ -z "$CPU_CORES" ]
then
	CPU_CORES=1
fi

# Clone BTCA code from BTCA official Github repository
	git clone https://github.com/btcacoin-com/BTCA

# Entering BTCA directory
	cd BTCA

# Compile dependencies
	cd depends
	make -j$(echo $CPU_CORES) HOST=x86_64-apple-darwin17 
	cd ..

# Compile BTCA
	./autogen.sh
	./configure --prefix=$(pwd)/depends/x86_64-apple-darwin17 --enable-cxx --enable-static --disable-shared --disable-debug --disable-tests --disable-bench
	make -j$(echo $CPU_CORES) HOST=x86_64-apple-darwin17
	make deploy
	cd ..

# Create zip file of binaries
	cp BTCA/src/btcad BTCA/src/btca-cli BTCA/src/btca-tx BTCA/src/qt/btca-qt BTCA/BTCA.dmg .
	zip BTCA-MacOS.zip btcad btca-cli btca-tx btca-qt BTCA.dmg
	rm -f btcad btca-cli btca-tx btca-qt BTCA.dmg
