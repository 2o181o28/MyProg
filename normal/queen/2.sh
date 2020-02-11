#!/bin/bash
a=b=c=0
dfs(){
	local d=$1 i
	if((d>n));then
		((cnt++))
		return
	fi
	for((i=1;i<=n;i++))do
		if ((!(a>>i&1|b>>i+d&1|c>>i+n-d&1))); then
			((a|=1<<i,b|=1<<i+d,c|=1<<i+n-d))
			dfs $((d+1))
			((a^=1<<i,b^=1<<i+d,c^=1<<i+n-d))
		fi
	done
}
read n
dfs 1
echo $cnt
