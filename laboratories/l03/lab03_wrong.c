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

    if (exp == 0) {
        return 1;
    }

    for (int i = 0; i < exp; i++) {
        result *= base;
    }

    return result;
}


/*
* Functon to calculate the length of a string
*/
int strLen(char str[]) {
    int i;
    for (i = 0; str[i] != '\n'; i++);
    return i + 1;
}


/*
* Function to detect the base of the input number based on the initial characters
*/
int detectBase(char inputStr[]) {
    return (inputStr[1] == 'x') ? 16 : 10;
}


/*
* Function that inverts the elements of a string
*/
void invertStr(char inputStr[], int numElems) {
    for (int i = 0; i < numElems / 2; i++) {
        char tmp = inputStr[i];
        inputStr[i] = inputStr[numElems - i - 1];
        inputStr[numElems - i - 1] = tmp;
    }
}


/*
* Function to convert a string to an integer
*/
unsigned atoi(char input[], int strLength, int base, int sign) {
    int pos, temp, y = 0;
    unsigned int integer = 0;

    // defines where to stop the conversion considering the prefixes and signals
    switch (input[0]) {
        case '-':
            pos = 1;
            break;
        
        case '0':
            pos = 2;
            break;

        default:
            pos = 0;
            break;
    }

    // converts the string to an integer
    for (int i = strLength - 2; i >= pos; i--) {
        if (input[i] >= '0' && input[i] <= '9') 
            temp = input[i] - '0';

        else  
            temp = input[i] - 'a' + 10;

        integer = integer + temp * power(base, y);
        y++;
    }

    return integer;
}


/*
* Function to convert integer to string
*/
void itoa(char str[], unsigned int num, int sign) {
    char *ptr = str, *ptr1 = str, tmp_char;
    int tmp_value;

    do {
        tmp_value = num;
        num /= 10;
        *ptr++ = "ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" [35 + (tmp_value - num * 10)];
    } while (num);

    if (sign == 1) {
        *ptr++ = '-';
    }
    *ptr-- = '\n';

    while (ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr-- = *ptr1;
        *ptr1++ = tmp_char;
    }
}



/*----------------- Conversion functions -----------------*/

/*
* Function to convert an integer to binary and returns the number of digits
*/
int intToBin(unsigned int num, char bin[]) {
    int x = 0;
    do {
        bin[x] = num % 2 + '0';
        num /= 2;
        x++;
    } while (num != 0);

    return x;
}


/*
* Function that prints the binary representation of a number as a string
*/
void numToBin(int num, int sign, char bin[]) {
    if (sign == 1) {
        int x = intToBin(num * -1, bin);
        invertStr(bin, 32);
        bin[32] = '\n';
        write(STDOUT_FD, bin, 33);
    }

    else {
        int x = intToBin(num, bin);
        invertStr(bin, x);
        bin[x] = '\n';
        write(STDOUT_FD, bin, x + 1);
    }
}


/*
* Function that prints an integer as a decimal string
*/
void numToDec(int num, int sign, char dec[]) {
    itoa(dec, num, sign);
    int len = strLen(dec);
    dec[len - 1] = '\n';
    write(STDOUT_FD, dec, len);
}


/*
* Function that prints the hexadecimal representation of a binary number
*/
/*void binToHex(char bin[], char hex[]) {
    int i, j, k, sum;

    int bin_len = strLen(bin) - 1;

    char aux[3];
    itoa(aux, bin_len, 0);
    aux[2] = '\n';
    write(STDOUT_FD, aux, 3);

    int length_hex, remainder;


    if (bin_len % 4 == 0) {
        length_hex = bin_len / 4;
        remainder = 0;
    }
    else {
        length_hex = (bin_len / 4) + 1;

        invertStr(bin, bin_len);
        remainder = 4 - (bin_len % 4);

        for (i = 0; i < remainder; i++) {
            bin[bin_len + i] = '0';
        }
        invertStr(bin, bin_len + remainder);
    }

    for (
            i = 0, j = bin_len + remainder - 1; 
            i < length_hex && j >= 0;
            i++, j -= 4
        ) {

        sum = 0;
        for (k = 0; k < 4; k++) {
            sum += (bin[j - k] - '0') * power(2, k);
        }

        if (sum < 10) {
            hex[i] = sum + '0';
        }

        else {
            hex[i] = sum + 'a' - 10;
        }
    }

    invertStr(hex, length_hex);
    hex[length_hex] = '\n';
    write(STDOUT_FD, hex, length_hex + 1);
}*/

void hex_code(int val, char hex[]){
    unsigned int uval = (unsigned int) val, aux;
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



int main() {
    // Read the input string
    char str[20];
    int n = read(STDIN_FD, str, 20);

    // Detect the sign of a decimal input
    int sign = 0;
    if (str[0] == '-') {
        sign = 1;
    }
    int base = detectBase(str);

    // converts string into integer
    int num = atoi(str, n, base, sign);
    if (num < 0) sign = 1;

    /*char aux[20];
    itoa(aux, num, sign);
    int len = strLen(aux);
    aux[len] = '\n';
    write(STDOUT_FD, aux, len + 1);*/

    char bin_prefix[2] = {'0', 'b'};
    char hex_prefix[2] = {'0', 'x'};

    char bin[33], dec[11], hex[9];

    numToBin(num, sign, bin); // correct
    numToDec(num, sign, dec); // correct
    binToHex(bin, hex);

    return 0;
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

void _start() {
    int ret_code = main();
    exit(ret_code);
}