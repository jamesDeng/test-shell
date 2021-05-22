# Quickstart Guide

Access Log analytics
1. Count the total number of HTTP requests recorded by this access logfile
2. Find the top-10 (host) hosts makes most requests from 2019-06-10 00:00:00 to
2019-06-19 23:59:59, inclusively
3. Find out the country with most requests originating from (according to the source
IP)

## Requirements
* Centos 7.x
* install geoip, yum -y install geoip

## Use

1. View Total Number:
``` bash
sh access.sh -f access.log -t
```

2. Top-10 hosts requests:
``` bash
sh access.sh -f access.log -q 19/May/2019:00:00:00,19/May/2019:23:59:59
```

3. Find out the country with most requests originating from:
``` bash
sh access.sh -f access.log -c
```
4. All
``` bash
sh access.sh -f access.log -t -q 19/May/2019:00:00:00,19/May/2019:23:59:59 -c
```

5. There is a problem, you can refresh the index：
``` bash
sh access.sh -f access.log -i
```

Note: 一次执行命令需要建立索引，需要等待一定时间
 
## 注意
命令不应该在 PROD 环境执行，它并没有限制资源的使用，会带一定的风险
