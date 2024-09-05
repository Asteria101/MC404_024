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


/* Defines for read() and write()*/

#define STDIN_FD  0
#define STDOUT_FD 1



/*----------------- Basic functions -----------------*/

/*
* Function to calculate the power of a number
*/
double power(int base, int exp) {
    double result = 1;
    if (exp == 0) return 1;

    for (int i = 0; i < exp; i++)
        result *= base;

    return result;
}


/*
* Function to get the length of a string
*/
int strLen(char str[]) {
    int i;
    for (i = 0; str[i] != '\0'; i++);
    return i + 1;
}


/*
* Function to convert a string to an integer
*/
unsigned atoi(char input[], int strLength, int base) {
    int tmp, y = 0;
    unsigned int integer = 0;

    // converts the string to an integer
    for (int i = strLength - 1; i >= 0; i--) {
        if (input[i] >= '0' && input[i] <= '9') 
            tmp = input[i] - '0';

        integer = integer + tmp * power(base, y);
        y++;
    }

    return integer;
}


/*
* Function that reverse the elements of a string
*/
void reverseArray(char array[], int size) {
    for (int i = 0; i < size / 2; i++) {
        char temp = array[i];
        array[i] = array[size - i - 1];
        array[size - i - 1] = temp;
    }
}



/*----------------- Conversion functions -----------------*/

/*
* Function to convert an integer to binary
*/
void integerToBinary(unsigned int num, char bin[]) {
    int x = 0;
    do {
        bin[x] = (num & 1) + '0';
        num >>= 1;
        x++;
    } while (num != 0);

    if (x < 32) {
        for (int i = x; i < 32; i++)
            bin[i] = '0';
    }

    reverseArray(bin, 32);
    bin[32] = '\n';
}


/*
* Function to pack binary number into one 32-bit binary
*/
void packBinary(char tmp_bin[], char packed_bin[], int order) {
    int num_lsb = 0; // number of least significant bits
    int start_point; // starting point for the packed binary

    switch (order) {
        case 0:
            num_lsb = 3;
            start_point = 31;
            break;

        case 1:
            num_lsb = 8;
            start_point = 28;
            break;

        case 2:
            num_lsb = 5;
            start_point = 20;
            break;

        case 3:
            num_lsb = 5;
            start_point = 15;
            break;

        case 4:
            num_lsb = 11;
            start_point = 10;
            break;
    }

    for (int i = start_point, j = 31; i > (start_point - num_lsb) && j >= (31 - num_lsb + 1); i--, j--) {
        packed_bin[i] = tmp_bin[j];
    }
}


/*
* Function to convert a binary string to an integer
*/
unsigned int binaryToInteger(char binary[]) {
    unsigned int result = 0;
    for (int i = 0; i < 32; i++) {
        result = result << 1;
        if (binary[i] == '1') {
            result = result | 1;
        }
    }
    return result;
}


/*
* Function used to printing the integer value in hexadecimal
*/
void hexCode(int val) {
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(STDOUT_FD, hex, 11);
}



/*----------------------- Main ----------------------*/

int main() {
    char input[30];
    int n = read(STDIN_FD, input, 30);

    int signals_pos[5] = {0, 6, 12, 18, 24}; // positions of the signals in the input string
    int tmp_int, signal;
    char aux[4], tmp_bin[33], packed_bin[33];

    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 4; j++)
            aux[j] = input[signals_pos[i] + j + 1];

        if (input[signals_pos[i]] == '-')
            signal = -1;
        else 
            signal = 1;

        tmp_int = atoi(aux, 4, 10);
        integerToBinary(tmp_int * signal, tmp_bin);
        packBinary(tmp_bin, packed_bin, i);
        packed_bin[32] = '\n';
    }

    tmp_int = binaryToInteger(packed_bin);    

    hexCode(tmp_int);

    return 0;
}


/* Operating functions  */

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

void _start() {
    int ret_code = main();
    exit(ret_code);
}