/*--------------- Structs and defines ---------------*/

// Enum of possible instruction types
typedef enum InstType { R, I, I2, S, B, U, J } InstType;

// Struct with instruction data
typedef struct InstData {
    int opcode,
        rd,
        rs1,
        rs2,
        imm,
        funct3,
        funct7;

    InstType type;
} InstData;

// File descriptors
#define STDIN_FD  0
#define STDOUT_FD 1



/*----------------- Basic functions -----------------*/

/*
* Reads input information
*
* Parameters:
*   - __fd: file descriptor.
*   - __buf: destination buffer address.
*   - __n: number of bytes to read.
*
* Returns: number of bytes read
*/
int read(int __fd, const void *__buf, int __n) {
    int bytes;
    __asm__ __volatile__(
        "mv a0, %1           # file descriptor\n"
        "mv a1, %2           # buffer \n"
        "mv a2, %3           # size \n"
        "li a7, 63           # syscall read (63) \n"
        "ecall \n"
        "mv %0, a0"
        : "=r"(bytes)
        :"r"(__fd), "r"(__buf), "r"(__n)
        : "a0", "a1", "a2", "a7"
    );

    return bytes;
}



/*
* Writes output information
*
* Parameters:
*   - __fd: file descriptor.
*   - __buf: source buffer address.
*   - __n: number of bytes to write.
*
* Returns: (nothing)
*/
void write(int __fd, const void *__buf, int __n) {
    __asm__ __volatile__(
        "mv a0, %0           # file descriptor\n"
        "mv a1, %1           # buffer \n"
        "mv a2, %2           # size \n"
        "li a7, 64           # syscall write (64) \n"
        "ecall"
        :
        :"r"(__fd), "r"(__buf), "r"(__n)
        : "a0", "a1", "a2", "a7"
    );
}



/*
* Exits program
*
* Parameters:
*   - code: exit code.
*
* Returns: (nothing)
*/
void exit(int code) {
    __asm__ __volatile__(
        "mv a0, %0           # return code\n"
        "li a7, 93           # syscall exit (93) \n"
        "ecall"
        :
        :"r"(code)
        : "a0", "a7"
    );
}



/*----------------- Essential functions -----------------*/

/*
* Displays an integer value in its hexadecimal representation
*
* Parameters:
*   - val: int value to be converted to hexadecimal.
*
* Returns: (nothing)
*/
void hexCode(int val) {
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;
    
    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--) {
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(STDOUT_FD, hex, 11);
}



/*
* Compares the first n_char characters of two strings
*
* Parameters:
*   - str1: first string.
*   - str2: second string.
*   - n_char: number of chars to compare
*
* Returns: 0 if the strings are equal, 1 or -1 if they are different
*/
int strcmpCustom(char *str1, char *str2, int n_char) {
    for (int i = 0; i < n_char; i++) {
        if (str1[i] < str2 [i])
            return -1;
        else if (str1[i] > str2 [i])
            return 1;
    }

    return 0;
}



/*
* Converts a string of characters representing a number in decimal base
* to an integer and updates the number of chars read from the buffer
*
* Parameters:
*  - buffer: buffer address.
*  - read_chars: pointer to variable to be updated with the
*                number of chars read form the buffer.
*
* Returns: int value computed from the buffer
*/
int atoi10(char buffer[], int *read_chars) {
    int neg = 0, val = 0, curr;
    
    if (buffer[0] == '-')
        neg = 1;

    curr = neg;
    while(buffer[curr] >= '0' && buffer[curr] <= '9') {
        val *= 10;
        val += buffer[curr] - '0';
        curr++;
    }

    if (neg == 1)
        val = -val;

    *read_chars += curr + 1;

    return val;
}



/*
* Gets the register id from a buffer and updates the number of chars read
*
* Parameters:
*   - buffer: buffer address.
*   - read_chars: pointer to variable to be updated with the
*                 number of chars read form the buffer.
*
* Returns: Register id
*/
int getRegister(char buffer[], int *read_chars) {
    int curr = 0;

    while (buffer[curr] != 'x') {
        curr++;
    }

    curr++;
    *read_chars += curr;

    return atoi10(&buffer[curr], read_chars);
}



/*
* Gets the immediate value from a buffer and updates the number of chars read
*
* Parameters:
*   - buffer: buffer address.
*   - read_chars: pointer to variable to be updated with the
*                 number of chars read form the buffer.
*
* Returns: Immediate value
*/
int getImmediate(char buffer[], int *read_chars) {
    int curr = 0;

    while (!((buffer[curr] >= '0' && buffer[curr] <= '9') ||  buffer[curr] == '-')) {
        curr++;
    }

    *read_chars += curr;

    return atoi10(&buffer[curr], read_chars);
}



/*
* Parsing of instruction with format rd_imm
*
* Parameters:
*   - buffer: buffer address.
*   - rd: pointer to variable associated with destination register.
*   - imm: pointer to variable associated with immediate.
*   - start: index of where to start reading from the buffer.
*
* Returns: (nothing)
*/
void rd_imm(char buffer[], int *rd, int *imm, int start) {
    *rd = getRegister(&buffer[start], &start);
    *imm = getImmediate(&buffer[start], &start);
}



/*
* Parsing of instruction with format r1_r2_imm
*
* Parameters:
*   - buffer: buffer address.
*   - r1: pointer to variable associated with register 1.
*   - r2: pointer to variable associated with register 2.
*   - imm: pointer to variable associated with immediate.
*   - start: index of where to start reading from the buffer.
*
* Returns: (nothing)
*/
void r1_r2_imm(char buffer[], int *r1, int *r2, int *imm, int start) {
    *r1 = getRegister(&buffer[start], &start);
    *r2 = getRegister(&buffer[start], &start);
    *imm = getImmediate(&buffer[start], &start);
}



/*
* Parsing of instruction with format r1_imm_r2
*
* Parameters:
*   - buffer: buffer address.
*   - r1: pointer to variable associated with register 1.
*   - r2: pointer to variable associated with register 2.
*   - imm: pointer to variable associated with immediate.
*   - start: index of where to start reading from the buffer.
*
* Returns: (nothing)
*/
void r1_imm_r2(char buffer[], int *r1, int *r2, int *imm, int start) {
    *r1 = getRegister(&buffer[start], &start);
    *imm = getImmediate(&buffer[start], &start);
    *r2 = getRegister(&buffer[start], &start);
}



/*
* Parsing of instruction with format r1_r2_r3
*
* Parameters:
*   - buffer: buffer address.
*   - r1: pointer to variable associated with register 1.
*   - r2: pointer to variable associated with register 2.
*   - r3: pointer to variable associated with register 3.
*   - start: index of where to start reading from the buffer.
*
* Returns: (nothing)
*/
void r1_r2_r3(char buffer[], int *r1, int *r2, int *r3, int start) {
    *r1 = getRegister(&buffer[start], &start);
    *r2 = getRegister(&buffer[start], &start);
    *r3 = getRegister(&buffer[start], &start);
}



/*
* Parses a string with a RISC-V instruction and fills an
* InstData struct with the instruction's data
*
* Parameters:
*   - inst: instruction string.
*   - data: pointer to InstData struct.
*
* Returns: (nothing)
*/
void getInstData(char inst[], InstData *data) {
    int opcode = 0,
        rd = 0,
        rs1 = 0,
        rs2 = 0,
        imm = 0,
        funct3 = 0,
        funct7 = 0;

    InstType type = I;

    if (strcmpCustom(inst, "lui", 3) == 0) {
        // lui rd, IMM
        // OPCODE = 0110111 = 55
        rd_imm(inst, &rd, &imm, 3);
        opcode = 55, type = U;
    } 
    else if (strcmpCustom(inst, "auipc ", 6) == 0) {
        // auipc rd, IMM
        // OPCODE = 0010111 = 23
        rd_imm(inst, &rd, &imm, 5);
        opcode = 23, type = U;
    } 
    else if (strcmpCustom(inst, "jal ", 4) == 0){
        // jal rd, IMM
        // OPCODE = 1101111 = 111
        rd_imm(inst, &rd, &imm, 3);
        opcode = 111, type = J;
    } 
    else if (strcmpCustom(inst, "jalr ", 5) == 0){
        // jalr rd, IMM(rs1)
        // OPCODE = 1100111 = 103  FUNCT3 = 0
        r1_imm_r2(inst, &rd, &rs1, &imm, 4);
        opcode = 103, type = I;
    } 
    else if (strcmpCustom(inst, "beq ", 4) == 0){
        // beq rs1, rs2, IMM
        // OPCODE = 1100011 = 99 FUNCT3 = 0
        r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
        opcode = 99, type = B;
    } 
    else if (strcmpCustom(inst, "bne ", 4) == 0){
        // bne rs1, rs2, IMM
        // OPCODE = 1100011 = 99 FUNCT3 = 1
        r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
        opcode = 99, funct3 = 1, type = B;
    } 
    else if (strcmpCustom(inst, "blt ", 4) == 0){
        // blt rs1, rs2, IMM
        // OPCODE = 1100011 = 99 FUNCT3 = 4
        r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
        opcode = 99, funct3 = 4, type = B;
    } 
    else if (strcmpCustom(inst, "bge ", 4) == 0){
        // bge rs1, rs2, IMM
        // OPCODE = 1100011 = 99 FUNCT3 = 5
        r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
        opcode = 99, funct3 = 5, type = B;
    } 
    else if (strcmpCustom(inst, "bltu ", 5) == 0){
        // bltu rs1, rs2, IMM
        // OPCODE = 1100011 = 99 FUNCT3 = 6
        r1_r2_imm(inst, &rs1, &rs2, &imm, 4);
        opcode = 99, funct3 = 6, type = B;
    } 
    else if (strcmpCustom(inst, "bgeu ", 5) == 0){
        // bgeu rs1, rs2, IMM
        // OPCODE = 1100011 = 99 FUNCT3 = 7
        r1_r2_imm(inst, &rs1, &rs2, &imm, 4);
        opcode = 99, funct3 = 7, type = B;
    }
    else if (strcmpCustom(inst, "lb ", 3) == 0){
        // lb rd, IMM(rs1)
        // OPCODE = 0000011 = 3 FUNCT3 = 0
        r1_imm_r2(inst, &rd, &rs1, &imm, 2);
        opcode = 3;
    } 
    else if (strcmpCustom(inst, "lh ", 3) == 0){
        // lh rd, IMM(rs1)
        // OPCODE = 0000011 = 3 FUNCT3 = 1
        r1_imm_r2(inst, &rd, &rs1, &imm, 2);
        opcode = 3, funct3 = 1;
    } 
    else if (strcmpCustom(inst, "lw ", 3) == 0){
        // lw rd, IMM(rs1)
        // OPCODE = 0000011 = 3 FUNCT3 = 2
        r1_imm_r2(inst, &rd, &rs1, &imm, 2);
        opcode = 3, funct3 = 2;
    }
    else if (strcmpCustom(inst, "lbu ", 4) == 0){
        // lbu rd, IMM(rs1)
        // OPCODE = 0000011 = 3 FUNCT3 = 4
        r1_imm_r2(inst, &rd, &rs1, &imm, 3);
        opcode = 3, funct3 = 4;
    } 
    else if (strcmpCustom(inst, "lhu ", 4) == 0){
        // lhu rd, IMM(rs1)
        // OPCODE = 0000011 = 3 FUNCT3 = 5
        r1_imm_r2(inst, &rd, &rs1, &imm, 3);
        opcode = 3, funct3 = 5;
    } 
    else if (strcmpCustom(inst, "sb ", 3) == 0) {
        // sb rs2, IMM(rs1)
        // OPCODE = 0100011 = 35 FUNCT3 = 0
        r1_imm_r2(inst, &rs2, &rs1, &imm, 2);
        opcode = 35, type = S;
    } 
    else if (strcmpCustom(inst, "sh ", 3) == 0) {
        // sh rs2, IMM(rs1)
        // OPCODE = 0100011 = 35 FUNCT3 = 1
        r1_imm_r2(inst, &rs2, &rs1, &imm, 2);
        opcode = 35, funct3 = 1, type = S;
    } 
    else if (strcmpCustom(inst, "sw ", 3) == 0) {
        // sw rs2, IMM(rs1)
        // OPCODE = 0100011 = 35 FUNCT3 = 2
        r1_imm_r2(inst, &rs2, &rs1, &imm, 2);
        opcode = 35, funct3 = 2, type = S;
    } 
    else if (strcmpCustom(inst, "addi ", 5) == 0) {
        // addi rd, rs1, IMM
        // OPCODE = 0010011 = 19 FUNCT3 = 0
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19;
    } 
    else if (strcmpCustom(inst, "slti ", 5) == 0) {
        // slti rd, rs1, IMM
        // OPCODE = 0010011 = 19 FUNCT3 = 2
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, funct3 = 2;
    } 
    else if (strcmpCustom(inst, "sltiu ", 6) == 0) {
        // sltiu rd, rs1, IMM
        // OPCODE = 0010011 = 19 FUNCT3 = 3
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, funct3 = 3;
    } 
    else if (strcmpCustom(inst, "xori ", 5) == 0) {
        // xori rd, rs1, IMM
        // OPCODE = 0010011 = 19 FUNCT3 = 4 
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, funct3 = 4;
    } 
    else if (strcmpCustom(inst, "ori ", 4) == 0) {
        // ori rd, rs1, IMM
        // OPCODE = 0010011 = 19 FUNCT3 = 6
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, funct3 = 6;
    } 
    else if (strcmpCustom(inst, "andi ", 5) == 0) {
        // andi rd, rs1, IMM
        // OPCODE = 0010011 = 19 FUNCT3 = 7
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, funct3 = 7;
    } 
    else if (strcmpCustom(inst, "slli ", 5) == 0) {
        // slli rd, rs1, shamt
        // OPCODE = 0010011 = 19 FUNCT3 = 1
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, imm = imm%32, funct3 = 1;
    } 
    else if (strcmpCustom(inst, "srli ", 5) == 0) {
        // srli rd, rs1, shamt
        // OPCODE = 0010011 = 19 FUNCT3 = 5
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, imm = imm%32, funct3 = 5;
    } 
    else if (strcmpCustom(inst, "srai ", 5) == 0) {
        // srai rd, rs1, shamt
        // OPCODE = 0010011 = 19 FUNCT3 = 5
        r1_r2_imm(inst, &rd, &rs1, &imm, 4);
        opcode = 19, imm = imm%32 + 1024, funct3 = 5, funct7 = 32;
    } 
    else if (strcmpCustom(inst, "add ", 4) == 0) {
        // add rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 0  FUNCT7 = 0 
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, type = R;
    } 
    else if (strcmpCustom(inst, "sub ", 4) == 0) {
        // sub rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 0  FUNCT7 = 32 
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct7 = 32, type = R;
    } 
    else if (strcmpCustom(inst, "sll ", 4) == 0) {
        // sll rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 1  FUNCT7 = 0 
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct3 = 1, type = R;
    } 
    else if (strcmpCustom(inst, "slt ", 4) == 0) {
        // slt rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 2  FUNCT7 = 0 
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct3 = 2, type = R;
    } 
    else if (strcmpCustom(inst, "sltu ", 5) == 0) {
        // sltu rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 3  FUNCT7 = 0  
        r1_r2_r3(inst, &rd, &rs1, &rs2, 4);
        opcode = 51, funct3 = 3, type = R;
    } 
    else if (strcmpCustom(inst, "xor ", 4) == 0) {
        // xor rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 4  FUNCT7 = 0  
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct3 = 4, type = R;
    } 
    else if (strcmpCustom(inst, "srl ", 4) == 0) {
        // srl rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 5  FUNCT7 = 0  
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct3 = 5, type = R;
    } 
    else if (strcmpCustom(inst, "sra ", 4) == 0) {
        // sra rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 5  FUNCT7 = 32  
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct3 = 5, funct7 = 32, type = R;
    } 
    else if (strcmpCustom(inst, "or ", 3) == 0) {
        // or rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 6  FUNCT7 = 0  
        r1_r2_r3(inst, &rd, &rs1, &rs2, 2);
        opcode = 51, funct3 = 6, type = R;
    } 
    else if (strcmpCustom(inst, "and ", 4) == 0) {
        // and rd, rs1, rs2
        // OPCODE = 0110011 = 51 FUNCT3 = 7  FUNCT7 = 0  
        r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
        opcode = 51, funct3 = 7, type = R;
    }

    data->opcode = opcode;
    data->rd = rd;
    data->rs1 = rs1;
    data->rs2 = rs2;
    data->imm = imm;
    data->funct3 = funct3;
    data->funct7 = funct7;
    data->type = type;

    return;
}



/*
* Reverses the elements of an array
*
* Parameters:
*   - array: int array
*   - size: size of array
*
* Returns: (nothing)
*/
void reverseArray(int array[], int size) {
    for (int i = 0; i < size / 2; i++) {
        int temp = array[i];
        array[i] = array[size - i - 1];
        array[size - i - 1] = temp;
    }
}



/*
* Slices a binary number considering a number of bits
* and stores it in an int array
*
* Parameters:
*   - val: integer value to be sliced.
*   - start: number of bits to slice.
*   - bin: int array to store the sliced binary number.
*
* Returns: (nothing)
*/
void sliceBinary(int val, int start, int end, int bin[]) {
    for (int i = start; i >= end; i--)
        bin[start - end - i] = (val >> i) & 1;

    reverseArray(bin, start - end + 1);
}



/*
* Function to copy the elements of an array to another
*
* Parameters:
*   - src: source array
*   - dest: destination array
*   - end_src: last index of the source array
*   - ini_src: first index of the source array
*   - end_dest: last index of the destination array
*   
* Returns: (nothing)
*/
void copyString(int src[], int dest[], int end_src, int ini_src, int end_dest) {
    for (int j = end_dest - end_src + ini_src, i = end_src; j <= end_dest && i >= ini_src; j++, i--)
        dest[j] = src[i];
    dest[32] = '\n';
}



/*
* Treats all cases for bit packing of the instruction and
* stores it in a packed 32 bit binary array
*   
* Parameters:
*   - data: struct with instruction data.
*   - packed_bin: int array to store the packed binary instruction.
*   
* Returns: (nothing)
*/
void pack(InstData *data, int packed_bin[]) {
    int tmp_opcode[7], tmp_rd[5], tmp_rs1[5], tmp_rs2[5], tmp_imm[32], tmp_funct3[3], tmp_funct7[7];
    
    sliceBinary(data->opcode, 6, 0, tmp_opcode);
    copyString(tmp_opcode, packed_bin, 6, 0, 31);

    sliceBinary(data->imm, 31, 0, tmp_imm);

    if (data->type == R) {
        sliceBinary(data->rd, 4, 0, tmp_rd);
        copyString(tmp_rd, packed_bin, 4, 0, 24);
        sliceBinary(data->funct3, 2, 0, tmp_funct3);
        copyString(tmp_funct3, packed_bin, 2, 0, 19);
        sliceBinary(data->rs1, 4, 0, tmp_rs1);
        copyString(tmp_rs1, packed_bin, 4, 0, 16);
        sliceBinary(data->rs2, 4, 0, tmp_rs2);
        copyString(tmp_rs2, packed_bin, 4, 0, 11);
        sliceBinary(data->funct7, 6, 0, tmp_funct7);
        copyString(tmp_funct7, packed_bin, 6, 0, 6);
    }
    else if (data->type == I) {
        sliceBinary(data->rd, 4, 0, tmp_rd);
        copyString(tmp_rd, packed_bin, 4, 0, 24);
        sliceBinary(data->funct3, 2, 0, tmp_funct3);
        copyString(tmp_funct3, packed_bin, 2, 0, 19);
        sliceBinary(data->rs1, 4, 0, tmp_rs1);
        copyString(tmp_rs1, packed_bin, 4, 0, 16);
        copyString(tmp_imm, packed_bin, 11, 0, 11);
    }
    else if (data->type == I2) {
        sliceBinary(data->rd, 4, 0, tmp_rd);
        copyString(tmp_rd, packed_bin, 4, 0, 24);
        sliceBinary(data->funct3, 2, 0, tmp_funct3);
        copyString(tmp_funct3, packed_bin, 2, 0, 19);
        sliceBinary(data->rs1, 4, 0, tmp_rs1);
        copyString(tmp_rs1, packed_bin, 4, 0, 16);
        copyString(tmp_imm, packed_bin, 4, 0, 11);
        sliceBinary(data->funct7, 6, 0, tmp_funct7);
        copyString(tmp_funct7, packed_bin, 6, 0, 6);
    }
    else if (data->type == S) {
        copyString(tmp_imm, packed_bin, 4, 0, 24);
        sliceBinary(data->funct3, 2, 0, tmp_funct3);
        copyString(tmp_funct3, packed_bin, 2, 0, 19);
        sliceBinary(data->rs1, 4, 0, tmp_rs1);
        copyString(tmp_rs1, packed_bin, 4, 0, 16);
        sliceBinary(data->rs2, 4, 0, tmp_rs2);
        copyString(tmp_rs2, packed_bin, 4, 0, 11);
        copyString(tmp_imm, packed_bin, 11, 5, 6);
    }
    else if (data->type == B) {
        copyString(tmp_imm, packed_bin, 11, 11, 24);
        copyString(tmp_imm, packed_bin, 4, 1, 23);
        sliceBinary(data->funct3, 2, 0, tmp_funct3);
        copyString(tmp_funct3, packed_bin, 2, 0, 19);
        sliceBinary(data->rs1, 4, 0, tmp_rs1);
        copyString(tmp_rs1, packed_bin, 4, 0, 16);
        sliceBinary(data->rs2, 4, 0, tmp_rs2);
        copyString(tmp_rs2, packed_bin, 4, 0, 11);
        copyString(tmp_imm, packed_bin, 10, 5, 6);
        copyString(tmp_imm, packed_bin, 12, 12, 0);
    }
    else if (data->type == U) {
        sliceBinary(data->rd, 4, 0, tmp_rd);
        copyString(tmp_rd, packed_bin, 4, 0, 24);
        copyString(tmp_imm, packed_bin, 19, 0, 19);
    }
    else if (data->type == J) {
        sliceBinary(data->rd, 4, 0, tmp_rd);
        copyString(tmp_rd, packed_bin, 4, 0, 24);
        copyString(tmp_imm, packed_bin, 19, 12, 19);
        copyString(tmp_imm, packed_bin, 11, 11, 11);
        copyString(tmp_imm, packed_bin, 10, 1, 10);
        copyString(tmp_imm, packed_bin, 20, 20, 0);
    }
}



/*
* Converts a binary int array to an integer number
*
* Parameters:
*   - binary: int array with binary number.
*
* Returns: integer value
*/
unsigned int binaryToInteger(int binary[]) {
    unsigned int result = 0;
    for (int i = 0; i < 32; i++)
        result = (result << 1) | binary[i];

    return result;
}



/*----------------------- Main ----------------------*/

int main() {
    char input[41];
    int bytes_read = read(STDIN_FD, input, 40);

    InstData insta_data;

    getInstData(input, &insta_data);

    int packed_bin[33], packed_int;

    pack(&insta_data, packed_bin);
    packed_int = binaryToInteger(packed_bin);
    hexCode(packed_int);

    return 0;
}


/* Operating functions  */

void _start() {
    int ret_code = main();
    exit(ret_code);
}