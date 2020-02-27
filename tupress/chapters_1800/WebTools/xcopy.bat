xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\chapters_1800 F:\InetPub\Archives\tempress\chapters_1800.old
del /f /s /q F:\Inetpub\Publish\tempress\chapters_1800
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\chapters_1800\* F:\InetPub\Publish\tempress\chapters_1800
del /f /s /q F:\Inetpub\Publish\tempress\chapters_1800\WebTools
