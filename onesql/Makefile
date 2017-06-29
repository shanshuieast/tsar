CFLAGS = -Wall -fPIC --shared -g -O2
CC = gcc
INCLUDE_DIR = /usr/local/tsar/devel
LINK = $(CC) -I$(INCLUDE_DIR) $(CFLAGS)


OBJS =  mod_onesql.so

all: $(OBJS)

$(OBJS): %.so: %.c
	$(LINK) $< -o $@
clean:
	rm -f *.so;
install:
	mkdir -p /etc/tsar/conf.d/
	cp ./mod_onesql.so /usr/local/tsar/modules/
	cp ./onesql.sh /usr/local/tsar/modules/
	cp ./mod_onesql.conf /etc/tsar/conf.d/onesql.conf
uninstall:
	rm /usr/local/tsar/modules/mod_onesql.so
	rm /usr/local/tsar/modules/onesql.sh
	rm /etc/tsar/conf.d/onesql.conf
