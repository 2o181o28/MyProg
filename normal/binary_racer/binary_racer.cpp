//usr/bin/c++ $0 -o ${0%.cpp} -Wall -Ofast -lX11 -lXtst -std=c++20; ${0%.cpp} $*; exit
//  This program is used to complete the Binary Racer achievement in the Turing
//  Complete game. You need to create a shortcut manually with the command
//  "binary_racer.cpp", then click "Start" inside the Binary Racer level and
//  press the shortcut you set.
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XTest.h>
#include <unistd.h>

#include <algorithm>
#include <bit>
#include <cassert>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unordered_map>
#include <vector>

// won't work in other resolution due to hard-coded coordinates
const int W = 1600, H = 900;
const int POS[][2] = {{1100, 770}, {1000, 770}, {900, 770}, {800, 770},
                      {700, 770},  {620, 770},  {520, 770}, {420, 770}};

struct RGB {
    uint8_t R, G, B;
    bool operator==(const RGB &) const = default;
};
const RGB NUM_RGB = {0xE4, 0x9F, 0x44};

const std::unordered_map<int, int> NUM_TABLE = {
    {383, 0}, {258, 1}, {336, 2}, {324, 3}, {365, 4},
    {357, 5}, {367, 6}, {259, 7}, {410, 8}, {369, 9}};

bool vis[W][H];
int mn, siz;

RGB get_pixel(XImage *image, int x, int y) {
    auto pixel = XGetPixel(image, x, y);
    auto extract = [&](unsigned mask) {
        return uint8_t((pixel & mask) >> std::countr_zero(mask));
    };
    return {extract(image->red_mask), extract(image->green_mask),
            extract(image->blue_mask)};
}

void mouse_click(Display *display, int x, int y, int button = Button1) {
    // move to (x, y)
    XTestFakeMotionEvent(display, DefaultScreen(display), x, y, 0);
    XFlush(display);

    // click button
    XTestFakeButtonEvent(display, button, true, 0);
    XFlush(display);

    usleep(10000);

    // release mouse
    XTestFakeButtonEvent(display, button, false, 0);
    XFlush(display);
}

XImage *get_image(Display *display) {
    Window window = RootWindow(display, DefaultScreen(display));
    return XGetImage(display, window, 0, 0, W, H, AllPlanes, XYPixmap);
}

void dfs(XImage *image, int x, int y) {
    if (x < 0 || x >= W || y < 0 || y >= H || vis[x][y] ||
        get_pixel(image, x, y) != NUM_RGB)
        return;
    vis[x][y] = 1;
    mn = std::min(mn, x);
    siz++;
    const int dx[4] = {0, 1, 0, -1}, dy[4] = {1, 0, -1, 0};
    for (int i = 0; i < 4; i++) {
        dfs(image, x + dx[i], y + dy[i]);
    }
}

int parse_int(XImage *image) {
    std::vector<std::pair<int, int>> v;
    // auto F = fopen("log.txt", "w");

    memset(vis, 0, sizeof vis);
    for (int y = 300; y <= 500; y++)
        for (int x = 0; x < W; x++)
            if (!vis[x][y] && get_pixel(image, x, y) == NUM_RGB) {
                mn = W + 1;
                siz = 0;
                dfs(image, x, y);
                // fprintf(F, "%d : %d\n", mn, siz);
                auto it = NUM_TABLE.find(siz);
                assert(it != NUM_TABLE.end());
                v.push_back({mn, it->second});
            }

    // fclose(F);
    if (v.empty()) return -1;
    std::ranges::sort(v);
    int r = 0;
    for (auto &[_, x] : v) r = r * 10 + x;
    return r;
}

int main() {
    auto display = XOpenDisplay(nullptr);
    while (true) {
        auto image = get_image(display);
        auto num = parse_int(image);
        if (num == -1) {
            XDestroyImage(image);
            break;
        }

        for (int i = 0; i < 8; i++)
            if (num >> i & 1) {
                mouse_click(display, POS[i][0], POS[i][1]);
            }

        // submit
        mouse_click(display, 800, 850);
        usleep(100000);
        XDestroyImage(image);
    }
    XCloseDisplay(display);
    return 0;
}
