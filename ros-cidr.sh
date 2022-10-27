#!/bin/sh
# create static_router.rsc and firewall address list
mkdir -p ./pbr
cd ./pbr

# CN IP Address
wget --no-check-certificate -c -O all_cn.txt https://ispip.clang.cn/all_cn.txt
# wget --no-check-certificate -c -O all_cn.txt http://www.iwik.org/ipcountry/CN.cidr

# /ip route add dst-address=223.29.252.0/22 gateway=121.14.41.209 comment=CN
# /ip route remove  [/ip route find comment=CN]

net_name="l2tp-cn"
# static_router (default in chn)
{
echo "/ip route remove  [/ip route find comment=CN]
/ip route"
for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$net_name comment=CN"
done
} > ../static_router.rsc


# static_address_list (default in chn)
{
echo "/ip firewall address-list remove [/ip firewall address-list find comment=chn_cidr]
/ip firewall address-list"
for address in $(cat all_cn.txt) ; do
  echo "add list=CN address=$address comment=chn_cidr"
done
} > ../static_address_list.rsc


# hk_static_router
hk_gateway="172.16.252.253"
{
echo "/ip route remove  [/ip route find comment=CN]
/ip route"

for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$hk_gateway comment=CN"
done

} > ../hk_static_router.rsc

# dbx_static_router
dbx_gateway="l2tp-cn"
{
echo "/ip route remove  [/ip route find comment=CN]
/ip route remove  [/ip route find comment=DC]
/ip route remove  [/ip route find comment=Whatsapp]
/ip route remove  [/ip route find comment=Wechat]
/ip route
add dst-address=66.22.212.0/22 gateway=$net_name comment=DC
add dst-address=66.22.218.0/23 gateway=$net_name comment=DC
add dst-address=185.151.204.0/24 gateway=$net_name comment=DC
add dst-address=162.159.128.232/29 gateway=$net_name comment=DC
add dst-address=162.159.129.232/29 gateway=$net_name comment=DC
add dst-address=162.159.130.232/29 gateway=$net_name comment=DC
add dst-address=162.159.133.232/29 gateway=$net_name comment=DC
add dst-address=162.159.134.232/29 gateway=$net_name comment=DC
add dst-address=162.159.135.232/29 gateway=$net_name comment=DC
add dst-address=162.159.136.232/29 gateway=$net_name comment=DC
add dst-address=162.159.137.232/29 gateway=$net_name comment=DC
add dst-address=162.159.138.232/29 gateway=$net_name comment=DC
add dst-address=31.13.0.0/16 gateway=$net_name comment=Whatsapp
add dst-address=157.240.0.0/16 gateway=$net_name comment=Whatsapp
add dst-address=14.22.9.0/24 gateway=$net_name comment=Wechat
add dst-address=119.147.4.0/24 gateway=$net_name comment=Wechat
add dst-address=129.226.0.0/16 gateway=$net_name comment=Wechat
add dst-address=163.60.15.0/24 gateway=$net_name comment=Wechat
add dst-address=183.3.224.0/20 gateway=$net_name comment=Wechat
add dst-address=203.105.235.0/24 gateway=$net_name comment=Wechat
"
for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$net_name comment=CN"
done

} > ../dbx_static_router.rsc

cd ..
rm -rf ./pbr