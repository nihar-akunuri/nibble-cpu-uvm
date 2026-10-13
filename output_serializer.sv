module output_serializer(input clk,input rst_n,input [31:0] data_in,input data_valid,input cmd_busy,output [3:0] serial_out,output serial_valid,output serializer_busy);
 reg [2:0] nibble_counter; reg [31:0] data_reg; reg valid_reg,busy_reg;
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin nibble_counter<=3'd0; data_reg<=32'd0; valid_reg<=1'b0; busy_reg<=1'b0; end
  else if (data_valid && !busy_reg) begin data_reg<=data_in; nibble_counter<=3'd0; valid_reg<=1'b1; busy_reg<=1'b1; end
  else if (busy_reg) begin
   if (nibble_counter==3'd7) begin nibble_counter<=3'd0; valid_reg<=1'b0; busy_reg<=1'b0; end
   else begin nibble_counter<=nibble_counter+3'd1; valid_reg<=1'b1; end
   data_reg<={4'd0,data_reg[31:4]};
  end else valid_reg<=1'b0;
 end
 assign serial_out=data_reg[3:0]; assign serial_valid=valid_reg; assign serializer_busy=busy_reg;
endmodule
