@echo off

@REM https://api.telegram.org/bot<AQUIVATUTOKEN>/getUpdates donde puedes obtener tu id de chat
set telegram_bot_token= Tu token de telegram bot
set chat_id= Tu chat id de telegram
set log_path=C:\Users\TUSUARIO\Documents

@REM Pon aqui la ip que quieres usar para tener referencia, yo uso el DNS publico de GOOGLE, no se cae
set ip= 8.8.8.8
:loop

@REM Filtro pa ve si tengo TTL en el echo del mensaje
ping -n 1 %ip%| find "TTL=" > nul

@REM checkeo pa ve si es valido
if errorlevel 1 (
    @REM aqui walda en un archivo de texto en mi pc como pa recordar que cantv se cae a cada rato y yo contar cuantas veces se va esa vaina
    echo %date% %time% - No se puede conectar a %ip% >> %log_path%\ping.log
    goto loop
    
@REM como no es valido lanza el mensaje de exito y envia el curl a telegram
) else (
    set message=El ping a 8.8.8.8 fue exitoso: %date% %time%
    echo %message%
    curl -X POST "https://api.telegram.org/bot%telegram_bot_token%/sendMessage" -d "chat_id=%chat_id%&text=%message%"
   
   @REM aqui declaras el tiempo que dure en ejecutarse denuevo el codigo para chequear que tienes internet en segundos
   @REM 300segundos tengo declarado, puedes colocar lo que quieras.
    timeout /t 300
  goto loop
)
