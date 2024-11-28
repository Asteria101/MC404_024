int read(int __fd, const void *__buf, int __n) {
    int ret_val;
    __asm__ __volatile__(
        "mv a0, %1           # file descriptor\n"
        "mv a1, %2           # buffer \n"
        "mv a2, %3           # size \n"
        "li a7, 63           # syscall write code (63) \n"
        "ecall               # invoke syscall \n"
        "mv %0, a0           # move return value to ret_val\n"
        : "=r"(ret_val)  // Output list
        : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
        : "a0", "a1", "a2", "a7"
    );

    return ret_val;
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


void exit(int code) {
    __asm__ __volatile__(
        "mv a0, %0           # return code\n"
        "li a7, 93           # syscall exit (64) \n"
        "ecall"
        :   // Output list
        :"r"(code)    // Input list
        : "a0", "a7"
    );
}


/* Defines for read() and write()*/
#define STDIN_FD  0
#define STDOUT_FD 1


/*----------------- Basic functions -----------------*/

/**
 * Function to check if a number is negative using bit masking
 */
int isNegative(int num) {
    return (num & (1 << (sizeof(int) * 8 - 1))) != 0;
}


/**
 * Function to convert a string to an integer
 */
int atoi(char str[], int length) {
    int integer = 0, sign = 1;

    int base = (str[1] == 'x') ? 16 : 10;

    int i = 0;
    if (base == 16) i = 2;
    else {
        if (str[0] == '-') { sign = -1; i = 1; }
    }

    for (; str[i] != '\n'; i++) {
            integer = (str[i] >= '0' && str[i] <= '9') ? integer * base + (str[i] - '0') : integer * base + (str[i] - 'a' + 10);
    }

    return sign * integer; 
}


/**
 * Function to convert integer to string
 */
void itoa(char str[], int num, int base, int is_negative) {
    unsigned int tmp = (unsigned int)num;
    int i = 0;

    if (is_negative && base == 10)
        tmp = (unsigned int)(-num);

    do {
        int rem = tmp % base;
        str[i++] = (rem > 9) ? rem + 'a' - 10 : rem + '0';
    } while ((tmp /= base) > 0);

    if (is_negative && base == 10)
        str[i++] = '-';

    str[i] = '\n';

    for (int x = 0; x < i / 2; x++) {
        char tmp = str[x];
        str[x] = str[i - x - 1];
        str[i - x - 1] = tmp;
    }

    write(STDOUT_FD, str, i+1);
}


/*----------------- Conversion functions -----------------*/

/**
 * Function to convert an integer to binary and prints the binary representation
 */
void intToBin(int num) {
    char preffix[2] = {'0', 'b'};
    write(STDOUT_FD, preffix, 2);

    char bin[33];

    int start = 0;
    int leading_zero = 1;
    for (int i = 31; i >= 0; i--) {
        char bit = ((num >> i) & 1) ? '1' : '0';
        if (bit == '1') {
            leading_zero = 0;
        }
        if (!leading_zero) {
            bin[start++] = bit;
        }
    }
    if (start == 2) {
        bin[start++] = '0';
    }
    bin[start] = '\n';

    write(STDOUT_FD, bin, start+1);
}


/**
 * Function to convert an integer to decimal and prints the decimal representation
 */
void intToDecimal(int num) {
    char dec[15];
    itoa(dec, num, 10, isNegative(num));
}


/**
 * Function to convert an integer to hexadecimal and prints the hexadecimal representation
 */
void intToHex(int num) {
    char preffix[2] = {'0', 'x'};
    write(STDOUT_FD, preffix, 2);
    char hex[12];
    itoa(hex, num, 16, isNegative(num));
}


/**
 * Function to convert an integer to little endian and prints the little endian representation
 */
void endianSwapp(int num) {
    // do the endian swap
    unsigned int tmp = (unsigned int)num;
    tmp = ((tmp >> 24) & 0xff) | ((tmp << 8) & 0xff0000) | ((tmp >> 8) & 0xff00) | ((tmp << 24) & 0xff000000);

    char endian[15];
    itoa(endian, tmp, 10, 0);
}


int main() {
    // Read the input string
    char str[20];
    int n = read(STDIN_FD, str, 20);

    // converts string into integer
    int num = atoi(str, n);

    intToBin(num);
    intToDecimal(num);
    intToHex(num);
    endianSwapp(num);

    return 0;
}


void _start() {
    int ret_code = main();
    exit(ret_code);
}