FROM swipl:latest
COPY simple_server.pl .
COPY gratefuldead.pl .
EXPOSE $PORT 
EXPOSE $HOST
CMD ["swipl", "simple_server.pl"]
