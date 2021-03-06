; RUN: llc < %s -march=aarch64 -mattr=+no-quad-ldst-pairs -verify-machineinstrs -asm-verbose=false | FileCheck %s
; RUN: llc < %s -march=aarch64 -mcpu=exynos-m1 -verify-machineinstrs -asm-verbose=false | FileCheck %s

; CHECK-LABEL: test_nopair_st
; CHECK: str
; CHECK: stur
; CHECK-NOT: stp
define void @test_nopair_st(double* %ptr, <2 x double> %v1, <2 x double> %v2) {
  %tmp1 = bitcast double* %ptr to <2 x double>*
  store <2 x double> %v2, <2 x double>* %tmp1, align 16
  %add.ptr = getelementptr inbounds double, double* %ptr, i64 -2
  %tmp = bitcast double* %add.ptr to <2 x double>*
  store <2 x double> %v1, <2 x double>* %tmp, align 16
  ret void
}

; CHECK-LABEL: test_nopair_ld
; CHECK: ldr
; CHECK: ldr
; CHECK-NOT: ldp
define <2 x i64> @test_nopair_ld(i64* %p) {
  %a1 = bitcast i64* %p to <2 x i64>*
  %tmp1 = load <2 x i64>, < 2 x i64>* %a1, align 8
  %add.ptr2 = getelementptr inbounds i64, i64* %p, i64 2
  %a2 = bitcast i64* %add.ptr2 to <2 x i64>*
  %tmp2 = load <2 x i64>, <2 x i64>* %a2, align 8
  %add = add nsw <2 x i64> %tmp1, %tmp2
  ret <2 x i64> %add
}
