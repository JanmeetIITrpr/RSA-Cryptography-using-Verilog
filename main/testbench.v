`timescale 1ns / 1ps
`define WIDTH 256
module tb_main;
    reg [`WIDTH-1:0] p,q;
    reg clk,reset,reset1,encrypt_decrypt;
    reg [`WIDTH-1:0] msg_in;
    wire [`WIDTH-1:0] msg_out;
    wire mod_exp_finish;
    
    control uut(p,q,clk,reset,reset1,encrypt_decrypt,msg_in,msg_out,mod_exp_finish);
    defparam uut.WIDTH = `WIDTH;
    
    initial begin
        p = 128'd113680897410347;
        q = 128'd7999808077935876437321;
        #100 
        $display("\n\nRSA 256-BIT ENCRYPTION/DECRYPTION TESTER\n");
      $display("\nPrime Numbers Used are:\n1.p=%d\n2.q=%d\n",p,q);
        clk = 0;
        reset =0; reset1=0;
        encrypt_decrypt = 0;//use encrypt_decrypt=1 for encryption or encrypt_decrypt=0 for decryption
        msg_in = 256'h0000000000000000000000000000000000262d806a3e18f03ab37b2857e7e149;
        #10 reset = 1;
        #10 reset = 0;
      #1000 reset1 = 1;
        #10 reset1 = 0;
      #2980 
      $display("Input Message is \t: %h",msg_in);
      $display("Your decrypted Message is:%h\n", msg_out);
        

      
        p = 128'd113680897410347;
        q = 128'd7999808077935876437321;
        //clk = 0;
        reset =0; reset1=0;
        encrypt_decrypt = 1;
        msg_in = 256'h000000000000000000000000000000000000000048656c6c6f20576f726c6421;
        #10 reset = 1;
        #10 reset = 0;
        #1000 reset1 = 1;
        #10 reset1 = 0;
      #2980
      $display("Input Message is \t: %h",msg_in);
      $display("Your Encrypted Message is:%h\n", msg_out);

      #2980
        p = 128'd113680897410347;
        q = 128'd7999808077935876437321;
        clk = 0;
        reset =0; reset1=0;
        encrypt_decrypt = 0;
        msg_in = 256'h8caea22b8f7a6b9dfa6c57896e0ed7bc;
        #10 reset = 1;
        #10 reset = 0;
        #1000 reset1 = 1;
        #10 reset1 = 0;
      #2980
      $display("Input Message is \t: %h",msg_in);
        $display("Your decrypted Message is:%h\n", msg_out);
      #2980
      
       #1000 reset1 = 1;
        #10 reset1 = 0;
        p = 128'd113680897410347;
        q = 128'd7999808077935876437321;
        //clk = 0;
        reset =0; reset1=0;
        encrypt_decrypt = 1;
        msg_in = 256'h8caea22b8f7a6b9dfa6c57896e0ed7bc;
        #10 reset = 1;
        #10 reset = 0;
        #1000 reset1 = 1;
        #10 reset1 = 0;
      #2980
      $display("Input Message is \t: %h",msg_in);
      $display("Your Encrypted Message is:%h\n", msg_out);
      $finish;
    end

    
    always #5 clk = ~clk;

    
endmodule
