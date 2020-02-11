const fs=require("fs");
const data=fs.readFileSync("/dev/stdin");

var n=parseInt(data.toString("ascii")),cnt=0;
var a=0,b=0,c=0;

void function dfs(d){
	d=d | 0; // JIT
	if(d>n){
		cnt++;
		return;
	}
	for(let i=1;i<=n;++i){
	// Use | instead of || to avoid type cast
		if(!(a>>i&1 |
			b>>i+d&1 |
			c>>i+n-d&1)){
			a|=1<<i,b|=1<<i+d,c|=1<<i+n-d;
			dfs(d+1);
			a^=1<<i,b^=1<<i+d,c^=1<<i+n-d;
		}
	}
}(1);

console.log(cnt);
