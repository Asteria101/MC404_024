#include <stdio.h>
#include <stdlib.h>

/*----------------- Basic functions -----------------*/

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
unsigned stringToInteger(char input[], int strLength, int base) {
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
* Function that reverse the elements of a string - unused
*/
/*void reverseArray(char array[], int size) {
    for (int i = 0; i < size / 2; i++) {
        char temp = array[i];
        array[i] = array[size - i - 1];
        array[size - i - 1] = temp;
    }
}*/


/*
* Function to copy a string to another string
*/
void copyString(int src[], int dest[], int end_src, int end_dest) {
    for (int i = 0, j = end_dest; i <= end_src, j >= end_dest - end_src; i++, j--)
        dest[j] = src[i];

    dest[32] = '\0';
}



/*----------------- Conversion functions -----------------*/

/*
* Function to get the next four characters of a string which corresponds to a number and return this number considering its signal
*/
int getNumber(char input[], char aux[], int start) {
    for (int i = 0; i < 4; i++)
        aux[i] = input[start + i];

    int number = stringToInteger(aux, 4, 10);

    return (input[start - 1] == '-' ? (~number + 1) : number);
}


/*
* Function to convert an integer to binary - unused
*/
/*void intToBinary(char bin[], unsigned int val) {
    int x = 0;
    do {
        bin[x] = val % 2 + '0';
        val /= 2;
        x++;
    } while (val != 0);

    if (x < 32) {
        for (int i = x; i < 32; i++)
            bin[i] = '0';
    }
    reverseArray(bin, 32);
    bin[32] = '\0';
}*/



/*
* Function to slice a binary number considering a number of bits
*/
void sliceBinary(int val, int start, int bin[]) {
    for (int i = start; i >= 0; i--) {
        bin[i] = (val >> i) & 1;
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
* Function to convert a binary int array to an integer number
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
    hex[10] = '\0';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    printf("%s\n", hex);
}



/*----------------------- Main ----------------------*/

int main() {
    char input[30];
    scanf("%[^\n]", input);

    char aux[4];

    int packed_bin[33];

    int tmp_int, pos_final_bit, next_slice = 0;

    for (int i = 0; i < 25; i += 6) {
        tmp_int = getNumber(input, aux, i + 1);
        printf("%d\n", tmp_int);

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
        for (int i = 0; i < 33; i++) {
            printf("%d", packed_bin[i]);
        }
        printf("\n");
    }


    hexCode(binaryToInteger(packed_bin));

    return 0;
}
