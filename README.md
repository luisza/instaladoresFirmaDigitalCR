# Instaladores para Firma Digital Costa Rica
Este repositorio pretende crear instaladores para gran parte de las distribuciones de GNU/Linux, además intentará incluir soluciones a problemas comunes a la hora de firmar o autenticar con instituciones del estado.

**NOTA:** Este repositorio no es oficial y no guarda relación alguna con http://soportefirmadigital.com, ni ninguna dependencia del estado, es desarrollado por voluntarios que esperan un mejor soporte de firma digital en su distribución de GNU/Linux.

## ¿Qué hace este repositorio?

Crea instaladores para diferentes sistemas operativos como por ejemplo Debian y Ubuntu en sus diferentes versiones y en las arquitecturas x86 y x86_64.
Estos paquetes intentan solucionar el mayor número de problemas encontrados en los instaladores oficiales, así como simplificar el proceso de instalación, al construir paquetes .deb o .rmp para las más populares distribuciones.

## ¿Cúales versiones son soportadas ?

Debian
  - Estable
  - Testing
  - Sid
 
Ubuntu
  - Precise 12.04 LTS
  - Trusty 14.04 LTS
  - Xenial 16.04 LTS
  - Yakkety 16.10
  
## ¿Cuales distribuciones tienen planeado soportar ?

  - centOS 6
  - centOS 7 
  - Fedora 24
  - Fedora 25
  - OpenSuse 42.2
  - OpenSuse 42.3
  - OpenSuse 13.2
  - OpenSuse tumbleweed
  
**NOTA:** Algunas versiones de distribuciones no soportan x86 

## ¿Dónde puedo encontrar los paquetes creados ?

Puede encontrarse un repositorio de pruebas en http://repos.solvosoft.com/ .

## ¿Cómo puedo ayudar?

Contáctenos mediante Github o cree un issue en este repositorio para ponerse en contacto con nosostros.

## ¿Cómo hago para crear mi propio repositorio ?

Actualmente solo repositorios basados en Debian DEB son creados. Los pasos son:

  - Cree una firma gpg para firmar el repositorio
  - Posicionese en src/deb
  - Modifique en el archivo create_repository.sh  la variable GPGKEY indicando identificador de su nueva firma gpg.
  - ejecute run.sh   $ bash run.sh
  
  Ser creará una carpeta llamada repo, hágala pública con apache o nginx.
