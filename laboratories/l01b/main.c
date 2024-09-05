void exit(int code) {
	__asm__ __volatile__(
		"mv a0, %0           # return code\n"
		"li a7, 93           # syscall exit (64) \n"
		"ecall"
		:             // Output list
		:"r"(code)    // Input list
		: "a0", "a7"
	);
}

void write(int __fd, const void *__buf, int __n) {
	__asm__ __volatile__(
		"mv a0, %0           # file descriptor\n"
		"mv a1, %1           # buffer \n"
		"mv a2, %2           # size \n"
		"li a7, 64           # syscall write (64) \n"
		"ecall"
		:   // Output list
		:"r"(__fd), "r"(__buf), "r"(__n)    // Input list
		: "a0", "a1", "a2", "a7"
	);
}

int read(int __fd, const void *__buf, int __n) {
	int ret_val;
	__asm__ __volatile__(
		"mv a0, %1           # file descriptor\n"
		"mv a1, %2           # buffer \n"
		"mv a2, %3           # size \n"
		"li a7, 63           # syscall read code (63) \n"
		"ecall               # invoke syscall \n"
		"mv %0, a0           # move return value to ret_val\n"
		: "=r"(ret_val)                   // Output list
		: "r"(__fd), "r"(__buf), "r"(__n) // Input list
		: "a0", "a1", "a2", "a7"
	);

	return ret_val;
}


char input[5];

int main() {
    int n = read(0, (void *) input, 5);

	/* According to the ASCII chart the number from 0 to 9 are respectively from 48 to 57. The operators though are '+' 43, '*' 42 and '-' 45. */

	char result;

	switch (input[2]) {
		case 42:
			result = ((input[0] - 48) * (input[4] - 48) + 48);
			break;

		case 43:
			result = input[0] + input[4] - 48;
			break;

		case 45:
			result = input[0] - input[4] + 48;
			break;
	}

	input[0] = result;
	input[1] = '\n';

	write(1, (void *) input, 2);

    return 0;
}

void _start() {
	int ret_code = main();
	exit(ret_code);
}