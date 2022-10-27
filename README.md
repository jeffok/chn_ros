CN IP 白名单规则，增加了个别特殊的地址

ip段信息取自 [all_cn](https://ispip.clang.cn/all_cn.txt)

备用 [CN_cidr](http://www.iwik.org/ipcountry/CN.cidr)

由Github Action自动构建于此，GMT+8 每天4点自动更新

明细路由和策略路由在ros中实现方法：

**cn_route.rsc** 是往ip-route 里填加路由信息，网关请自行修改（默认为l2tp-cn)

```
/file remove [find name="static_router.rsc"]
/tool fetch mode=http url="https://raw.githubusercontent.com/jeffok/chn_ros/main/static_router.rsc" \
dst-path=static_router.rsc
:if ([:len [/file find name=static_router.rsc]] > 0) do={
/ip route remove  [/ip route find comment=CN]
/im file=static_router.rsc
}

```

**cn_address-list.rsc** 是往Firewall - address lists 里生ip段列表。
```
/file remove [find name="cn_address-list.rsc"]
/tool fetch url="https://raw.githubusercontent.com/jeffok/chn_ros/main/cn_address-list.rsc" \
dst-path=cn_address-list.rsc
:if ([:len [/file find name=cn_address-list.rsc]] > 0) do={
/ip firewall address-list remove [find comment="chn_cidr"]
/import cn_address-list.rsc
}
```

感谢地址提供[Clang](https://ispip.clang.cn/)