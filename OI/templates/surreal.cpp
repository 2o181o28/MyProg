/*
	surreal struct implementation.
	
	supports: > >= < <= == != + - * -(unary)
*/
#include<bits/stdc++.h>
using namespace std;
struct surreal{
	set<surreal> l,r;
	bool operator<=(const surreal&b)const{
		bool r=true;
		if(l.size())r&=*--l.end()<b;
		if(b.r.size())r&=*this<*b.r.begin();
		return r;
	}
	bool operator==(const surreal&b)const{
		return *this<=b && b<=*this;
	}
	int operator<=>(const surreal&b)const{
		return *this==b ? 0 : (*this<=b?-1:1);
	}
	surreal operator+(const surreal&b)const{
		set<surreal> rl,rr;
		for(auto&i:l)rl.insert(i+b);
		for(auto&i:r)rr.insert(i+b);
		for(auto&i:b.l)rl.insert(*this+i);
		for(auto&i:b.r)rr.insert(*this+i);
		return {rl,rr};
	}
	surreal operator-()const{
		set<surreal> rl,rr;
		for(auto&i:l)rr.insert(-i);
		for(auto&i:r)rl.insert(-i);
		return {rl,rr};
	}
	surreal operator-(const surreal&b)const{
		return *this+(-b);
	}
	surreal operator*(const surreal&b)const{
		set<surreal> rl,rr;
		for(auto&i:l){
			for(auto&j:b.l)rl.insert(i*b+*this*j-i*j);
			for(auto&j:b.r)rr.insert(i*b+*this*j-i*j);
		}
		for(auto&i:r){
			for(auto&j:b.l)rr.insert(i*b+*this*j-i*j);
			for(auto&j:b.r)rl.insert(i*b+*this*j-i*j);
		}
		return {rl,rr};
	}
};
surreal zero{{},{}},one{{zero},{}},negone{{},{zero}},half={{zero},{one}},two={{one},{}};
int main(){
	assert(half*two-one==one+negone);
	return 0;
}
