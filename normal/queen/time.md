| Language    |  n=10  |  n=12   |   n=14   |  n=15   |
| ----------- | :----: | :-----: | :------: | :-----: |
| gcc         | 0.003s | 0.023s  |  0.675s  | 4.345s  |
| g++         | 0.000s | 0.019s  |  0.673s  | 4.361s  |
| c++         | 0.003s | 0.024s  |  0.735s  | 4.674s  |
| c           | 0.003s | 0.019s  |  0.733s  | 4.710s  |
| rust        | 0.002s | 0.027s  |  0.758s  | 4.885s  |
| unsafe Rust | 0.007s | 0.055s  |  0.828s  | 5.271s  |
| pascal      | 0.004s | 0.034s  |  1.141s  | 7.410s  |
| javascript  | 0.297s | 0.356s  |  1.935s  | 10.990s |
| pypy3       | 0.037s | 0.178s  |  2.686s  | 17.569s |
| python3     | 0.122s | 3.112s  | 113.830s |   TLE   |
| bash        | 2.334s | 65.314s |   TLE    |   TLE   |


| Language   | Version                                                      |
| ---------- | ------------------------------------------------------------ |
| g++/gcc    | gcc version 10.0.1 20200411, (compiled with `-Ofast -march=native`) |
| c++/c      | clang version 10.0.0-4ubuntu1, (compiled with `-Ofast -march=native`) |
| rust       | rustc 1.41.0, (compiled with `-C opt-level=3 -C target-cpu=native`) |
| pascal     | Free Pascal Compiler version 3.0.4+dfsg-23 [2019/11/25] for x86_64, (compiled with `-O3`) |
| javascript | nodejs v10.19.0                                              |
| pypy3      | PyPy 7.3.1 with GCC 7.3.1 20180303                           |
| python3    | Python 3.8.2                                                 |
| bash       | GNU bash，版本 5.0.16(1)-release (x86_64-pc-linux-gnu)       |
