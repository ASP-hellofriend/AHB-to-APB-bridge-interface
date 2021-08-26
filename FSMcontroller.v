module FSMcontroller(input HCLK,input HWRITE,input HRESETn,input Valid,input [31:0]HADDR_1,input [31:0]HADDR_2,input [31:0]HWDATA_1,input [31:0]HWDATA_2,input HWRITE_Reg,input [2:0]temp_SELX,
output reg PWRITE,output reg PENABLE,output reg [2:0]PSELx,output reg [31:0]PADDR,output reg [31:0]PWDATA,output reg HREADYout);

reg [2:0] current_state, next_state;

parameter ST_IDLE=3'b000,
          ST_WWAIT=3'b001,
		  ST_READ=3'b010,
		  ST_WRITE=3'b011,
		  ST_WRITEP=3'b100,
		  ST_RENABLE=3'b101,
		  ST_WENABLE=3'b110,
		  ST_WENABLEP=3'b111;
		  
always@(posedge HCLK)
begin
if(HRESETn)
current_state<=ST_IDLE;
else
current_state<=next_state;
end

always@(*)
begin
case(current_state)
ST_IDLE : begin
          
			   if (!Valid) 
				 next_state=ST_IDLE;	 
               
			   else
			   begin
                 if(HWRITE)
				 next_state=ST_WWAIT;				 
				 else
				 next_state=ST_READ;
		   end
		   end
			   
ST_WWAIT : begin
           
           next_state=ST_RENABLE; 
           end
		   
ST_READ : begin
          
		  next_state=ST_RENABLE;
		  
		  end
		  
ST_WRITE : begin
           
		   
		   if(Valid)
		   next_state=ST_WENABLEP;
		   else
		   next_state=ST_WENABLE;
		   end

ST_WRITEP : begin
           
		    next_state=ST_WENABLEP;
			end

ST_RENABLE : begin
             
			 if(!Valid)
		     next_state=ST_IDLE;
		     else
			 begin
			 if(HWRITE)
		     next_state=ST_WWAIT;
			 else
			 next_state=ST_READ;
			 end
			 end

ST_WENABLE : begin

             if(!Valid)
		     next_state=ST_IDLE;
		     else
			 begin
			 if(HWRITE)
		     next_state=ST_WWAIT;
			 else
			 next_state=ST_READ;
			 end
			 end

ST_WENABLEP : begin
              if(!HWRITE_Reg)
		      next_state=ST_READ;
		      else
			  begin
			  if(Valid)
		      next_state=ST_WRITEP;
			  else
			  next_state=ST_WRITE;
			  end
			  end
default : next_state=ST_IDLE;
endcase

end 

reg [31:0]ADDR;

always@(*)
begin
HREADYout=0;
PADDR=0;
PSELx=0;
PENABLE=0;
PWDATA=0;
PWRITE=0;

case(current_state)

ST_IDLE : begin
          HREADYout=1;
		  end
		  
ST_READ : begin
		  PADDR=HADDR_1;
		  PSELx=temp_SELX;
		  HREADYout=0;
		  end
		  
ST_RENABLE : begin
             PENABLE=1;
			 HREADYout=1;
			 PADDR=HADDR_2;
			 PSELx=temp_SELX;
             end

ST_WENABLE : begin
             PWDATA=HWDATA_1;
			 PADDR=HADDR_1;
			 PENABLE=1;
			 PSELx=temp_SELX;
			 HREADYout=1;
			 PWRITE=1;
			 end

ST_WRITE : begin
           PADDR=HADDR_1;
		   PWDATA=HWDATA_1;
		   PWRITE=1;
		   PENABLE=0;
		   PSELx=temp_SELX;
		   HREADYout=1;
		   end

ST_WWAIT : begin
           HREADYout=1;
		   end

ST_WRITEP : begin 
            PWDATA=HWDATA_1;
			PWRITE=1;
			PSELx=temp_SELX;
			PADDR=HADDR_2;
			ADDR=PADDR;
			end

ST_WENABLEP : begin 
              PWRITE=1;
			  PENABLE=1;
			  PSELx=temp_SELX;
			  PADDR=ADDR;
			  PWDATA=HWDATA_2;
			  HREADYout=1;
			  end
			  
endcase

end

/*always@(posedge HCLK)
begin
if(HRESETn)
begin
PWRITE<=0;
PENABLE<=0;
PSELx<=0;
PADDR<=0;
PWDATA<=0;
HREADYout<=0;
end
else
begin
PWRITE<=PWRITE_temp;
PENABLE<=PENABLE_temp;
PSELx<=PSELX_temp;
PADDR<=PADDR_temp;
PWDATA<=PWDATA_temp;
HREADYout<=HREADYout_temp;
end
end
*/
endmodule