#include<bits/stdc++.h>
using namespace std;
using ll=long long;

template<class T,int k> struct num_t{
	using Tp=complex<typename num_t<T,k-1>::Tp>;
};
template<class T> struct num_t<T,0>{
	using Tp=T;
};

template<class T,int k> struct num:num_t<T,k>::Tp{
	using B=typename num_t<T,k>::Tp;
	num():B(){}
	num(B vl):B(vl){}
	template<random_access_iterator It> num(It a){
		if constexpr(k==1){
			*this=complex<T>{*a,a[1]};
		}else{
			*this=B{
				(typename num_t<T,k-1>::Tp)(num<T,k-1>{a}),
				(typename num_t<T,k-1>::Tp)(num<T,k-1>{a+(1<<(k-1))})
			};
		}
	}
	num(initializer_list<T> il){
		assert(il.size()==(1<<k));
		*this=num(data(il));
	}
	num(T vl){
		static T v[1<<k]={0};v[0]=vl;
		*this=num(v);
	}
	num<T,k-1> re(){return this->real();}
	num<T,k-1> im(){return this->imag();}
};

template<class T,int k> T norm(num<T,k> z){
	return norm(z.re())+norm(z.im());
}
template<class T> T norm(num<T,1> z){return norm(complex<T>(z));}
template<class T,int k> T abs(num<T,k> z){
	return sqrt(norm(z));
}

template<class T,int k> T abs_1(num<T,k> z){
	return sqrt(abs_1(num<T,k-1>{z.real()*z.real()+z.imag()*z.imag()}));
}
template<class T> T abs_1(num<T,1> z){return abs(complex<T>(z));}

template<class T,int k> num<T,k> rnd_num(){
	uniform_real_distribution<T> U(-1.,1.);
	default_random_engine E{random_device{}()};
	vector<T> v(1<<k);
	for(int i=0;i<(1<<k);i++)v[i]=U(E);
	return {v.data()};
}
template<class T,int k> num<T,k> exp(num<T,k> x){
	num<T,k> res=T(0),b=T(1);
	for(int t=0;t<=50;t++){
		res+=b;
		b*=x;
		b=b/num<T,k>(T(t+1));
		if(abs(b)<T(1e-14))break;
	}
	return res;
}

const int k=2;
using ld=long double;
using cmp=num<ld,k>;
int main(){
	cmp a{0,1,1,0},b{1,0,0,-1};
	cout<<(a*b)<<endl;
	return 0;
}
