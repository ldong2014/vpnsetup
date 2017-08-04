all: sendstat
sendstat: sendstat.c
	gcc -o sendstat sendstat.c
