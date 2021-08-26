module APBinterface(input PWRITE, input PENABLE, input [2:0] PSELx, input [31:0] PADDR, input [31:0] PWDATA,
                 output PWRITE_OUT, output PENABLE_OUT, output [2:0] PSELx_OUT, output  [31:0] PADDR_OUT, output[31:0] PWDATA_OUT, output reg[31:0] PRDATA);

assign PWDATA_OUT=PWDATA;
assign PWRITE_OUT=PWRITE;
assign PENABLE_OUT=PENABLE;
assign PSELx_OUT=PSELx;
assign PADDR_OUT=PADDR;

always@(*)
begin
if(PENABLE && !PWRITE)
PRDATA=32'h00001111;
else
PRDATA=32'h00000000;			 
end
			 
endmodule