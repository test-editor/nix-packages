{ pkgs ? import <nixpkgs> {}, ... }:

{

  # pkgs
  openjdk_10_0_2 = pkgs.callPackage ./pkgs/openjdk_10_0_2 {};
  firefox_62_0_3 = pkgs.callPackage ./pkgs/firefox_62_0_3 {};
  firefox_67_0 = pkgs.callPackage ./pkgs/firefox_67_0 {};
  firefox_60_2_2_esr = pkgs.callPackage ./pkgs/firefox_60_2_2_esr {};

  firefox_latest = pkgs.callPackage ./pkgs/firefox_67_0 {};
  firefox_esr = pkgs.callPackage ./pkgs/firefox_60_2_2_esr {};
}
