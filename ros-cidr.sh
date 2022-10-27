#!/bin/sh
# create static_router.rsc and firewall address list
mkdir -p ./pbr
cd ./pbr

# CN IP Address
wget --no-check-certificate -c -O all_cn.txt https://ispip.clang.cn/all_cn.txt
# wget --no-check-certificate -c -O all_cn.txt http://www.iwik.org/ipcountry/CN.cidr

# /ip route add dst-address=223.29.252.0/22 gateway=121.14.41.209 comment=CN
# /ip route remove  [/ip route find comment=CN]

ppp_name="l2tp-cn"
# static_router (default in chn)
{
echo "/ip route"
for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$ppp_name comment=CN"
done
} > ../static_router.rsc

hk_gateway="172.16.252.253"
# hk_static_router
{
echo "/ip route"

for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$hk_gateway comment=CN"
done

} > ../hk_static_router.rsc

dbx_gateway="l2tp-cn"
# dbx_static_router
{
echo "/ip route remove  [/ip route find comment=DC]
/ip route remove  [/ip route find comment=Whatsapp]
/ip route remove  [/ip route find comment=Wechat]
/ip route
add dst-address=66.22.212.0/22 gateway=$dbx_gateway comment=DC
add dst-address=66.22.218.0/23 gateway=$dbx_gateway comment=DC
add dst-address=185.151.204.0/24 gateway=$dbx_gateway comment=DC
add dst-address=162.159.128.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.129.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.130.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.133.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.134.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.135.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.136.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.137.232/29 gateway=$dbx_gateway comment=DC
add dst-address=162.159.138.232/29 gateway=$dbx_gateway comment=DC
add dst-address=31.13.0.0/16 gateway=$dbx_gateway comment=Whatsapp
add dst-address=157.240.0.0/16 gateway=$dbx_gateway comment=Whatsapp
add dst-address=14.22.9.0/24 gateway=$dbx_gateway comment=Wechat
add dst-address=119.147.4.0/24 gateway=$dbx_gateway comment=Wechat
add dst-address=129.226.0.0/16 gateway=$dbx_gateway comment=Wechat
add dst-address=163.60.15.0/24 gateway=$dbx_gateway comment=Wechat
add dst-address=183.3.224.0/20 gateway=$dbx_gateway comment=Wechat
add dst-address=203.105.235.0/24 gateway=$dbx_gateway comment=Wechat
"

for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$dbx_gateway comment=CN"
done

} > ../dbx_static_router.rsc

cd ..
rm -rf ./pbr