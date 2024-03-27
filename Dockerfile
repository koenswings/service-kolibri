FROM --platform=linux/arm64 python:3.5-buster

ADD ./kolibri-0.15.5.pex /kolibri-0.15.5

RUN chmod +x /kolibri-0.15.5

#used for storing db and content (used when mounting volume)
RUN mkdir /root/.kolibri

EXPOSE 8080

CMD ./kolibri-0.15.5 start && tail -f /root/.kolibri/logs/kolibri.txt
