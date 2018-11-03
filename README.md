## [ENGLISH]

Script for change login or boot wallpaper when starting the computer.

There are 3 scripts:

>login_space.bat

	Changes windows login wallpaper to the last nasa uploaded image (from apod.nasa.gov)
	It works in windows 7 and 10.

	It can be configurated by opening the script with a text editor and modifing 4 lines:
	```
	set arg1=n
	set arg2=n
	set arg3=n

	set resolution=1600x900
	```
	arg1,arg2 y arg3 can be changed for "y" or "n" (yes and no),

	- arg1: if it is windows 10 "y" , if is windows 7 "n"
	- arg2: if we want it to use a cache saved image "y", else "n"
		*The cache is a folder where it would be saving the pictures each day
		 we can change the folder path in: `set random_images_dir=f:\SPACE_IMAGES`
	- arg3: if we want a weather widget with the next 3 days in the image "y", else "n" (it is for all countries and multilanguage)
		*For make the widget working we have to generate the widget code here: https://www.eltiempo.es/widget/
		 and save it inside the folder "windows3party" in a file called "widget.html"
		 
	`set resolution=1600x900` change it to your screen resollution.

	*IF YOU WANT THE SCRIPT TO RUN AUTOMATICALLY IN EACH BOOT:
	add this line at the top of the script or run it once in the command line (cmd.exe):
	`reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Run /f /t REG_SZ /v login_space_script /d %~dpnx0`
	
>space_bg_grub.sh

	Script that changes the grub boot wallpaper for the last nasa image (from apod.nasa.gov)

	Modify `resolution=1366x768` for your screen resollution.

>space_bg_login.sh

	Script that changes login wallapaper in lxde (lubuntu and lxde desktop systems)

	Modify `resolution=1366x768` for your screen resollution.

 
 
## [SPANISH]

Script para cambiar el fondo del login o de arranque al iniciar el ordenador.

Hay 3 scripts:

>login_space.bat

	Cambia la imagen del login de windows por la última imagen subida por la nasa (a apod.nasa.gov)
	Funciona en windows 7 y windows 10.

	Se puede configurar abriendo el fichero con un editor de texto y modificando 4 líneas:
	```
	set arg1=n
	set arg2=n
	set arg3=n

	set resolution=1600x900
	```
	arg1,arg2 y arg3 los podemos cambiar modificando y por n (yes y no),

	- arg1: si es windows 10 "y" , si es windows 7 "n"
	- arg2: si queremos que use una imagen guardada en la caché "y", sino "n"
		*La caché es una carpeta donde irá guardando las imágenes cada día
		 podemos cambiar la carpeta en: `set random_images_dir=f:\SPACE_IMAGES`
	- arg3: si queremos mostrar un widget con el tiempo de los próximos 3 días en la imagen "y", sino "n"
		*Para que funcione el widget tendremos que generar el código del widget aquí: https://www.eltiempo.es/widget/
		 y guardarlo dentro de la carpeta "windows3party" en un fichero llamado widget.html
		 
	`set resolution=1600x900` lo cambiamos por la resolución de nuestra pantalla.
		 
	*SI QUIERE QUE EL SCRIPT ARRANQUE EN CADA INICIO:
	añade esta línea al principio del script o ejecútala desde la línea de comandos (cmd.exe):
	`reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Run /f /t REG_SZ /v login_space_script /d %~dpnx0`
	
>space_bg_grub.sh

	Script que cambia el fondo de arranque de grub por la última imagen de la nasa (a apod.nasa.gov)

	Modificar `resolution=1366x768` por la resolución de vuestra pantalla.

>space_bg_login.sh

	Script que cambia el fondo de login en lxde (lubuntu y sistemas con el entorno de escritorio lxde)

	Modificar `resolution=1366x768` por la resolución de vuestra pantalla.