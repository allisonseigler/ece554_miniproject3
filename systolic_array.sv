module systolic_array
#(
   parameter BITS_AB=8,
   parameter BITS_C=16,
   parameter DIM=8
   )
  (
   input                      clk,rst_n,WrEn,en,
   input signed [BITS_AB-1:0] A [DIM-1:0],
   input signed [BITS_AB-1:0] B [DIM-1:0],
   input signed [BITS_C-1:0]  Cin [DIM-1:0],
   input [$clog2(DIM)-1:0]    Crow,
   output signed [BITS_C-1:0] Cout [DIM-1:0]
   );
   
   logic [DIM-1:0] WrEnVector;
   logic signed [BITS_AB-1:0] A_int [DIM-1:0][DIM-1:0]; //[length] A_int [row#][column#]
   logic signed [BITS_AB-1:0] B_int [DIM-1:0][DIM-1:0];
   logic siged [BITS_C-1:0] Cout_int [DIM-1:0][DIM-1:0];
   
   

   genvar i, j;
   generate 
      for (i = 0; i <DIM; i++) begin //rows
         assign WrEnVector[i] = (Crow == i) ? WrEn : 0;
         for (j = 0; j < DIM; j++) begin //columns
            tpumac (.clk(clk), 
                    .rst_n(rst_n), 
                    .WrEn(WrEnVector[i]), 
                    .en(en), 
                    .Ain((j == 0)? A[i] : A_int[i][j-1]), 
                    .Aout(A_int[i][j]),
                    .Bin((i == 0) ? B[j] : B_int[i-1][j]), 
                    .Bout(B_int[i][j]), 
                    .Cin(Cin[i]), 
                    .Cout(Cout_int[i][j]));
         end
      end
   endgenerate
   
   assign Cout = Cout_int[Crow];
   
endmodule

                         
   
