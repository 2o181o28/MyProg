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
	extern"C" {fn scanf(_:&[u8;2],_:&mut i32);}
	let mut n=0;
	unsafe{scanf(b"%d",&mut n);}
	let mut inst=Main::new(n);
	inst.solve();
}
