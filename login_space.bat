@echo off
REM %1 w10?     y,n
REM %2 random?  y,n
REM %3 weather?  y,n
if "%1"=="y" ( set arg1=y ) else ( set arg1=n )
if "%2"=="y" ( set arg2=y ) else ( set arg2=n )
if "%3"=="y" ( set arg3=y ) else ( set arg3=n )

REM cambiar el y por n de alguna de estas líneas si queremos activar por defecto alguno de los argumentos:
REM arg1 para windows10, arg2 para imagen aleatoria de carpeta, arg3 para el tiempo en la imagen

set arg1=n
set arg2=n
set arg3=n

set resolution=1600x900

	REM RANDOMIMAGES:
set random_images_dir=f:\SPACE_IMAGES
	REM WEATHER:
set htmlTOpdf_exe="%~dp0\windows3party\wkhtmltoimage.exe"
set widget_address="%~dp0\windows3party\widget.html"
	REM IMAGEMAGICK:
set mogrify_exe="%~dp0\windows3party\imagemagick\mogrify.exe"
set composite_exe="%~dp0\windows3party\imagemagick\composite.exe"

REM nos saltamos la espera de conexion si hemos elegido imagen random
if %arg2%==y goto RRAANNDD
REM si no hay conexion usa imagen random (espera 6seg a que arranque la red):
%~dp0\windows3party\sleep 6
ping google.com -n 1
if %errorlevel%==1 set arg2=y

:RRAANNDD

REM si elegimos parametro random mostrara imagen aleatoria guardada previamente
REM he tenido que convertir el if en goto sino se cargaba las variables de dentro irremediablemente

if NOT %arg2% == y GOTO NORAND

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`dir %random_images_dir% /b ^| %~dp0\windows3party\wc -l ^| %~dp0\windows3party\cut -d" " -f5`) DO ( SET total=%%F )
SET /A rand=%RANDOM%%%%total%+1
 echo %rand% && pause
for /f "tokens=* USEBACKQ" %%f IN (`dir %random_images_dir% /b`) DO ( 
 if !rand! EQU !count! set rand_img=%%f
 SET /a count=!count!+1
)
copy /y "%random_images_dir%\%rand_img%" %temp%\backgroundDefault.jpg
ENDLOCAL

:NORAND
if NOT %arg2% == y (
	%~dp0\windows3party\curl -k https://apod.nasa.gov/apod/astropix.html>%temp%\1.a
	for /f delims^=^"^ tokens^=2 %%# in ('type %temp%\1.a ^| grep "jpg" ^| head -n1') do (
	 %~dp0\windows3party\curl -k https://apod.nasa.gov/%%#>%temp%\backgroundDefault.jpg
	)
	del %temp%\1.a
	REM Hacemos una copia de las fotos que va sacando cada día:
	copy /Y %temp%\backgroundDefault.jpg %random_images_dir%\%date:~6,8%-%date:~3,2%-%date:~0,2%.jpg
)

REM si no hay imagen salimos
if not exist %temp%\backgroundDefault.jpg goto END

REM si la imagen no se ha obtenido bien tambien salimos (LSS 5000 es <5kb)
for /f "tokens=1 delims= " %%# in ('%~dp0\windows3party\wc -c %temp%\backgroundDefault.jpg') do (
	if %%# LSS 5000 (
		echo imagen erronea o demasiado pequeña
		goto END
	)
)

REM REDUCIMOS LA IMAGEN (para w7 lo máx que soporta son 256kbs)
if NOT exist %mogrify_exe% goto NO_MOGRIFY

REM Reducimos tamanio en caso de que ocupe mas de 256kbs ( y lo adaptamos a su resolucion)
rem	%mogrify_exe% -resize 75%% %temp%\backgroundDefault.jpg
rem	%mogrify_exe% -quality 85 %temp%\backgroundDefault.jpg


 for /f "tokens=1 delims= " %%# in ('%~dp0\windows3party\wc -c %temp%\backgroundDefault.jpg') do (
 	if %%# GTR 256000 (
		%mogrify_exe% -resize %resolution% %temp%\backgroundDefault.jpg
	)
 )


REM añadimos el widget del tiempo:
if %arg3%==y (
 REM [] hacemos impresion de la imagen del html:
 %htmlTOpdf_exe% --crop-h 274 --crop-w 200 %widget_address% %temp%\extract.png
 REM [] recortamos la imagen
 %mogrify_exe% %temp%\extract.png -crop 182x265+8+65 %temp%\extract.png
 REM [] la pegamos en el fondo
 %composite_exe% -gravity east %temp%\extract.png %temp%\backgroundDefault.jpg %temp%\output.jpg
 move /Y %temp%\output.jpg %temp%\backgroundDefault.jpg
)


REM si no es w10 seguimos reduciendo la imagen:
if NOT %arg1%==y (
 for /f "tokens=1 delims= " %%# in ('%~dp0\windows3party\wc -c %temp%\backgroundDefault.jpg') do (
 	if %%# GTR 256000 (
		%mogrify_exe% -quality 75 %temp%\backgroundDefault.jpg
	)
 )
 for /f "tokens=1 delims= " %%# in ('%~dp0\windows3party\wc -c %temp%\backgroundDefault.jpg') do (
 	if %%# GTR 256000 (
		%mogrify_exe% -quality 65 %temp%\backgroundDefault.jpg
	)
 )
 for /f "tokens=1 delims= " %%# in ('%~dp0\windows3party\wc -c %temp%\backgroundDefault.jpg') do (
 	if %%# GTR 256000 (
		%mogrify_exe% -quality 55 %temp%\backgroundDefault.jpg
	)
 )
 for /f "tokens=1 delims= " %%# in ('%~dp0\windows3party\wc -c %temp%\backgroundDefault.jpg') do (
 	if %%# GTR 256000 (
		%mogrify_exe% -resize 75%% %temp%\backgroundDefault.jpg
	)
 )
)


:NO_MOGRIFY

REM copiamos o metemos la imagen según sea w10 o anterior:
if %arg1%==y (
	REM ---Windows 10---:
 %~dp0\windows3party\w10bg.exe /I %temp%\backgroundDefault.jpg
) else (
 	REM ---Windows 7 ---:
 if not exist %windir%\System32\oobe\info\backgrounds (
	mkdir %windir%\System32\oobe\info\backgrounds
	reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background /v OEMBackground /t REG_DWORD /d 1 /f
 )

 if exist %temp%\backgroundDefault.jpg del /f %windir%\System32\oobe\info\backgrounds\backgroundDefault.jpg
 move /Y %temp%\backgroundDefault.jpg %windir%\System32\oobe\info\backgrounds\backgroundDefault.jpg
)

:END

if exist %temp%\backgroundDefault.jpg del %temp%\backgroundDefault.jpg