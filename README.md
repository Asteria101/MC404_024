# MC404 2024
Laboratories for Unicamp's MC404. Course given by Profesor Borin on the second semester of 2024.

Bellow you will find the laboratories resolutions and their topic. As well as the link to the [ALE Exercise Book](https://riscv-programming.org/ale-exercise-book/book/title-page.html).

> [!IMPORTANT]
> To compile a C code to a RISC-V Assembly executable (.x), run:
> ```console
>   clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax file1.c -S -o file1.s
>   clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax file1.s -c -o file1.o
>   ld.lld file.o -o file.x
>```


## Labs 💻

- [x] [Lab 1a](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l01a) &rarr; Initial steps into RISC-V Assembly, production of Makefile **10/10**
    - [1.1](https://riscv-programming.org/ale-exercise-book/book/ch01-01-code-generation-tools.html) and [1.2](https://riscv-programming.org/ale-exercise-book/book/ch01-02-code-generation-tools.html)

- [x] [Lab 1b](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l01b) &rarr; Simple calculator **10/10**
    - [2.2](https://riscv-programming.org/ale-exercise-book/book/ch02-02-using-assistant.html)

- [x] [Lab 2](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l02) &rarr; Debugging in Assembly Language **5.65/10** 
    - [2.3](https://riscv-programming.org/ale-exercise-book/book/ch02-03-debugging-a-program.html)

- [x] [Lab 3](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l03) (Fix 🐛) &rarr; Number base conversion in C **10/10**
    - [3.1](https://riscv-programming.org/ale-exercise-book/book/ch03-01-base-conversion-c.html#number-base-conversion-in-c)

- [x] [Lab 5a](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l05a) &rarr; Bit masking and shift operations **10/10**
    - [5.1](https://riscv-programming.org/ale-exercise-book/book/ch05-01-bit-masking-shift-operations.html)

- [x] [Lab 5b](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l05b) &rarr; RISC-V instruction encoding **10/10**
    - [5.2](https://riscv-programming.org/ale-exercise-book/book/ch05-02-riscv-instruction-encoding.html)

- [x] [Lab 6a](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l06a) &rarr; Square Root **10/10**
    - [6.1](https://riscv-programming.org/ale-exercise-book/book/ch06-01-square-root.html)

- [x] [Lab 6b](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l06b) &rarr; GPS **10/10**
    - [6.2](https://riscv-programming.org/ale-exercise-book/book/ch06-02-gps.html)

- [x] [Lab 7](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l07) &rarr; Hamming Code **10/10**
    - [6.3](https://riscv-programming.org/ale-exercise-book/book/ch06-03-hamming-code.html)

- [x] [Lab 8a](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l08a) &rarr; Image **10/10**
    - [6.4](https://riscv-programming.org/ale-exercise-book/book/ch06-04-image-on-canvas.html)

- [x] [Lab 8b](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l08b) &rarr; Filter **10/10**
    - [6.5](https://riscv-programming.org/ale-exercise-book/book/ch06-05-apply-filter.html)

- [x] [Lab 9](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l09) &rarr; Custom Search on Linked List **10/10**
    - [6.6](https://riscv-programming.org/ale-exercise-book/book/ch06-06-linked-list.html)

- [x] [Lab 10a](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l10a) &rarr; ABI-compliant Linked List Custom Search **10/10**
    - [6.7](https://riscv-programming.org/ale-exercise-book/book/ch06-07-abi-linked-list.html)

- [x] [Lab 10b](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l10b) &rarr; ABI-compliant Recursive Binary Tree Search **10/10**
    - [6.8](https://riscv-programming.org/ale-exercise-book/book/ch06-08-abi-recursive-binary-tree.html)

- [x] [Lab 11](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l11) &rarr; Car **10/10**
    - [7.1](https://riscv-programming.org/ale-exercise-book/book/ch07-01-peripheral-controlling-the-car.html)

- [x] [Lab 12](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l12) (Fix 🐛) &rarr; Serial Port **10/10**
    - [7.2](https://riscv-programming.org/ale-exercise-book/book/ch07-02-peripheral-using-serial-port.html)

- [x] [Lab 13](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l13) &rarr; ABI compliance and Data Organization on Memory: Mini Labs **10/10**
    - [8.1](https://riscv-programming.org/ale-exercise-book/book/ch08-01-ABI.html) and [8.2](https://riscv-programming.org/ale-exercise-book/book/ch08-02-data-organization.html)

- [x] [Lab 14](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l14) &rarr; External Interrupts: Music box **10/10**
    - [7.3](https://riscv-programming.org/ale-exercise-book/book/ch07-03-interrupts-midi-player.html)

- [x] [Lab 15](https://github.com/Asteria101/MC404_024/tree/main/laboratories/l15) &rarr; Software Interrupts: Controlling car **10/10**
    - [7.4](https://riscv-programming.org/ale-exercise-book/book/ch07-04-interrupts-controlling-the-car.html)