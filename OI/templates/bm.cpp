
#include <cstdio>
#include <cstring>
#include <cmath>
#include <algorithm>
#include <vector>
#include <string>
#include <map>
#include <set>
#include <cassert>
using namespace std;
#define rep(i,a,n) for (int i=a;i<n;i++)
#define per(i,a,n) for (int i=n-1;i>=a;i--)
#define pb push_back
#define mp make_pair
#define all(x) (x).begin(),(x).end()
#define fi first
#define se second
#define SZ(x) ((int)(x).size())
typedef vector<int> VI;
typedef long long ll;
typedef pair<int, int> PII;
const ll mod = 998244353;
ll powmod(ll a, ll b) { ll res = 1; a %= mod; assert(b >= 0); for (; b; b >>= 1) { if (b & 1)res = res * a%mod; a = a * a%mod; }return res; }
// head
 
int _;
ll n;
namespace linear_seq {
	const int N = 10010;
	ll res[N], base[N], _c[N], _md[N];
 
	vector<int> Md;
	void mul(ll *a, ll *b, int k) {
		rep(i, 0, k + k) _c[i] = 0;
		rep(i, 0, k) if (a[i]) rep(j, 0, k) _c[i + j] = (_c[i + j] + a[i] * b[j]) % mod;
		for (int i = k + k - 1; i >= k; i--) if (_c[i])
			rep(j, 0, SZ(Md)) _c[i - k + Md[j]] = (_c[i - k + Md[j]] - _c[i] * _md[Md[j]]) % mod;
		rep(i, 0, k) a[i] = _c[i];
	}
	int solve(ll n, VI a, VI b) { // a 系数 b 初值 b[n+1]=a[0]*b[n]+...
								  //        printf("%d\n",SZ(b));
		ll ans = 0, pnt = 0;
		int k = SZ(a);
		assert(SZ(a) == SZ(b));
		rep(i, 0, k) _md[k - 1 - i] = -a[i]; _md[k] = 1;
		Md.clear();
		rep(i, 0, k) if (_md[i] != 0) Md.push_back(i);
		rep(i, 0, k) res[i] = base[i] = 0;
		res[0] = 1;
		while ((1ll << pnt) <= n) pnt++;
		for (int p = pnt; p >= 0; p--) {
			mul(res, res, k);
			if ((n >> p) & 1) {
				for (int i = k - 1; i >= 0; i--) res[i + 1] = res[i]; res[0] = 0;
				rep(j, 0, SZ(Md)) res[Md[j]] = (res[Md[j]] - res[k] * _md[Md[j]]) % mod;
			}
		}
		rep(i, 0, k) ans = (ans + res[i] * b[i]) % mod;
		if (ans<0) ans += mod;
		return ans;
	}
	VI BM(VI s) {
		VI C(1, 1), B(1, 1);
		int L = 0, m = 1, b = 1;
		rep(n, 0, SZ(s)) {
			ll d = 0;
			rep(i, 0, L + 1) d = (d + (ll)C[i] * s[n - i]) % mod;
			if (d == 0) ++m;
			else if (2 * L <= n) {
				VI T = C;
				ll c = mod - d * powmod(b, mod - 2) % mod;
				while (SZ(C)<SZ(B) + m) C.pb(0);
				rep(i, 0, SZ(B)) C[i + m] = (C[i + m] + c * B[i]) % mod;
				L = n + 1 - L; B = T; b = d; m = 1;
			}
			else {
				ll c = mod - d * powmod(b, mod - 2) % mod;
				while (SZ(C)<SZ(B) + m) C.pb(0);
				rep(i, 0, SZ(B)) C[i + m] = (C[i + m] + c * B[i]) % mod;
				++m;
			}
		}
		return C;
	}
	void gao(VI a) {
		VI c = BM(a);
		c.erase(c.begin());
		rep(i, 0, SZ(c)) c[i] = (mod - c[i]) % mod;
		for(int i:c)printf("%d\n",i);
	}
};
 
int main() {
	linear_seq::gao({
409936575
,
192597468
,
476421838
,
576110425
,
318564856
,
240238768
,
448132330
,
64697764
,
151412623
,
936364873
,
412610938
,
328940106
,
374641629
,
615816977
,
556230513
,
372343692
,
705593862
,
484284182
,
831545068
,
208266545
,
877771787
,
459158996
,
195711370
,
398184927
,
970174727
,
819323782
,
111381420
,
761953311
,
586111138
,
826920199
,
252391404
,
680841093
,
355601779
,
807883733
,
419860428
,
886787652
,
985547772
,
734608709
,
604632447
,
163009835
,
339950780
,
322423489
,
443502423
,
661806042
,
78092039
,
684793393
,
304399914
,
248338918
,
957806879
,
259005960
,
333548205
,
234588243
,
172812899
,
717168371
,
213778993
,
587496233
,
79518791
,
32509245
,
566691549
,
875023573
,
611928448
,
706312302
,
491889238
,
974074361
,
854886866
,
171817789
,
501230356
,
728279669
,
314752212
,
430720629
,
109843172
,
614973091
,
760184214
,
849977201
,
424374881
,
250264102
,
174168968
,
485843518
,
217690808
,
660033041
,
740381228
,
578383889
,
96492142
,
103437291
,
61187539
,
199127452
,
128679497
,
48805363
,
398733868
,
803555478
,
1372348
,
585645024
,
428587277
,
487294413
,
617313158
,
708615769
,
881377945
,
709451511
,
738778508
,
});
}
