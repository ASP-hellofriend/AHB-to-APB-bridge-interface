module bridgetop(input HWRITE, input HREADYin, input [1:0]HTRANS, input [31:0] HADDR, input [31:0]HWDATA,
input [31:0]PRDATA, input HCLK, input HRESETn, output PWRITE, output PENABLE, output [2:0] PSELx,
output [31:0] PADDR, output [31:0] PWDATA, output [1:0]HRESP, output HREADYout, output[31:0] HRDATA);

wire Valid;
wire [31:0]HADDR_1, HADDR_2, HWDATA_1, HWDATA_2;
wire HWRITE_Reg;
wire [2:0]temp_SELX;

AHBslave slave(HWRITE,HCLK,HRESETn,HREADYin,HTRANS,HADDR,HWDATA,Valid,HADDR_1,HADDR_2,HWDATA_1,HWDATA_2,HWRITE_Reg,temp_SELX);

FSMcontroller FSMcont(HCLK,HWRITE,HRESETn,Valid,HADDR_1,HADDR_2,HWDATA_1,HWDATA_2,HWRITE_Reg,temp_SELX,PWRITE,PENABLE,PSELx,PADDR,PWDATA,HREADYout);

assign HRDATA=PRDATA;
assign HRESP=0;
endmodule