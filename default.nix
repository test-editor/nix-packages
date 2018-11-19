{ pkgs ? import <nixpkgs> {}, ... }:

{

  # pkgs
  openjdk_10_0_2 = pkgs.callPackage ./pkgs/openjdk_10_0_2 {};

}