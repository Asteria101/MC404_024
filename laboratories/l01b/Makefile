main.s: main.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax main.c -S -o main.s

main.o: main.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax main.s -c -o main.o

prog.x: main.o
	ld.lld main.o -o prog.x
