xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\audio F:\InetPub\Archives\tempress\audio.old
del /f /s /q F:\Inetpub\Publish\tempress\audio
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\audio\* F:\InetPub\Publish\tempress\audio
del /f /s /q F:\Inetpub\Publish\tempress\audio\WebTools
