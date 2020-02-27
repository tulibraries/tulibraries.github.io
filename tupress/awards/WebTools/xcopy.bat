xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\awards F:\InetPub\Archives\tempress\awards.old
del /f /s /q F:\Inetpub\Publish\tempress\awards
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\awards\* F:\InetPub\Publish\tempress\awards
del /f /s /q F:\Inetpub\Publish\tempress\awards\WebTools
