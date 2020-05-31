use std::io;

struct Main{
	n:i32,
	cnt:i32,
	a:i32, b:i32, c:i32
}

impl Main{
	fn dfs(&mut self,d:i32){
		if d==self.n {
			self.cnt+=1;
			return;
		}
		for i in 0..self.n {
			if (self.a>>i&1 |
				self.b>>i+d&1 |
				self.c>>i+self.n-d&1)==0 {
				self.a|=1<<i;self.b|=1<<i+d;self.c|=1<<i+self.n-d;
				self.dfs(d+1);
				self.a^=1<<i;self.b^=1<<i+d;self.c^=1<<i+self.n-d;
			}
		}
	}
	fn solve(&mut self){
		self.dfs(0);
		println!("{}",self.cnt);
	}
	fn new(n:i32)->Main{
		Main{
			n, cnt:0, a:0, b:0, c:0
		}
	}
}

fn main(){
	let mut input=String::new();
	io::stdin().read_line(&mut input).unwrap();
	let mut inst=Main::new(input.trim().parse().unwrap());
	inst.solve();
}
