
//16bit Carry Select Adder
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

fulladd_4 fa0(.sum(s0[3:0]), .c_out(c0), .a(a), .b(b), .c_in(1'b0));// carry가 0일 때 4bit fa
fulladd_4 fa1(.sum(s1[3:0]), .c_out(c1), .a(a), .b(b), .c_in(1'b1));// carry가 1일 때 4bit fa

mux2_to_1 m0(.out(sum[0]), .i0(a[0]), .i1(b[0]), .s(c_in)); //c_in에 따라서 bit 선택
mux2_to_1 m1(.out(sum[1]), .i0(a[1]), .i1(b[1]), .s(c_in));
mux2_to_1 m2(.out(sum[2]), .i0(a[2]), .i1(b[2]), .s(c_in));
mux2_to_1 m3(.out(sum[3]), .i0(a[3]), .i1(b[3]), .s(c_in));

mux2_to_1 m4(.out(c_out), .i0(c0), .i1(c1), .s(c_in)); //carry 선택


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