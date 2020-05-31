use std::io;

static mut n:i32=0;
static mut cnt:i32=0;
static mut a:i32=0;
static mut b:i32=0;
static mut c:i32=0;

unsafe fn dfs(d:i32){
	if d==n {
		cnt+=1;
		return;
	}
	for i in 0..n {
		if (a>>i&1 |
			b>>i+d&1 |
			c>>i+n-d&1)==0 {
			a|=1<<i;b|=1<<i+d;c|=1<<i+n-d;
			dfs(d+1);
			a^=1<<i;b^=1<<i+d;c^=1<<i+n-d;
		}
	}
}

fn main(){
	let mut input=String::new();
	io::stdin().read_line(&mut input).unwrap();
	unsafe{
		n=input.trim().parse().unwrap();
		dfs(0);
		println!("{}",cnt);
	}
}
