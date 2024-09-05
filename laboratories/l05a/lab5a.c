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
* Function to copy an array to another array
*/
void copyString(int src[], int dest[], int end_src, int end_dest) {
    for (int i = 0, j = end_dest; i <= end_src && j >= end_dest - end_src; i++, j--)
        dest[j] = src[i];

    dest[32] = '\0';
}


/*
* Function to calculate the power of a number
*/
double power(int base, int exp) {
    double result = 1, current_power = base;
    
    while (exp > 0) {
        if (exp & 1)
            result *= current_power;
        
        current_power *= current_power;
        exp >>= 1;
    }

    return result;
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



/*----------------- Essential functions -----------------*/

/*
* Function to get the next four characters of a string which corresponds to a number and return this number considering its signal
*/
int getNumber(char input[], char aux[], int start) {
    for (int i = 0; i < 4; i++)
        aux[i] = input[start + i];

    int number = atoi(aux, 4, 10);

    return (input[start - 1] == '-' ? (~number + 1) : number);
}


/*
* Function to slice a binary number considering a number of bits
*/
void sliceBinary(int num, int start, int bin[]) {
    for (int i = start; i >= 0; i--) {
        bin[i] = (num >> i) & 1;
    }
}


/*
* Function that packs a sequence of bit into a 32-bit binary number
*/
void packBinary(int packed_bin[], int number, int start, int next_slice) {
    int tmp_bin[start + 1];
    sliceBinary(number, start, tmp_bin);
    copyString(tmp_bin, packed_bin, start, 31 - next_slice);
}


/*
* Function to convert a binary string to an integer
*/
unsigned int binaryToInteger(int binary[]) {
    unsigned int result = 0;
    for (int i = 0; i < 32; i++)
        result = (result << 1) | binary[i];

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

    char aux[4];

    int packed_bin[33];

    int tmp_int, pos_final_bit, next_slice = 0;

    for (int i = 0; i < 25; i += 6) {
        tmp_int = getNumber(input, aux, i + 1);

        if (i == 0)
            pos_final_bit = 2;

        else if (i == 6) {
            next_slice += pos_final_bit + 1;
            pos_final_bit = 7;
        }

        else if (i == 12 || i == 18) {
            next_slice += pos_final_bit + 1;
            pos_final_bit = 4;
        }

        else {
            next_slice += pos_final_bit + 1;
            pos_final_bit = 10;
        }

        packBinary(packed_bin, tmp_int, pos_final_bit, next_slice);
    }

    packed_bin[32] = '\n';

    hexCode(binaryToInteger(packed_bin));

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