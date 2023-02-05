# Proposal: enhancement /etc/init.d/dhcp.sh

When using dhcp client on TinyCore, the shell script /etc/init.d/dhcp.sh is used.
To make it as silent as possible all output is deaf-nulled.

```
/sbin/udhcpc -b -i $DEVICE -x hostname:$(/bin/hostname) -p /var/run/udhcpc.$DEVICE.pid >/dev/null 2>&1 &
```

One of the features of udhcpc is when an IP lease is received, it runs the script (as default)
/usr/share/udhcpc/default.script

It is a shame we can not echo something back.

I want to propose a change on the /etc/init.d/dhcp.sh script, for only stderr to be silenced.

```
/sbin/udhcpc -b -i $DEVICE -x hostname:$(/bin/hostname) -p /var/run/udhcpc.$DEVICE.pid 2>/dev/null &
```

In this way you can add something usefull to the /usr/share/udhcpc/default.script
```
 ....
        renew|bound)
                /sbin/ifconfig $interface $ip $BROADCAST $NETMASK

                echo -e -n "\033[2A\033[50DInterface $interface bound to $ip"
                killall getty

                if [ -n "$router" ] ; then
                        echo "deleting routers" 1>&2
                        while route del default gw 0.0.0.0 dev $interface ; do
                                :
                        done

                        metric=0
                        for i in $router ; do
                                route add default gw $i dev $interface metric $((metric++))
                        done
                fi

                echo -n > $RESOLV_CONF
                [ -n "$domain" ] && echo search $domain >> $RESOLV_CONF
                for i in $dns ; do
                        echo adding dns $i 1>&2
                        echo nameserver $i >> $RESOLV_CONF
                done
                ;;
.....
```

This result is showing the IP address on the console and restarting getty to not interfering the login prompt process.

See screendump for result. (I also removed some 'clear' statements in scripts to watch te boot process in full)

