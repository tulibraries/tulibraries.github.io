xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\authors F:\InetPub\Archives\tempress\authors.old
del /f /s /q F:\Inetpub\Publish\tempress\authors
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\authors\* F:\InetPub\Publish\tempress\authors
del /f /s /q F:\Inetpub\Publish\tempress\authors\WebTools
