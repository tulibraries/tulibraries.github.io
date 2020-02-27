xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\chapters F:\InetPub\Archives\tempress\chapters.old
del /f /s /q F:\Inetpub\Publish\tempress\chapters
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\chapters\* F:\InetPub\Publish\tempress\chapters
del /f /s /q F:\Inetpub\Publish\tempress\chapters\WebTools
