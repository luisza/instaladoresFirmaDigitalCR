#!/usr/bin/bash

#
# Muestras las dependencias necesarias para el paquete a construir
# según los programas instalados en la computadora
# Modo de ejecución
#     bash pkg_search.sh
#
# Si se desea instalar antes las dependencias hacer 
# sudo bash pkg_search.sh -i 

DEPS=(pcscd libpcsc-perl libasedrive-usb pcsc-tools libacsccid1 libccid libacr38u)

function install_deps {
    for i in ${DEPS[@]}; do
        apt-get install -y $i
    done
}

function search_pkg {
    for i in ${DEPS[@]}; do
        if [ ${DEPS[${#DEPS[@]}-1]} == $i ]; then # check the last and remove comma
            dpkg-query -l | grep $i | awk '{printf "%s (>= %s)", $2, $3}'
        else
            dpkg-query -l | grep $i | awk '{printf "%s (>= %s), ", $2, $3}'
        fi
    done
}

if [ "-i" == "$1" ]; then
     install_deps
fi

search_pkg


echo ""
