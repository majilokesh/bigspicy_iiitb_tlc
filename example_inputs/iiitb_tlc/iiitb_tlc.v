`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:32:27 07/24/2022 
// Design Name: 
// Module Name:    traffic_light 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
// Verilog project: Verilog code for traffic light controller
module iiitb_tlc(light_highway, light_farm, C, clk, rst_n);

	parameter HGRE_FRED = 2'b00, // Highway green and farm red
		  HYEL_FRED = 2'b01,// Highway yellow and farm red
		  HRED_FGRE = 2'b10,// Highway red and farm green
		  HRED_FYEL = 2'b11;// Highway red and farm yellow
	input C, // sensor
   	clk, // clock = 50 MHz
   	rst_n; // reset active low

	output reg[2:0] light_highway, light_farm; // output of lights
	reg[1:0]  RED_count_en, YELLOW_count_en1, YELLOW_count_en2;
	reg[1:0] state, next_state;
	integer i;
// next state
	always @(posedge clk or negedge rst_n)
		begin
			if(~rst_n)
			begin
			RED_count_en<=0;YELLOW_count_en1<=0;YELLOW_count_en2<=0;
			 state <= 2'b00;
			end
			else 
			 state <= next_state; 
		end
// FSM
	always @(*)
		begin
			case(state)
				HGRE_FRED: 
					begin // Green on highway and red on farm way

					 RED_count_en <= 2'b01;
					 YELLOW_count_en1 <= 2'b00;
					 YELLOW_count_en2 <= 2'b00;
					 light_highway <= 3'b001;
					 light_farm <= 3'b100;
					 if(C) next_state <= HYEL_FRED; 
					 // if sensor detects vehicles on farm road, 

					 else next_state <= HGRE_FRED;
					end
				HYEL_FRED: 
					begin// yellow on highway and red on farm way

					RED_count_en <= 2'b00;
					YELLOW_count_en1 <= 2'b01;
					YELLOW_count_en2 <= 2'b00;					  
					light_highway <= 3'b010;
					light_farm <= 3'b100;
					next_state <= HRED_FGRE;

					end
				HRED_FGRE: 
					begin// red on highway and green on farm way
					
					RED_count_en <= 2'b01;
					YELLOW_count_en1 <= 2'b00;
					YELLOW_count_en2 <= 2'b00;					 
					light_highway <= 3'b100;
					light_farm <= 3'b001; 
					next_state <= HRED_FYEL;

					end
				HRED_FYEL:
					begin// red on highway and yellow on farm way

					RED_count_en <= 2'b00;
					YELLOW_count_en1 <= 2'b00;
					YELLOW_count_en2 <= 2'b01;					 
					light_highway <= 3'b100;
					light_farm <= 3'b010; 
					next_state <= HGRE_FRED;

					end
				default: next_state <= HGRE_FRED;
			endcase
		end

endmodule
