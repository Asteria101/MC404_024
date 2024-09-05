#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int detect_base(char c[], int n) {
    return (c[1] == 120) ? 16 : 10;
}

double power(int base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
        result *= base;
    }
    return result;
}


void invertStr(char c[], int x) {
    for (int i = 0; i < x / 2; i++) {
        char temp = c[i];
        c[i] = c[x - i - 1];
        c[x - i - 1] = temp;
    }
}

unsigned strToInt(char inputString[], int length, int base, int signal) {
    int pos, temp, y = 0;
    unsigned int integer = 0;

    // defines where to stop the conversion considering the prefixes and signals
    /*switch (inputString[0]) {
        case '-':
            pos = 1;
            break;
        
        case '0':
            pos = 2;
            break;

        default:
            pos = 0;
            break;
    }*/

    pos = 0;

    // converts the string to an integer
    for (int i = length - 1; i >= pos; i--) {
        if (inputString[i] >= '0' && inputString[i] <= '9') {
            temp = inputString[i] - '0';
        }

        /*else  
            temp = inputString[i] - 'a' + 10;*/

        integer = integer + temp * power(10, y);
        y++;
    }
    return integer * signal;
}



void reverseStr(char str[], int len) {
    int start = 0;
    int end = len - 1;
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}


void intToStr(char str[], int num, int sign) {

    char *ptr = str, *ptr1 = str, tmp_char;
    int tmp_value;

    do {
        tmp_value = num;
        num /= 10;
        *ptr++ = "ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" [35 + (tmp_value - num * 10)];
    } while (num);

    if (sign == 1 || tmp_value < 0) {
        *ptr++ = '-';
    }
    *ptr-- = '\0';

    while (ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr-- = *ptr1;
        *ptr1++ = tmp_char;
    }
}


int intToBin(unsigned int num, char bin[]) {
    int x = 0;
    do {
        bin[x] = num % 2 + '0';
        num /= 2;
        x++;
    } while (num != 0);

    return x;
}


void numToBin(int num, int base, int sign, char bin[]) {

    if (sign == 1) {
        int x = intToBin(num * -1, bin);
        invertStr(bin, 32);
        printf("%s\n", bin);
    }

    else {
        int x = intToBin(num, bin);
        invertStr(bin, x);
        printf("%s\n", bin);
    }
}


int strLen(char str[]) {
    int i;
    for (i = 0; str[i] != '\0'; i++);
    return i + 1;
}


void numToDec(int num, int sign, char dec[]) {
    intToStr(dec, num, sign);
    int len = strLen(dec);
    printf("%s\n", dec);
}

void binToHex(char bin[], char hex[]) {
    int i, j, k, sum;
    int bin_len = strLen(bin) - 1;
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

    printf("\n%s\n", bin);
    printf("\n%d %d\n", bin_len, remainder);

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
    hex[length_hex] = '\0';
    printf("%s\n", hex);
}



void createArrayOfIntegers(int vals[], char input[]) {
    int signals_pos[5] = {0, 6, 12, 18, 24};

    int signal;

    for (int i = 0; i < 5; i++) {
        char aux[5];
        for (int j = 0; j < 4; j++)
            aux[j] = input[signals_pos[i] + j + 1];
        aux[4] = '\0';

        if (input[signals_pos[i]] == '-')
            signal = -1;
        else 
            signal = 1;

        vals[i] = strToInt(aux, 4, 10, signal);
    }
}


int main() {
    /*char str[20];
    scanf("%s", str);
    int n = strlen(str);

    int sign = 0;
    if (str[0] == 45) {
        sign = 1;
    }
    

    int base = detect_base(str, n);
    int num = strToInt(str, n, base);
    if (num < 0) sign = 1;

    char bin_prefix[2] = {'0', 'b'};
    char hex_prefix[2] = {'0', 'x'};

    char bin[33], hex[9], dec[11];
    numToBin(num, base, sign, bin);
    binToHex(bin, hex);*/

    char input[30];
    scanf("%[^\n]", input);

    int signals_pos[5] = {0, 6, 12, 18, 24};

    int tmp_int, signal;

    for (int i = 0; i < 5; i++) {
        char aux[4];
        for (int j = 0; j < 4; j++)
            aux[j] = input[signals_pos[i] + j + 1];

        if (input[signals_pos[i]] == '-')
            signal = -1;
        else 
            signal = 1;

        tmp_int = strToInt(aux, 4, 10, signal);
    }

 
    return 0;
}