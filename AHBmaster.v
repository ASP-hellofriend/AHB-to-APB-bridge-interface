module AHBmaster(input HCLK, input HRESETn, input [31:0]HRDATA, input [1:0]HRESP,
                 input HREADYout, output reg HWRITE, output reg HREADYin,output reg [1:0]HTRANS,
				 output reg [31:0] HADDR, output reg[31:0] HWDATA);

reg [2:0]HSIZE;
reg [2:0]HBURST;

parameter BYTE=3'b000;
parameter HALF_WORD=3'b001;
parameter WORD=3'b010;

task single_write();
begin

@(posedge HCLK)
#1;
begin
HBURST=3'b000;
HADDR=32'h80000001;
HWRITE=1'b1;
HREADYin=1'b1;
HTRANS=2'b10;
end

@(posedge HCLK)
#1;
begin
HWDATA=32'h00001122;
HTRANS=2'b00;
end 

end
endtask

task single_read();
begin

@(posedge HCLK)
#1;
begin
HADDR=32'h80000001;
HWRITE=1'b0;
HREADYin=1'b1;
HTRANS=2'b10;
end

@(posedge HCLK)
#1;
begin
HTRANS=2'b00;
end 

end
endtask 

endmodule