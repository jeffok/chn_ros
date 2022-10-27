#!/bin/sh
# create static_router.rsc and firewall address list
mkdir -p ./pbr
cd ./pbr

# CN IP Address
wget --no-check-certificate -c -O all_cn.txt https://ispip.clang.cn/all_cn.txt
# wget --no-check-certificate -c -O all_cn.txt http://www.iwik.org/ipcountry/CN.cidr

# /ip route add dst-address=223.29.252.0/22 gateway=121.14.41.209 comment=CN
# /ip route remove  [/ip route find comment=CN]

ppp_name=l2tp-cn

# static_router
{
echo "/ip route remove  [/ip route find comment=CN]
/ip route"

for cidr in $(cat all_cn.txt) ; do
  echo "add dst-address=$cidr gateway=$ppp_name comment=CN"
done

} > ../static_router.rsc

{
echo "/ip firewall address-list"

for net in $(cat all_cn.txt) ; do
  echo "add list=CN address=$net comment='chn_cidr'"
done

} > ../cn_address-list.rsc

cd ..
rm -rf ./pbr
