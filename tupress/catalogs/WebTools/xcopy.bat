xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\catalogs F:\InetPub\Archives\tempress\catalogs.old
del /f /s /q F:\Inetpub\Publish\tempress\catalogs
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\catalogs\* F:\InetPub\Publish\tempress\catalogs
del /f /s /q F:\Inetpub\Publish\tempress\catalogs\WebTools
