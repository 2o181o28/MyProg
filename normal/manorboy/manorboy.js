function A(k,...x){
	let B=()=>A(--k,B,...x.slice(0,4));
	return k<=0?x[3]()+x[4]():B();
}
console.log(A(10,()=>1,()=>-1,()=>-1,()=>1,()=>0))
