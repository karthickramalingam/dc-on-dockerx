#! /usr/bin/env bash

# setup spine networks
for i in {0..2}; do
	docker network inspect net${i} > /dev/null
	if [ $? != 0 ]; then
		docker network create --internal \
			--subnet=172.16.${i}.0/24 \
			--gateway=172.16.${i}.254 net${i}
	fi
done

# setup fabric networks
for j in {1..2}; do
	for i in {1..3}; do
		docker network inspect net${j}${i} > /dev/null
		if [ $? != 0 ]; then
			docker network create --internal \
				--subnet=172.16.${j}${i}.0/24 \
				--gateway=172.16.${j}${i}.254 net${j}${i}
		fi
	done
done

# setup edge networks
for i in 30 40 50; do
	docker network inspect net${i} > /dev/null
	if [ $? != 0 ]; then
		docker network create --internal \
			--subnet=172.16.${i}.0/24 \
			--gateway=172.16.${i}.254 net${i}
	fi
done
