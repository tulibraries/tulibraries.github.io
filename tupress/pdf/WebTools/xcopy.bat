xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\pdf F:\InetPub\Archives\tempress\pdf.old
del /f /s /q F:\Inetpub\Publish\tempress\pdf
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\pdf\* F:\InetPub\Publish\tempress\pdf
del /f /s /q F:\Inetpub\Publish\tempress\pdf\WebTools
