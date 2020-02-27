xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\small F:\InetPub\Archives\tempress\small.old
del /f /s /q F:\Inetpub\Publish\tempress\small
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\small\* F:\InetPub\Publish\tempress\small
del /f /s /q F:\Inetpub\Publish\tempress\small\WebTools
