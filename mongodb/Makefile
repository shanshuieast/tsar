CFLAGS = -Wall -fPIC --shared -g -O2
CC = gcc
INCLUDE_DIR = /usr/local/tsar/devel
LINK = $(CC) -I$(INCLUDE_DIR) $(CFLAGS)


OBJS =  mod_mongodb.so

all: $(OBJS)

$(OBJS): %.so: %.c
	$(LINK) $< -o $@
clean:
	rm -f *.so;
install:
	mkdir -p /etc/tsar/conf.d/
	cp ./mod_mongodb.so /usr/local/tsar/modules/
	cp ./mongodb.py /usr/local/tsar/modules/
	cp ./mod_mongodb.conf /etc/tsar/conf.d/mongodb.conf
uninstall:
	rm /usr/local/tsar/modules/mod_mongodb.so
	rm /usr/local/tsar/modules/mongodb.py
	rm /etc/tsar/conf.d/mongodb.conf

