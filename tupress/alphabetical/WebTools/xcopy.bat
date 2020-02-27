xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\alphabetical F:\InetPub\Archives\tempress\alphabetical.old
del /f /s /q F:\Inetpub\Publish\tempress\alphabetical
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\alphabetical\* F:\InetPub\Publish\tempress\alphabetical
del /f /s /q F:\Inetpub\Publish\tempress\alphabetical\WebTools
