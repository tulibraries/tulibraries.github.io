xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\templates F:\InetPub\Archives\tempress\templates.old
del /f /s /q F:\Inetpub\Publish\tempress\templates
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\templates\* F:\InetPub\Publish\tempress\templates
del /f /s /q F:\Inetpub\Publish\tempress\templates\WebTools
