
module stimulus;
  reg[3:0] a, b;
  wire[7:0] out;
  multiplier mu1 (out,a,b);

  initial begin
    a = 4'b1010;
    b = 4'b1001;

    $monitor("Output = %b(%d), Input A = %b(%d), B = %b(%d)", out, out, a, a, b, b);

  end
endmodule






/*//Simulation
module stimulus;
    reg clk;
    reg [3:0] a, b;
    wire [7:0] out;
    multiplier mu1 (out, a, b);
    
    initial
    begin
    
    clk = 0;
    a=4'b0000; //0으로 초기화
    b=4'b0000;
    end

    always  #10 clk= ~clk; // 클럭이 10마다 바뀜
    integer i,j;

     always@(posedge clk)
     begin
     for(i=0; i<16; i = i+1)
      begin
           #10 a=i;
           for(j=0 ;j<i; j = j+1)
            begin
                #10 b=j;
            end
        $monitor("Output = %b(%d), Input A = %b(%d), B = %b(%d)", out, out, a, a, b, b);
      end
   end

    always@(i) //i=16일때 반복을 멈춤
        begin
        if(i == 16)
          begin
          $finish;
          end
        end

 endmodule