xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\titles F:\InetPub\Archives\tempress\titles.old
del /f /s /q F:\Inetpub\Publish\tempress\titles
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\titles\* F:\InetPub\Publish\tempress\titles
del /f /s /q F:\Inetpub\Publish\tempress\titles\WebTools
