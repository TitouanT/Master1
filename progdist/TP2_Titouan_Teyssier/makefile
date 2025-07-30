all:
	$(MAKE) -C appserver all
	mv appserver/compute.jar appclient
	$(MAKE) -C appclient all

run:
	cd appserver; termite --hold -e "rmiregistry" 2> /dev/null & disown
	sleep 3
	cd appserver; termite --hold -e "./golocal.sh" 2> /dev/null & disown
	sleep 3
	cd appclient; termite --hold -e "./golocal.sh 1 2 3 4 5" 2> /dev/null & disown

clean:
	find . -name "*.class" -type f -delete
	find . -name "*.jar" -type f -delete
