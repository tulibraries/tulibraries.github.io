xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\chapters_1400 F:\InetPub\Archives\tempress\chapters_1400.old
del /f /s /q F:\Inetpub\Publish\tempress\chapters_1400
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\chapters_1400\* F:\InetPub\Publish\tempress\chapters_1400
del /f /s /q F:\Inetpub\Publish\tempress\chapters_1400\WebTools
