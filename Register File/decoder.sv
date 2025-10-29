`timescale 1ns/10ps

// Takes a 5-bit register address and RegWrite signal,
// and outputs a 32-bit one-hot encoded signal to select which register to write to.
module decoder(
    input  logic RegWrite,              // Write enable signal
    input  logic [4:0] WriteRegister,   // 5-bit input specifying register number (0–31)
    output logic [31:0] regNum          // 32-bit one-hot output: only one bit is 1
);

    logic [4:0] n;      // Inverted bits of WriteRegister

    // Invert each bit of the WriteRegister 
    not (n[0], WriteRegister[0]);
    not (n[1], WriteRegister[1]);
    not (n[2], WriteRegister[2]);
    not (n[3], WriteRegister[3]);
    not (n[4], WriteRegister[4]);

    // Below: Each line decodes a specific 5-bit binary value to a unique regNum[i]
    // 00000 
    and (regNum[0],RegWrite,n[4],n[3],n[2],n[1],n[0]);
    // 00001
    and (regNum[1],RegWrite,n[4],n[3],n[2],n[1],WriteRegister[0]);
    // 00010 
    and (regNum[2],RegWrite,n[4],n[3],n[2],WriteRegister[1],n[0]);
    // 00011 
    and (regNum[3],RegWrite,n[4],n[3],n[2],WriteRegister[1],WriteRegister[0]);
    // 00100 
    and (regNum[4],RegWrite,n[4],n[3],WriteRegister[2],n[1],n[0]);
    // 00101 
    and (regNum[5],RegWrite,n[4],n[3],WriteRegister[2],n[1],WriteRegister[0]);
    // 00110 
    and (regNum[6],RegWrite,n[4],n[3],WriteRegister[2],WriteRegister[1],n[0]);
    // 00111 
    and (regNum[7],RegWrite,n[4],n[3],WriteRegister[2],WriteRegister[1],WriteRegister[0]);
    // 01000 
    and (regNum[8],RegWrite,n[4],WriteRegister[3],n[2],n[1],n[0]);
    // 01001 
    and (regNum[9],RegWrite,n[4],WriteRegister[3],n[2],n[1],WriteRegister[0]);
    // 01010 
    and (regNum[10],RegWrite,n[4],WriteRegister[3],n[2],WriteRegister[1],n[0]);
    // 01011 
    and (regNum[11],RegWrite,n[4],WriteRegister[3],n[2],WriteRegister[1],WriteRegister[0]);
    // 01100 
    and (regNum[12],RegWrite,n[4],WriteRegister[3],WriteRegister[2],n[1],n[0]);
    // 01101 
    and (regNum[13],RegWrite,n[4],WriteRegister[3],WriteRegister[2],n[1],WriteRegister[0]);
    // 01110 
    and (regNum[14],RegWrite,n[4],WriteRegister[3],WriteRegister[2],WriteRegister[1],n[0]);
    // 01111 
    and (regNum[15],RegWrite,n[4],WriteRegister[3],WriteRegister[2],WriteRegister[1],WriteRegister[0]);
    // 10000 
    and (regNum[16],RegWrite,WriteRegister[4],n[3],n[2],n[1],n[0]);
    // 10001 
    and (regNum[17],RegWrite,WriteRegister[4],n[3],n[2],n[1],WriteRegister[0]);
    // 10010 
    and (regNum[18],RegWrite,WriteRegister[4],n[3],n[2],WriteRegister[1],n[0]);
    // 10011
    and (regNum[19],RegWrite,WriteRegister[4],n[3],n[2],WriteRegister[1],WriteRegister[0]);
    // 10100 
    and (regNum[20],RegWrite,WriteRegister[4],n[3],WriteRegister[2],n[1],n[0]);
    // 10101 
    and (regNum[21],RegWrite,WriteRegister[4],n[3],WriteRegister[2],n[1],WriteRegister[0]);
    // 10110
    and (regNum[22],RegWrite,WriteRegister[4],n[3],WriteRegister[2],WriteRegister[1],n[0]);
    // 10111 
    and (regNum[23],RegWrite,WriteRegister[4],n[3],WriteRegister[2],WriteRegister[1],WriteRegister[0]);
    // 11000 
    and (regNum[24],RegWrite,WriteRegister[4],WriteRegister[3],n[2],n[1],n[0]);
    // 11001 
    and (regNum[25],RegWrite,WriteRegister[4],WriteRegister[3],n[2],n[1], WriteRegister[0]);
    // 11010
    and (regNum[26],RegWrite,WriteRegister[4],WriteRegister[3],n[2],WriteRegister[1],n[0]);
    // 11011 
    and (regNum[27],RegWrite,WriteRegister[4],WriteRegister[3],n[2],WriteRegister[1],WriteRegister[0]);
    // 11100 
    and (regNum[28],RegWrite,WriteRegister[4],WriteRegister[3],WriteRegister[2],n[1],n[0]);
    // 11101 
    and (regNum[29],RegWrite,WriteRegister[4],WriteRegister[3],WriteRegister[2],n[1],WriteRegister[0]);
    // 11110 
    and (regNum[30],RegWrite,WriteRegister[4],WriteRegister[3],WriteRegister[2],WriteRegister[1],n[0]);
    // 11111 
    and (regNum[31],RegWrite,WriteRegister[4],WriteRegister[3],WriteRegister[2],WriteRegister[1],WriteRegister[0]);

endmodule
