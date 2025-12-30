pushd D:\YandexDisk\ISPY\video\FLGWO\grabs
for /f "tokens=*" %%a in ('dir /b /od') do set newest=%%a
popd
set File="D:\YandexDisk\ISPY\video\FLGWO\grabs\%newest%"
curl  -s -X POST "https://api.telegram.org/bot5471799096:AAGXElESbXi6hzxLd8lEsZqzOTSHRx4lp1g/sendPhoto?chat_id=-1001727911549" -F photo=@%File% -F caption="Alarm!"