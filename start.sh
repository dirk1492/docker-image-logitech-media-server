sudo docker run -d --name lms --restart always -p 9000:9000 -p 9090:9090 -p 3483:3483 -p 3483:3483/udp -v /media/Data/squeezebox:/srv/squeezebox  -v /media:/media -v /etc/localtime:/etc/localtime:ro dil001/logitechmediaserver-arm32v7:7.9.1