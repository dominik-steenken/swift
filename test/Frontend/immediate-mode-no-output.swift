// REQUIRES: swift_interpreter
// XFAIL: CPU=s390x
// RUN: %empty-directory(%t)
// RUN: cd %t && %target-swift-frontend -interpret %S/../Inputs/empty.swift
// RUN: not ls %t/*
