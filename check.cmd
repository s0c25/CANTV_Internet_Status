@echo off

@REM https://api.telegram.org/bot<AQUIVATUTOKEN>/getUpdates donde puedes obtener tu id de chat
set telegram_bot_token= Tu token de telegram bot
set chat_id= Tu chat id de telegram
set log_path=C:\Users\TUSUARIO\Documents

@REM Pon aqui la ip que quieres usar para tener referencia, yo uso el DNS publico de GOOGLE, no se cae
set ip= 8.8.8.8



:ping_loop
@REM Cada 10 segudos ejecuta 4 ping
ping -n 4 -w 10000 %ip%| find "TTL=" > nul

@REM ping %ip% -n 1 -w 1000 >nul
if %errorlevel% neq 0 (
    echo No hay conexión a Internet. Verificando conexión...
    goto :verificar_internet
) else (
    echo Conexión exitosa.
    goto :ping_loop
)
goto :ping_loop



:verificar_internet
@REM ping %ip% -n 1 >nul

ping -n 1 %ip%| find "TTL=" > nul
if errorlevel 1 (
  echo %date% %time% - No se puede conectar a %ip% >> %log_path%\ping.log
  goto :musica
  
) else (
  taskkill /im Microsoft.Media.Player.exe /f
  set message=El ping a 8.8.8.8 fue exitoso: %date% %time%
  echo %message%
  curl -X POST "https://api.telegram.org/bot%telegram_bot_token%/sendMessage" -d "chat_id=%chat_id%&text=%message%"
  echo Tienes conexión a Internet.
  goto :ping_loop
)


:musica

wmic process where "name='Microsoft.Media.Player.exe'" get name | findstr "Microsoft.Media.Player.exe" >nul
echo %errorlevel%
  
  if %errorlevel% equ 0 (
      echo El proceso se está ejecutando.
      goto :verificar_internet
  ) else (
      echo El proceso no se está ejecutando.
      start C:\Users\tu nombre de usuario\Downloads\tu cancion.mp3
      goto :ping_loop

  )
