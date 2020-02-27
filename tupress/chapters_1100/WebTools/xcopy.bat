xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\chapters_1100 F:\InetPub\Archives\tempress\chapters_1100.old
del /f /s /q F:\Inetpub\Publish\tempress\chapters_1100
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\chapters_1100\* F:\InetPub\Publish\tempress\chapters_1100
del /f /s /q F:\Inetpub\Publish\tempress\chapters_1100\WebTools
