pushd H:\YandexDisk\ISPY\video\mfuxx-mg69-16-cctv-01\thumbs
for /f "tokens=*" %%a in ('dir /b /od') do set newest=%%a
popd
set File="H:\YandexDisk\ISPY\video\mfuxx-mg69-16-cctv-01\thumbs\%newest%"
curl.exe  -s -X POST "https://api.telegram.org/bot5471799096:AAGXElESbXi6hzxLd8lEsZqzOTSHRx4lp1g/sendPhoto?chat_id=-1001727911549" -F photo=@%File% -F caption="Alarm!"