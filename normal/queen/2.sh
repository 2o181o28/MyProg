dfs(){
	local d=$1 i
	if((d>n));then
		((cnt++))
		return
	fi
	for((i=1;i<=n;i++))do
		if ((${a[i]}==0)) && 
		((${b[i+d]}==0)) && 
		((${c[i+n-d]}==0)); then
			((a[i]=b[i+d]=c[i+n-d]=1))
			dfs $((d+1))
			((a[i]=b[i+d]=c[i+n-d]=0))
		fi
	done
}
read n
for((i=1;i<=2*n;i++))do
	((a[i]=b[i]=c[i]=0))
done
dfs 1
echo $cnt
