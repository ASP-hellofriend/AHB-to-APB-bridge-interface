module AHBslave(input HWRITE,input HCLK,input HRESETn,input HREADYin,input [1:0]HTRANS,input [31:0]HADDR,input [31:0]HWDATA,
output reg Valid,output reg [31:0]HADDR_1,output reg [31:0]HADDR_2,output reg [31:0]HWDATA_1,output reg [31:0]HWDATA_2,output reg HWRITE_Reg,output reg [2:0]temp_SELX);

parameter IDLE=2'b00,
	       BUSY=2'b01,
	       NONSEQ=2'b10,
	       SEQ=2'b11;



always@(posedge HCLK)
  begin
	if(HRESETn)
       	 begin
          HADDR_1<=1'b0;
	       HADDR_2<=1'b0;
	       end
	else
	       begin
	       HADDR_1<=HADDR;
	       HADDR_2<=HADDR_1;
	       end
  end


always@(posedge HCLK)
  begin
	if(HRESETn)
	  begin
	    HWDATA_1<=1'b0;
	    HWDATA_2<=1'b0;
	  end

	else
	  begin
	   HWDATA_1<=HWDATA;
	   HWDATA_2<=HWDATA_1;
	  end
  end


always@(posedge HCLK)
  begin
	if(HRESETn)
	   HWRITE_Reg<=1'b0;
	else
	   HWRITE_Reg<=HWRITE;
  end
  
 always@(*)
  begin
    if(HRESETn)
        Valid=1'b0; 
    else if((HADDR>32'h80000000 && HADDR< 32'h8c000000)&& HREADYin && HTRANS !=2'b01 && HTRANS!=2'b00) 
         Valid=1'b1;
    else
         Valid=1'b0;
   end
   
//assign Valid =  (!HRESETn && HREADYin && HTRANS !=2'b01 & HTRANS!=2'b00 &((!(HADDR >=32'h8c000000 & HADDR <=32'h00000000) & HWRITE == 1 ) || HWRITE == 0));

always@(*)
  begin
    if((HADDR<=32'h8c000000 && HADDR>=32'h88000001)) 
  temp_SELX=3'b100;
  else if((HADDR<=32'h88000000 && HADDR>=32'h84000001))
  temp_SELX=3'b010;
   else if((HADDR<=32'h84000000 && HADDR>=32'h80000000))
  temp_SELX=3'b001;
  end
								   
/*always@(*)
begin
Valid =  (!HRESETn & HREADYin & HTRANS !=2'b01 & HTRANS!=2'b00 & 
                                   ((!(HADDR >=32'h80000000 & HADDR <=32'h8c000000) & HWRITE == 1 ) || HWRITE == 0));
end */


endmodule