#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/usr/local/lib"
export TEST_PHP_ARGS="-q"

###############################################################################

runTest() {

	##########################
	# Part 1: State disabled #
	##########################

	printf "[network]\nlisten=[\"0.0.0.0\"]\n[state]\nenabled=false\n" > /usr/etc/trogdord/trogdord.ini

	trogdord &

	if [ $? -ne 0 ]; then
		return 1
	fi

	TROGDORD_PID=$!

	npm test

	if [ $? -ne 0 ]; then
		return 1
	fi

	kill $TROGDORD_PID
	sleep 1

	#########################
	# Part 2: State enabled #
	#########################

	printf "[network]\nlisten=[\"0.0.0.0\"]\n[state]\nenabled=true\nmax_dumps_per_game=5\nsave_path=var/trogdord/state\n" > /usr/etc/trogdord/trogdord.ini

	trogdord &

	if [ $? -ne 0 ]; then
		return 1
	fi

	TROGDORD_PID=$!

	npm test

	if [ $? -ne 0 ]; then
		return 1
	fi

	kill $TROGDORD_PID
	sleep 1
}

###############################################################################

runTest

if [ $? -ne 0 ]; then
	exit 1
fi
