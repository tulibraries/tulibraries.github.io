xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\img F:\InetPub\Archives\tempress\img.old
del /f /s /q F:\Inetpub\Publish\tempress\img
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\img\* F:\InetPub\Publish\tempress\img
del /f /s /q F:\Inetpub\Publish\tempress\img\WebTools
