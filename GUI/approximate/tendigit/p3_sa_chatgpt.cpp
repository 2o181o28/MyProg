#include <bits/stdc++.h>
using namespace std;

static constexpr double PI = 3.1415926535897932384626433832795;

struct Vec3{
    double x,y,z;
    Vec3() : x(0),y(0),z(0) {}
    Vec3(double X,double Y,double Z):x(X),y(Y),z(Z){}
    Vec3 operator+(const Vec3& o) const { return {x+o.x,y+o.y,z+o.z}; }
    Vec3 operator-(const Vec3& o) const { return {x-o.x,y-o.y,z-o.z}; }
    Vec3 operator*(double s) const { return {x*s,y*s,z*s}; }
    Vec3 operator/(double s) const { return {x/s,y/s,z/s}; }
};
static inline double dot(const Vec3& a,const Vec3& b){ return a.x*b.x+a.y*b.y+a.z*b.z; }
static inline Vec3 cross(const Vec3& a,const Vec3& b){
    return {a.y*b.z-a.z*b.y, a.z*b.x-a.x*b.z, a.x*b.y-a.y*b.x};
}
static inline double norm2(const Vec3& a){ return dot(a,a); }
static inline double norm(const Vec3& a){ return sqrt(norm2(a)); }
static inline Vec3 normalize(const Vec3& a){
    double n = norm(a);
    if(n < 1e-15) return {0,0,0};
    return a / n;
}

struct Mat3{
    // row-major
    double m[3][3];
    Vec3 operator*(const Vec3& v) const{
        return {
            m[0][0]*v.x + m[0][1]*v.y + m[0][2]*v.z,
            m[1][0]*v.x + m[1][1]*v.y + m[1][2]*v.z,
            m[2][0]*v.x + m[2][1]*v.y + m[2][2]*v.z
        };
    }
};

static inline Mat3 rotZYX(double roll,double pitch,double yaw){
    // R = Rz(yaw)*Ry(pitch)*Rx(roll)
    double cr=cos(roll), sr=sin(roll);
    double cp=cos(pitch), sp=sin(pitch);
    double cy=cos(yaw), sy=sin(yaw);

    Mat3 Rz{{ {cy,-sy,0}, {sy,cy,0}, {0,0,1} }};
    Mat3 Ry{{ {cp,0,sp}, {0,1,0}, {-sp,0,cp} }};
    Mat3 Rx{{ {1,0,0}, {0,cr,-sr}, {0,sr,cr} }};

    // multiply: Rz*Ry*Rx
    auto mul = [](const Mat3& A,const Mat3& B){
        Mat3 C{};
        for(int i=0;i<3;i++) for(int j=0;j<3;j++){
            C.m[i][j]=0;
            for(int k=0;k<3;k++) C.m[i][j]+=A.m[i][k]*B.m[k][j];
        }
        return C;
    };
    return mul(mul(Rz,Ry),Rx);
}

struct Pose{
    Vec3 t;
    double roll,pitch,yaw;
};

static constexpr int FACES[4][3] = {
    {0,1,2},{0,1,3},{0,2,3},{1,2,3}
};
static constexpr int EDGES[6][2] = {
    {0,1},{0,2},{0,3},{1,2},{1,3},{2,3}
};

static inline double tetra_edge_from_volume(double V=1.0){
    // V = a^3 / (6*sqrt(2))
    return cbrt(6.0*sqrt(2.0)*V);
}

static inline array<Vec3,4> base_tetra(double edge){
    // points (±1,±1,±1) with even number of negatives -> regular tetra with edge 2*sqrt(2)
    array<Vec3,4> v = {
        Vec3{ 1, 1, 1},
        Vec3{ 1,-1,-1},
        Vec3{-1, 1,-1},
        Vec3{-1,-1, 1}
    };
    double cur = 2.0*sqrt(2.0);
    double s = edge/cur;
    for(auto &p: v) p = p*s;
    return v; // already centered
}

static inline array<Vec3,4> transform_tetra(const array<Vec3,4>& base, const Pose& p){
    Mat3 R = rotZYX(p.roll,p.pitch,p.yaw);
    array<Vec3,4> out;
    for(int i=0;i<4;i++) out[i] = R*base[i] + p.t;
    return out;
}

// ---------------- SAT tetra vs tetra ----------------

static inline Vec3 face_normal(const array<Vec3,4>& T, int a,int b,int c){
    Vec3 ab = T[b]-T[a];
    Vec3 ac = T[c]-T[a];
    Vec3 n = cross(ab,ac);
    return normalize(n);
}

static inline pair<double,double> proj_interval(const array<Vec3,4>& T, const Vec3& axis){
    double mn = dot(T[0],axis), mx = mn;
    for(int i=1;i<4;i++){
        double d = dot(T[i],axis);
        mn = min(mn,d);
        mx = max(mx,d);
    }
    return {mn,mx};
}

static inline bool overlap(const pair<double,double>& A, const pair<double,double>& B, double eps=1e-10){
    return !(A.second < B.first - eps || B.second < A.first - eps);
}

static inline bool tetra_intersect_SAT(const array<Vec3,4>& A, const array<Vec3,4>& B){
    vector<Vec3> axes;
    axes.reserve(64);

    // face normals
    for(int f=0;f<4;f++){
        Vec3 nA = face_normal(A, FACES[f][0],FACES[f][1],FACES[f][2]);
        if(norm2(nA) > 0) axes.push_back(nA);
        Vec3 nB = face_normal(B, FACES[f][0],FACES[f][1],FACES[f][2]);
        if(norm2(nB) > 0) axes.push_back(nB);
    }
    // edge directions
    Vec3 eA[6], eB[6];
    for(int i=0;i<6;i++){
        eA[i] = normalize(A[EDGES[i][1]] - A[EDGES[i][0]]);
        eB[i] = normalize(B[EDGES[i][1]] - B[EDGES[i][0]]);
    }
    for(int i=0;i<6;i++) for(int j=0;j<6;j++){
        Vec3 ax = cross(eA[i], eB[j]);
        if(norm2(ax) > 1e-20) axes.push_back(normalize(ax));
    }

    for(auto &ax: axes){
        auto ia = proj_interval(A, ax);
        auto ib = proj_interval(B, ax);
        if(!overlap(ia,ib)) return false;
    }
    return true;
}

// ---------------- Minimum Enclosing Ball for <= 12 points ----------------

struct Ball{
    Vec3 c;
    double r2;
};

static inline bool in_ball(const Ball& b, const Vec3& p, double eps=1e-10){
    return norm2(p - b.c) <= b.r2 + eps;
}

static inline Ball ball_from1(const Vec3& p){ return {p, 0.0}; }

static inline Ball ball_from2(const Vec3& a, const Vec3& b){
    Vec3 c = (a+b)*0.5;
    return {c, norm2(a-c)};
}

static inline bool circumcenter_triangle(const Vec3& a,const Vec3& b,const Vec3& c, Vec3& out){
    Vec3 ab = b-a, ac = c-a;
    Vec3 n = cross(ab,ac);
    double nn = norm2(n);
    if(nn < 1e-24) return false;

    // Choose basis u along ab, v in plane
    Vec3 u = normalize(ab);
    Vec3 v = normalize(cross(n,u));

    double bx = dot(ab,u), by = dot(ab,v); // by ~ 0
    double cx = dot(ac,u), cy = dot(ac,v);

    // In 2D, a=(0,0), b=(bx,by), c=(cx,cy)
    double d = 2.0*(0*(by-cy) + bx*(cy-0) + cx*(0-by));
    if(fabs(d) < 1e-18) return false;

    double b2 = bx*bx + by*by;
    double c2 = cx*cx + cy*cy;

    double ux = (b2*(cy-0) + c2*(0-by)) / d;
    double uy = (b2*(0-cx) + c2*(bx-0)) / d;

    out = a + u*ux + v*uy;
    return true;
}

static inline Ball ball_from3(const Vec3& a,const Vec3& b,const Vec3& c){
    Vec3 cc;
    if(!circumcenter_triangle(a,b,c,cc)){
        // fallback to best 2-point ball that covers the 3 points
        Ball best{{0,0,0}, 1e300};
        Ball b1 = ball_from2(a,b);
        if(in_ball(b1,c) && b1.r2 < best.r2) best = b1;
        Ball b2 = ball_from2(a,c);
        if(in_ball(b2,b) && b2.r2 < best.r2) best = b2;
        Ball b3 = ball_from2(b,c);
        if(in_ball(b3,a) && b3.r2 < best.r2) best = b3;
        if(best.r2 > 1e299){
            // collinear weirdness: return max pair
            double dAB=norm2(a-b), dAC=norm2(a-c), dBC=norm2(b-c);
            if(dAB>=dAC && dAB>=dBC) return ball_from2(a,b);
            if(dAC>=dAB && dAC>=dBC) return ball_from2(a,c);
            return ball_from2(b,c);
        }
        return best;
    }
    return {cc, norm2(a-cc)};
}

static inline bool circumsphere4(const Vec3& a,const Vec3& b,const Vec3& c,const Vec3& d, Vec3& center){
    // Solve A * x = rhs
    // Rows are (b-a), (c-a), (d-a)
    double A[3][3] = {
        {b.x-a.x, b.y-a.y, b.z-a.z},
        {c.x-a.x, c.y-a.y, c.z-a.z},
        {d.x-a.x, d.y-a.y, d.z-a.z}
    };
    double rhs[3] = {
        0.5*(dot(b,b)-dot(a,a)),
        0.5*(dot(c,c)-dot(a,a)),
        0.5*(dot(d,d)-dot(a,a))
    };
    // Gaussian elimination (3x3)
    int piv[3]={0,1,2};
    for(int i=0;i<3;i++){
        int p=i;
        for(int r=i;r<3;r++){
            if(fabs(A[r][i]) > fabs(A[p][i])) p=r;
        }
        if(fabs(A[p][i]) < 1e-14) return false;
        if(p!=i){
            swap(A[p],A[i]);
            swap(rhs[p],rhs[i]);
        }
        double inv = 1.0/A[i][i];
        for(int j=i;j<3;j++) A[i][j]*=inv;
        rhs[i]*=inv;
        for(int r=0;r<3;r++) if(r!=i){
            double f=A[r][i];
            if(fabs(f)<1e-18) continue;
            for(int j=i;j<3;j++) A[r][j]-=f*A[i][j];
            rhs[r]-=f*rhs[i];
        }
    }
    center = {rhs[0],rhs[1],rhs[2]};
    return true;
}

static inline bool ball_covers_all(const Ball& b, const vector<Vec3>& pts, double eps=1e-10){
    for(auto &p: pts) if(!in_ball(b,p,eps)) return false;
    return true;
}

// Welzl-style randomized incremental but iterative (n is tiny)
static Ball min_enclosing_ball(vector<Vec3> pts, std::mt19937_64 &rng){
    shuffle(pts.begin(), pts.end(), rng);
    Ball b{{0,0,0}, -1};

    auto ensure = [&](Ball &B, double eps){
        // If numerics miss, inflate a tiny bit
        if(B.r2 < 0) return;
        if(!ball_covers_all(B, pts, eps)){
            // inflate r2 to max distance
            double mx=0;
            for(auto &p: pts) mx = max(mx, norm2(p - B.c));
            B.r2 = mx;
        }
    };

    for(size_t i=0;i<pts.size();i++){
        if(b.r2>=0 && in_ball(b, pts[i])) continue;
        b = ball_from1(pts[i]);
        for(size_t j=0;j<i;j++){
            if(in_ball(b, pts[j])) continue;
            b = ball_from2(pts[i], pts[j]);
            for(size_t k=0;k<j;k++){
                if(in_ball(b, pts[k])) continue;
                b = ball_from3(pts[i], pts[j], pts[k]);
                for(size_t m=0;m<k;m++){
                    if(in_ball(b, pts[m])) continue;
                    Vec3 cc;
                    if(circumsphere4(pts[i],pts[j],pts[k],pts[m],cc)){
                        b = {cc, norm2(pts[i]-cc)};
                    }else{
                        // degenerate: fallback to best among 3-point balls
                        Ball best{{0,0,0}, 1e300};
                        Ball b1=ball_from3(pts[i],pts[j],pts[k]); if(ball_covers_all(b1, pts, 1e-9) && b1.r2<best.r2) best=b1;
                        Ball b2=ball_from3(pts[i],pts[j],pts[m]); if(ball_covers_all(b2, pts, 1e-9) && b2.r2<best.r2) best=b2;
                        Ball b3=ball_from3(pts[i],pts[k],pts[m]); if(ball_covers_all(b3, pts, 1e-9) && b3.r2<best.r2) best=b3;
                        Ball b4=ball_from3(pts[j],pts[k],pts[m]); if(ball_covers_all(b4, pts, 1e-9) && b4.r2<best.r2) best=b4;
                        if(best.r2<1e299) b=best;
                    }
                }
            }
        }
    }
    ensure(b, 1e-10);
    return b;
}

// ---------------- Optimization ----------------

struct EvalRes{
    double cost; // radius + penalty
    double radius;
    Ball ball;
    bool feasible;
};

static EvalRes evaluate(const array<Vec3,4>& base, const array<Pose,3>& poses, mt19937_64 &rng){
    array<array<Vec3,4>,3> T;
    for(int i=0;i<3;i++) T[i]=transform_tetra(base, poses[i]);

    // intersection test
    for(int i=0;i<3;i++) for(int j=i+1;j<3;j++){
        if(tetra_intersect_SAT(T[i],T[j])){
            // penalty: return large cost; still compute radius for debugging if you want
            return {1e9, 1e9, {{0,0,0}, 1e18}, false};
        }
    }

    vector<Vec3> pts;
    pts.reserve(12);
    for(int i=0;i<3;i++) for(int v=0;v<4;v++) pts.push_back(T[i][v]);

    Ball b = min_enclosing_ball(pts, rng);
    double R = sqrt(max(0.0, b.r2));
    // Safety sanity check: R must be >= single tetra circumradius
    // (not enforced as constraint; but useful debug guard)
    return {R, R, b, true};
}

static inline double urand01(mt19937_64 &rng){
    return (rng() >> 11) * (1.0/9007199254740992.0); // 2^53
}
static inline double urand(mt19937_64 &rng, double lo, double hi){
    return lo + (hi-lo)*urand01(rng);
}

static Pose random_pose(mt19937_64 &rng, double R0){
    Pose p;
    p.t = {urand(rng,-R0,R0), urand(rng,-R0,R0), urand(rng,-R0,R0)};
    p.roll  = urand(rng,0,2*PI);
    p.pitch = urand(rng,0,2*PI);
    p.yaw   = urand(rng,0,2*PI);
    return p;
}

static Pose propose(const Pose& p, mt19937_64 &rng, double step_t, double step_a){
    Pose q = p;
    q.t.x += urand(rng,-step_t,step_t);
    q.t.y += urand(rng,-step_t,step_t);
    q.t.z += urand(rng,-step_t,step_t);
    q.roll  += urand(rng,-step_a,step_a);
    q.pitch += urand(rng,-step_a,step_a);
    q.yaw   += urand(rng,-step_a,step_a);
    return q;
}

int main(){
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    double edge = tetra_edge_from_volume(1.0);
    auto base = base_tetra(edge);

    // single tetra circumradius sanity:
    // R = sqrt(6)/4 * a
    double R_single = sqrt(6.0)/4.0 * edge;
    cerr << "edge=" << edge << " single_circumR=" << R_single << "\n";

    mt19937_64 rng(42);

    const int RESTARTS = 30;
    const int STEPS = 200000;

    double bestR = 1e100;
    array<Pose,3> bestPoses{};
    Ball bestBall{{0,0,0}, 1e18};

    for(int rs=0; rs<RESTARTS; rs++){
        array<Pose,3> poses;
        double R0_init = 2.5;
        for(int i=0;i<3;i++) poses[i] = random_pose(rng, R0_init);

        // SA schedule
        double T0 = 0.15, T1 = 1e-4;
        double st0 = 0.18, st1 = 0.01;
        double sa0 = 0.25, sa1 = 0.01;

        EvalRes cur = evaluate(base, poses, rng);

        for(int it=0; it<STEPS; it++){
            double frac = (double)it / max(1, STEPS-1);
            double T = T0 * pow(T1/T0, frac);
            double step_t = st0 * pow(st1/st0, frac);
            double step_a = sa0 * pow(sa1/sa0, frac);

            int idx = (int)(rng()%3);
            array<Pose,3> np = poses;
            np[idx] = propose(poses[idx], rng, step_t, step_a);

            EvalRes nxt = evaluate(base, np, rng);

            bool accept = false;
            if(nxt.cost <= cur.cost) accept = true;
            else{
                double d = nxt.cost - cur.cost;
                double prob = exp(-d / max(1e-12, T));
                if(urand01(rng) < prob) accept = true;
            }
            if(accept){
                poses = np;
                cur = nxt;
            }

            if(cur.feasible && cur.radius < bestR){
                bestR = cur.radius;
                bestPoses = poses;
                bestBall = cur.ball;

                double Vball = (4.0/3.0)*PI*bestR*bestR*bestR;
                cerr << "[rs " << (rs+1) << "/" << RESTARTS << " it " << it
                     << "] bestR=" << fixed << setprecision(9) << bestR
                     << "  V=" << setprecision(9) << Vball << "\n";
            }
        }
    }

    cout << fixed << setprecision(12);
    cout << "BEST_RADIUS " << bestR << "\n";
    cout << "BEST_VOLUME " << (4.0/3.0)*PI*bestR*bestR*bestR << "\n";
    cout << "SPHERE_CENTER " << bestBall.c.x << " " << bestBall.c.y << " " << bestBall.c.z << "\n";
    for(int i=0;i<3;i++){
        cout << "POSE " << i << " T " << bestPoses[i].t.x << " " << bestPoses[i].t.y << " " << bestPoses[i].t.z
             << " EUL " << bestPoses[i].roll << " " << bestPoses[i].pitch << " " << bestPoses[i].yaw << "\n";
    }
    return 0;
}
