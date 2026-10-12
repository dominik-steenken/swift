// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -target x86_64-apple-macosx10.15 -emit-module -parse-stdlib -o %t -module-name empty -module-link-name empty %S/../Inputs/empty.swift
// RUN: %target-swift-emit-ir -target x86_64-apple-macosx10.15 -lto=llvm-full -parse-stdlib -I %t %S/lto_autolink.swift | %FileCheck %s --check-prefix CHECK-MACHO
// RUN: %target-swift-emit-ir -target x86_64-apple-macosx10.15 -lto=llvm-thin -parse-stdlib -I %t %S/lto_autolink.swift | %FileCheck %s --check-prefix CHECK-MACHO

// REQUIRES: CODEGENERATOR=X86

// CHECK-MACHO-DAG: !llvm.linker.options = !{
// CHECK-MACHO-DAG: !{{[0-9]+}} = !{!"-lempty"}

// Ensure the dependent libraries embedded by clang are merged.

// RUN: %target-swift-frontend -target x86_64-apple-macosx10.15 -emit-module -parse-stdlib -o %t -module-name empty -module-link-name empty %S/../Inputs/empty.swift
// RUN: %target-swift-emit-ir -target x86_64-apple-macosx10.15 -lto=llvm-full -parse-stdlib -nostdimport -I %t -I %S/Inputs -DTEST_CLANG_OPTIONS_MERGE %S/lto_autolink.swift | %FileCheck %s --check-prefix CHECK-MACHO-MERGE
// RUN: %target-swift-emit-ir -target x86_64-apple-macosx10.15 -lto=llvm-thin -parse-stdlib -nostdimport -I %t -I %S/Inputs -DTEST_CLANG_OPTIONS_MERGE %S/lto_autolink.swift | %FileCheck %s --check-prefix CHECK-MACHO-MERGE

// CHECK-MACHO-MERGE-DAG: !llvm.linker.options = !{
// CHECK-MACHO-MERGE-DAG: !{{[0-9]+}} = !{!"-lempty"}
// CHECK-MACHO-MERGE-DAG: !{{[0-9]+}} = !{!"-lautolink-module-map-link"}
