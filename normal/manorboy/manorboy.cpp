#include<bits/stdc++.h>
using namespace std;
using func=function<int()>;
int A(int k,func x1,func x2,func x3,func x4,func x5){
	func B=[&]{return A(--k,B,x1,x2,x3,x4);};
	if(k<=0)return x4()+x5();
	return B();
}
int main(){
	func one=[]{return 1;},
		negone=[]{return -1;},
		zero=[]{return 0;};
	printf("%d\n",A(10,one,negone,negone,one,zero));
	return 0;
}
