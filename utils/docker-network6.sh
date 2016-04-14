#! /usr/bin/env bash

# create fabric networks
create_fabric_networks()
{
	for i in {0..2}; do
		docker network inspect net${i} > /dev/null
		if [ $? != 0 ]; then
			docker network create --internal \
				--subnet=172.16.${i}.0/24 \
				--gateway=172.16.${i}.254 net${i}
		fi
	done
}

# create spine networks
create_spine_networks()
{
	for j in {1..2}; do
		for i in {1..3}; do
			docker network inspect net${j}${i} > /dev/null
			if [ $? != 0 ]; then
				docker network create --internal \
					--subnet=172.16.${j}${i}.0/24 \
					--gateway=172.16.${j}${i}.254 \
					net${j}${i}
			fi
		done
	done
}

# create leaf networks
create_leaf_networks()
{
	for i in 30 40 50; do
		docker network inspect net${i} > /dev/null
		if [ $? != 0 ]; then
			docker network create --internal \
				--subnet=172.16.${i}.0/24 \
				--gateway=172.16.${i}.254 net${i}
		fi
	done
}

# connect fabric switch
connect_fabric_switches()
{
	docker inspect fab1 > /dev/null
	if [ $? = 0 ]; then
		docker network connect net0 fab1
		docker network connect net1 fab1
		docker network connect net2 fab1
	fi
}

# connect spine switches
connect_spine_switches()
{
	for i in {1..2}; do
		docker inspect spine${i} > /dev/null
		if [ $? = 0 ]; then
			docker network connect net${i} spine${i}
			docker network connect net${i}1 spine${i}
			docker network connect net${i}2 spine${i}
			docker network connect net${i}3 spine${i}
		fi
	done
}

# connect leaf switches
connect_leaf_switches()
{
	for i in {1..3}; do
		docker inspect leaf${i} > /dev/null
		if [ $? = 0 ]; then
			docker network connect net1${i} leaf${i}
			docker network connect net2${i} leaf${i}
			docker network connect net$(expr ${i} + 2)0 leaf${i}
		fi
	done
}

# main
create_fabric_networks
create_spine_networks
create_leaf_networks
connect_fabric_switches
connect_spine_switches
connect_leaf_switches
