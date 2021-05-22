# Quickstart Guide

Access Log analytics
1. Count the total number of HTTP requests recorded by this access logfile
2. Find the top-10 (host) hosts makes most requests from 2019-06-10 00:00:00 to
2019-06-19 23:59:59, inclusively
3. Find out the country with most requests originating from (according to the source
IP)

## Requirements
* Centos 7.x
* install geoip, 'yum -y install geoip'

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
sh access.sh -f access.log -t -q 10/Jun/2019:00:00:00,19/Jun/2019:23:59:59 -c
```

5. There is a problem, you can refresh the index：
``` bash
sh access.sh -f access.log -i
```

Note: 第一次執行需要建立索引，請等待一定時間

## Issue
1. Request IP format error
``` bash
[root@cn-hongkong shell]# sh access.sh -f access.log -t
Total number of lines 86084,HTTP requests 85514, format error 570
```

2. Large number of 404 requests, which may be attacked：
``` bash
[root@cn-hongkong shell]# sh access.sh -f access.log -s 404
Top-10 hosts requests form http status 404 :
43.254.217.201 : 676
113.141.67.59 : 676
132.232.66.184 : 675
222.185.238.250 : 638
182.61.161.109 : 638
154.92.19.184 : 638
62.234.133.201 : 632
139.159.207.25 : 631
132.232.75.79 : 630
136.243.37.219 : 484
```

## Note
命令不應該在 PROD 環境執行，它並沒有限制資源的使用，會帶一定的風險
