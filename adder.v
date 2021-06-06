/////////////////////////////////////////////////
/////64bit Carry Select Adder(이하 CSA)구현///////
/////////////////////////////////////////////////

// 테스트 벤치 케이스를 5개로 나눠놓고 기능 확인
module stimulus;
    
    reg [63:0] a, b;
	reg c_in;
    reg [64:0] final;
    wire [63:0] sum;
	wire c_out;
    csa_64 csa_tb (sum, c_out, a, b, c_in);
    
    initial
    begin
    //Case 1 : 10 + 20 + 0 = 21
    a = 64'd10;
    b = 64'd20;
    c_in = 1'b0;
    #10 final = {c_out, sum[63:0]};

    if(final == (a + b + c_in))
        #5 $display("1st case success!! csa = %d, calculator = %d", final, (a + b + c_in));

     //Case 2 : 123 + 521 + 1 = 645
    a = 64'd123;
    b = 64'd521;
    c_in = 1'b1;
    #10 final = {c_out, sum[63:0]};

    if(final == (a + b + c_in))
        #5 $display("2nd case success!! csa = %d, calculator = %d", final, (a + b + c_in));

     //Case 3 : 7861 + 7865 + 0 = 15726
    a = 64'd7861;
    b = 64'd7865;
    c_in = 1'b0;
    #10 final = {c_out, sum[63:0]};

    if(final == (a + b + c_in))
        #5 $display("3rd case success!! csa = %d, calculator = %d", final, (a + b + c_in));

     //Case 4 : 851378 + 4215 + 1 = 855594
    a = 64'd851378;
    b = 64'd4215;
    c_in = 1'b1;
    #10 final = {c_out, sum[63:0]};

    if(final == (a + b + c_in))
        #5 $display("4th case success!! csa = %d, calculator = %d", final, (a + b + c_in));

     //Case 5 : 1358 + 241 + 0 = 1599
    a = 64'd1358;
    b = 64'd241;
    c_in = 1'b0;
    #10 final = {c_out, sum[63:0]};

    if(final == (a + b + c_in))
        #5 $display("5th case success!! csa = %d, calculator = %d", final, (a + b + c_in));


    end

    
    


 endmodule


//64bit Carry Select Adder (16bit CSA를 이용하여 구현)
module csa_64(sum, c_out, a, b, c_in);

    output [63:0] sum;
    output c_out ;

    input [63:0] a, b;
    input c_in;

    wire [3:0] c;

    csa_16 csa16_0 (.sum(sum[15:0]), .c_out(c[0]), .a(a[15:0]), .b(b[15:0]), .c_in(c_in));
    csa_16 csa16_1 (.sum(sum[31:16]), .c_out(c[1]), .a(a[31:16]), .b(b[31:16]), .c_in(c[0]));
    csa_16 csa16_2 (.sum(sum[47:32]), .c_out(c[2]), .a(a[47:32]), .b(b[47:32]), .c_in(c[1]));
    csa_16 csa16_3 (.sum(sum[63:48]), .c_out(c[3]), .a(a[63:48]), .b(b[63:48]), .c_in(c[2]));

    assign c_out = c[3];

endmodule



//16bit Carry Select Adder (4bit CSA를 이용하여 구현)
module csa_16(sum, c_out, a, b, c_in);

    output [15:0] sum;
    output c_out ;

    input [15:0] a, b;
    input c_in;

    wire [3:0] c;

    csa_4 csa4_0 (.sum(sum[3:0]), .c_out(c[0]), .a(a[3:0]), .b(b[3:0]), .c_in(c_in));
    csa_4 csa4_1 (.sum(sum[7:4]), .c_out(c[1]), .a(a[7:4]), .b(b[7:4]), .c_in(c[0]));
    csa_4 csa4_2 (.sum(sum[11:8]), .c_out(c[2]), .a(a[11:8]), .b(b[11:8]), .c_in(c[1]));
    csa_4 csa4_3 (.sum(sum[15:12]), .c_out(c[3]), .a(a[15:12]), .b(b[15:12]), .c_in(c[2]));

    assign c_out = c[3];

endmodule




//4bit Carry Select Adder
module csa_4(sum, c_out, a, b, c_in);

    output [3:0] sum;
    output c_out;

    input [3:0] a, b;
    input c_in;

    wire [3:0] s0, s1;
    wire c0, c1; //중간에 저장되는 캐리 값, MUX선택할때 쓰임

    fulladd_4 fa0(.sum(s0[3:0]), .c_out(c0), .a(a), .b(b), .c_in(1'b0));// carry가 0일 때 4bit FA계산
    fulladd_4 fa1(.sum(s1[3:0]), .c_out(c1), .a(a), .b(b), .c_in(1'b1));// carry가 1일 때 4bit FA계산 

    mux2_to_1 m0(.out(sum[0]), .i0(s0[0]), .i1(s1[0]), .s(c_in)); //c_in에 따라서 sum 선택
    mux2_to_1 m1(.out(sum[1]), .i0(s0[1]), .i1(s1[1]), .s(c_in));
    mux2_to_1 m2(.out(sum[2]), .i0(s0[2]), .i1(s1[2]), .s(c_in));
    mux2_to_1 m3(.out(sum[3]), .i0(s0[3]), .i1(s1[3]), .s(c_in));

    mux2_to_1 m4(.out(c_out), .i0(c0), .i1(c1), .s(c_in)); //FA계산한것 중에서 carry 선택 -> 다음으로 넘겨주는 값 선택


endmodule


////////////////////////////////////////////////////////////
//2:1 MUX
module mux2_to_1(out, i0, i1, s);

    output out;
    input i0, i1;
    input s ;

    assign out = s ? i1 : i0;

endmodule



//4bit FA
module fulladd_4(sum, c_out, a, b, c_in);

    output [3:0] sum;
    output c_out;
    input [3:0] a, b;
    input c_in;

    wire [3:0] s, c;

    fulladd fa1(.sum(s[0]), .c_out(c[0]), .a(a[0]), .b(b[0]), .c_in(c_in));
    fulladd fa2(.sum(s[1]), .c_out(c[1]), .a(a[1]), .b(b[1]), .c_in(c[0]));
    fulladd fa3(.sum(s[2]), .c_out(c[2]), .a(a[2]), .b(b[2]), .c_in(c[1]));
    fulladd fa4(.sum(s[3]), .c_out(c[3]), .a(a[3]), .b(b[3]), .c_in(c[2]));

    assign { c_out, sum } = { c[3], s[3:0] };

endmodule



//FA
module fulladd(sum, c_out, a, b, c_in);

    output sum, c_out;
    input a, b, c_in;
    
    wire s1, s2, c1;
    
    xor(s1, a, b);
    and(c1, a, b);
    xor(sum, s1, c_in);
    and(s2, s1, c_in);
    xor(c_out, s2, c1);

endmodule