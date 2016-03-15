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

# Attach spine switch
docker inspect ops0 > /dev/null
if [ $? = 0 ]; then
	docker network connect net0 ops0
	docker network connect net1 ops0
	docker network connect net2 ops0
fi

# Attach fabric switches
for i in {1..2}; do
	docker inspect ops${i} > /dev/null
	if [ $? = 0 ]; then
		docker network connect net${i} ops${i}
		docker network connect net${i}1 ops${i}
		docker network connect net${i}2 ops${i}
		docker network connect net${i}3 ops${i}
	fi
done

# Attach edge switches
for i in {3..5}; do
	docker inspect ops${i} > /dev/null
	if [ $? = 0 ]; then
		docker network connect net1$(expr ${i} - 2) ops${i}
		docker network connect net2$(expr ${i} - 2) ops${i}
		docker network connect net${i}0 ops${i}
	fi
done
