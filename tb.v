module tb();

reg HCLK, HRESETn;
wire HREADYout, PWRITE_OUT, PENABLE_OUT;
wire [2:0] PSELx_OUT;
wire [1:0] HRESP;
wire [31:0] HRDATA, PADDR_OUT, PWDATA_OUT, PRDATA;

wire HWRITE,HREADYin,PWRITE,PENABLE;
wire [1:0]HTRANS;
wire [31:0] HADDR,HWDATA,PADDR,PWDATA;
wire [2:0] PSELx;

assign HRDATA=PRDATA;

AHBmaster AHB_MASTER(HCLK,HRESETn,HRDATA,HRESP,HREADYout,HWRITE,HREADYin,HTRANS,HADDR,HWDATA);

bridgetop BRIDGE_TOP(HWRITE,HREADYin,HTRANS,HADDR,HWDATA,PRDATA,HCLK,HRESETn,PWRITE,PENABLE,PSELx,PADDR,PWDATA,HRESP,HREADYout,HRDATA);

APBinterface APB_INTERFACE(PWRITE,PENABLE,PSELx,PADDR,PWDATA,PWRITE_OUT,PENABLE_OUT,PSELx_OUT,PADDR_OUT,PWDATA_OUT,PRDATA);

initial
begin
HCLK=1'b0;
forever
#5 HCLK=~HCLK;
end 

task rst();
begin
@(negedge HCLK)
HRESETn=1'b1;
@(negedge HCLK)
HRESETn=1'b0;
end
endtask

initial
begin
rst;
//AHB_MASTER.single_write;
AHB_MASTER.single_read;
#200;
$finish;
end 

endmodule