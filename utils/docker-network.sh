#! /usr/bin/env bash

# Docker picks the default network based on the network name
# in the alphabetical order.  We put this prefix to all the
# network names so that those networks won't to be picked
# as the default networks.
#
# https://github.com/docker/docker/issues/21741
net_prefix="znet"

# create fabric networks
create_fabric_networks()
{
	for j in {1..4}; do
		for i in {1..8}; do
			docker network inspect ${net_prefix}1${j}${i} > /dev/null
			if [ $? != 0 ]; then
				docker network create  \
					--subnet=10.10.${j}${i}.0/24 \
					--gateway=10.10.${j}${i}.254 ${net_prefix}1${j}${i}
			fi
		done
	done

        for i in {1..4}; do
                docker network inspect ${net_prefix}41${i} > /dev/null
                if [ $? != 0 ]; then
                        docker network create  \
                                --subnet=10.40.1${i}.0/24 \
                                --gateway=10.40.1${i}.254 ${net_prefix}41${i}
                fi
        done

}

# create spine networks
create_spine_networks()
{
	for i in {1..8}; do
		docker network inspect ${net_prefix}21${i} > /dev/null
		if [ $? != 0 ]; then
			docker network create  \
				--subnet=10.20.1${i}.0/24 \
				--gateway=10.20.1${i}.254 \
				${net_prefix}21${i}
		fi
	done
        for i in {1..8}; do
                docker network inspect ${net_prefix}22${i} > /dev/null
                if [ $? != 0 ]; then 
                        docker network create \
                                --subnet=10.20.2${i}.0/24 \
                                --gateway=10.20.2${i}.254 \
                                ${net_prefix}22${i}
                fi
        done
}

# create leaf networks
create_leaf_networks()
{
        for i in {1..4}; do
                docker network inspect ${net_prefix}51${i} > /dev/null
                if [ $? != 0 ]; then
                        docker network create  \
                                --subnet=10.50.1${i}.0/24 \
                                --gateway=10.50.1${i}.254 ${net_prefix}51${i}
                fi
        done

}

# connect fabric switch
connect_fabric_switches()
{

        for j in {1..4}; do
                docker inspect fab${j} > /dev/null
                if [ $? = 0 ]; then
                        for i in {1..8}; do
                                docker network connect ${net_prefix}1${j}${i} fab${j}
				docker inspect spine${i} > /dev/null
                                if [ $? = 0 ]; then
					docker network connect ${net_prefix}1${j}${i} spine${i}
				fi
                        done
                fi
        done
}

# connect servers to fabric networks
connect_servers_to_fabric_networks()
{
	docker inspect server1 > /dev/null
	if [ $? = 0 ]; then
                docker network connect ${net_prefix}411 fab1
                docker network connect ${net_prefix}412 fab2
                docker network connect ${net_prefix}413 fab3
                docker network connect ${net_prefix}414 fab4
		docker network connect ${net_prefix}411 server1
                docker network connect ${net_prefix}412 server1
                docker network connect ${net_prefix}413 server1
                docker network connect ${net_prefix}414 server1
        fi
}

# connect leaf switches
connect_leaf_switches()
{
	for j in {1..4}; do
       		for i in {1..2}; do
	                docker inspect leaf${i} > /dev/null
        	        if [ $? = 0 ]; then
				docker network connect ${net_prefix}2${i}${j} spine${j}
				docker network connect ${net_prefix}2${i}${j} leaf${i}
			fi
		done
	done
        for j in {5..8}; do
                for i in {1..2}; do
			index=`expr ${i} + 2`
                        docker inspect leaf${index} > /dev/null
                        if [ $? = 0 ]; then
                                docker network connect ${net_prefix}2${i}${j} spine${j}
                                docker network connect ${net_prefix}2${i}${j} leaf${index}
                        fi
                done
        done

}

# connect spine switches
connect_spine_switches()
{
	for i in {1..2}; do
		docker inspect spine${i} > /dev/null
		if [ $? = 0 ]; then
			docker network connect ${net_prefix}$(expr ${i} + 105) \
				leaf${i}
			docker network connect ${net_prefix}$(expr ${i} + 105 + 2) \
				leaf${i}
                        docker network connect ${net_prefix}$(expr ${i} + 205) \
                                leaf${i}
                        docker network connect ${net_prefix}$(expr ${i} + 205 + 2) \
                                leaf${i} 
		fi
	done
}

# connect servers to leaf networks
connect_servers_to_leaf_networks()
{
	docker inspect server2 > /dev/null
        if [ $? = 0 ]; then
                docker network connect ${net_prefix}511 leaf1
                docker network connect ${net_prefix}512 leaf2
                docker network connect ${net_prefix}513 leaf3
                docker network connect ${net_prefix}514 leaf4
                docker network connect ${net_prefix}511 server2
                docker network connect ${net_prefix}512 server2
                docker network connect ${net_prefix}513 server2
                docker network connect ${net_prefix}514 server2
        fi
}

# main
create_fabric_networks
create_spine_networks
create_leaf_networks
connect_fabric_switches
#connect_spine_switches
connect_leaf_switches
connect_servers_to_fabric_networks
connect_servers_to_leaf_networks
