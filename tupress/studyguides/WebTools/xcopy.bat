xcopy /C /E /F /H /I /V /Y  F:\InetPub\Publish\tempress\studyguides F:\InetPub\Archives\tempress\studyguides.old
del /f /s /q F:\Inetpub\Publish\tempress\studyguides
xcopy /C /E /F /H /I /V /Y  F:\InetPub\Develop\tempress\studyguides\* F:\InetPub\Publish\tempress\studyguides
del /f /s /q F:\Inetpub\Publish\tempress\studyguides\WebTools
