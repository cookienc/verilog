



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

//HA
module halfadd(sum, c_out, a, b);
 output sum, c_out;
 input a, b;
 
 xor (sum, a, b);
 and (c_out, a, b);

endmodule

//Wallace Tree Multiplier                                                                                             
module multiplier(fin, a, b);

 input [3:0] a;
 input [3:0] b;
 output [7:0] fin;

 reg [3:0] prod0, prod1, prod2, prod3;
 
 
 wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;
 wire c0, c1, c2 , c3, c4, c5, c6, c7, c8, c9, c10, c11; 
 

 //각 비트별 곱셈

 always@(*)
   begin
      prod0[3] = a[0]&&b[3];
      prod0[2] = a[0]&&b[2];
      prod0[1] = a[0]&&b[1];
      prod0[0] = a[0]&&b[0];
      prod1[3] = a[1]&&b[3];
      prod1[2] = a[1]&&b[2];
      prod1[1] = a[1]&&b[1];
      prod1[0] = a[1]&&b[0];
      prod2[3] = a[2]&&b[3];
      prod2[2] = a[2]&&b[2];
      prod2[1] = a[2]&&b[1];
      prod2[0] = a[2]&&b[0];
      prod3[3] = a[3]&&b[3];
      prod3[2] = a[3]&&b[2];
      prod3[1] = a[3]&&b[1];
      prod3[0] = a[3]&&b[0];
   
   end
 // wallace tree를 이용한 비트 덧셈
 // (b) - 3bit position
     halfadd ha1(s0, c0, prod1[2], prod0[3]); 
 // (b) - 4bit position
     halfadd ha2(s1, c1, prod2[2], prod1[3]);
 
 // (c) - 2bit position
     halfadd ha3(s2, c2, prod1[1], prod0[2]);
 // (c) - 3bit position0
     fulladd fa1(s3, c3, prod3[0], prod2[1], s0);
 // (c) - 4bit position
     fulladd fa2(s4, c4, prod3[1], c0, s1);
 // (c) - 5bit position
     fulladd fa3(s5, c5, prod3[2], prod2[3], c1);
 
 // (d) - 1bit position
     halfadd ha4(s6, c6, prod1[0], prod0[1]);
 // (d) - 2bit position
     fulladd fa4(s7, c7, prod2[0], s2, c6);
 // (d) - 3bit position
     fulladd fa5(s8, c8, c2, s3, c7);
 // (d) - 4bit position
     fulladd fa6(s9, c9, c3, s4, c8);
 // (d) - 5bit position
     fulladd fa7(s10, c10, c4, s5, c9);
 // (d) - 6bit position
     fulladd fa8(s11, c11, c5, prod3[3], c10);

//결과값 저장

 assign fin = {c11, s11, s10, s9, s8, s7, s6, prod0[0]};
 
endmodule