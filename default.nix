{ pkgs ? import <nixpkgs> {}, ... }:

{

  # pkgs
  openjdk_10_0_2 = pkgs.callPackage ./pkgs/openjdk_10_0_2 {};
  firefox_62_0_3 = pkgs.callPackage ./pkgs/firefox_62_0_3 {};

}