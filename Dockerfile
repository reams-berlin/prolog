FROM swipl:latest
COPY simple_server.pl .
COPY helers.pl .
COPY gratefuldead.pl .
EXPOSE $PORT 
CMD ["swipl", "simple_server.pl"]
