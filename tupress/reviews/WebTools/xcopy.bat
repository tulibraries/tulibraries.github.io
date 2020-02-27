xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\reviews F:\InetPub\Archives\tempress\reviews.old
del /f /s /q F:\Inetpub\Publish\tempress\reviews
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\reviews\* F:\InetPub\Publish\tempress\reviews
del /f /s /q F:\Inetpub\Publish\tempress\reviews\WebTools
