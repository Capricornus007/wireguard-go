#!/usr/bin/env bash

set -e -o pipefail

# tun/tuntest 不在刪除清單裡（2026-10-28）：sing-box 的
# transport/amneziawg/tailscale_device_test.go 會 import
# github.com/sagernet/wireguard-go/tun/tuntest。`go mod tidy` 是真的讀
# **所有 build tag**（含 with_gvisor）下的 *_test.go 依賴的，所以這包一旦缺了，
# NB4A 的 libcore 就一直在 `go mod tidy` 紅（Update sing-box core 工作流 run #76
# 死在這），本機用 `go mod tidy -diff` 也重現同一行錯誤。
# 同上的 conn/bindtest、tun/netstack 目前下游沒人 import，維持刪除。
function remove_unused() {
  git rm -rf --ignore-unmatch \
    .github \
    tests \
    *_test.go \
    **/*_test.go \
    conn/bindtest \
    tun/netstack \
    tun/testdata \
    main*.go \
    *.md
}

remove_unused
remove_unused

go mod tidy
git commit -a -m "Remove unused"
