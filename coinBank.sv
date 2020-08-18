module coin (input Clk, Reset, input [9:0] playerPosX, playerPosY, input [4:0] coinPosX, coinPosY, input coinReset, input crossroadCheck, output presentCheck);

enum logic [1:0] { INVISIBLE, VISIBLE } state, next_state;

always_ff @ (posedge Clk, posedge Reset) 
	begin
		if (Reset == 1'b1)
			begin
				state <= VISIBLE;
			end
			else begin
				state <= next_state;
			end
	end
	
always_comb
	begin
		next_state = state;
		
		case (state)
			VISIBLE :
				begin
					if (playerPosX [9:5] == coinPosX && playerPosY [9:5] == coinPosY && crossroadCheck == 1'b1)
						next_state = INVISIBLE;
					else
						next_state = state;
				end
			INVISIBLE :
				begin
					next_state = state;
				end
		endcase		
	end
	
always_comb 
	begin 
		presentCheck = coinReset;
		case (state)
			INVISIBLE :
				begin
					presentCheck = 1'b0;
				end
			VISIBLE :
				begin
					presentCheck = coinReset;
				end
		endcase
	end
	
endmodule

module coinRow (input Clk, Reset, input [11:0] coinResetIndex, input [9:0] playerPosX, playerPosY, input [4:0] coinPosY, input crossroadCheck, output [11:0] presentCheck, output emptyRow);

	always_comb
	begin
		if (presentCheck)
		begin
			emptyRow = 1'b1;
		end
		else
		begin
			emptyRow = 1'b0;
		end
	end
	
	coin coin1 (.*, .coinReset (coinResetIndex[11]), .coinPosX (5'h01), .presentCheck (presentCheck[11]));
	coin coin2 (.*, .coinReset (coinResetIndex[10]), .coinPosX (5'h02), .presentCheck (presentCheck[10]));
	coin coin3 (.*, .coinReset (coinResetIndex[9]), .coinPosX (5'h03), .presentCheck (presentCheck[9]));
	coin coin4 (.*, .coinReset (coinResetIndex[8]), .coinPosX (5'h04), .presentCheck (presentCheck[8]));
	coin coin5 (.*, .coinReset (coinResetIndex[7]), .coinPosX (5'h05), .presentCheck (presentCheck[7]));
	coin coin6 (.*, .coinReset (coinResetIndex[6]), .coinPosX (5'h06), .presentCheck (presentCheck[6]));
	coin coin7 (.*, .coinReset (coinResetIndex[5]), .coinPosX (5'h07), .presentCheck (presentCheck[5]));
	coin coin8 (.*, .coinReset (coinResetIndex[4]), .coinPosX (5'h08), .presentCheck (presentCheck[4]));
	coin coin9 (.*, .coinReset (coinResetIndex[3]), .coinPosX (5'h09), .presentCheck (presentCheck[3]));
	coin coin10 (.*, .coinReset (coinResetIndex[2]), .coinPosX (5'h0a), .presentCheck (presentCheck[2]));
	coin coin11 (.*, .coinReset (coinResetIndex[1]), .coinPosX (5'h0b), .presentCheck (presentCheck[1]));
	coin coin12 (.*, .coinReset (coinResetIndex[0]), .coinPosX (5'h0c), .presentCheck (presentCheck[0]));

endmodule

module coinAssembler (input Clk, Reset, input [143:0] coinArrangement, input [9:0] playerPosX, playerPosY, output [143:0] presentCheck, output boardCheck);

logic crossroadCheck;
assign crossroadCheck = ~(playerPosX[0] | playerPosX[1] | playerPosX[2] | playerPosX[3] | playerPosX[4] | playerPosY[0] | playerPosY[1] | playerPosY[2] | playerPosY[3] | playerPosY[4]);

logic rowCheck [11:0];
always_comb
	begin
		if (rowCheck)
			boardCheck = 1'b1;
		else
			boardCheck = 1'b0;
	end
	
coinRow row1 (.*, .coinResetIndex (coinArrangement[143:132]), .coinPosY (5'h01), .presentCheck (presentCheck[143:132]), .emptyRow (rowCheck[11]));
coinRow row2 (.*, .coinResetIndex (coinArrangement[131:120]), .coinPosY (5'h02), .presentCheck (presentCheck[131:120]), .emptyRow (rowCheck[10]));
coinRow row3 (.*, .coinResetIndex (coinArrangement[119:108]), .coinPosY (5'h03), .presentCheck (presentCheck[119:108]), .emptyRow (rowCheck[9]));
coinRow row4 (.*, .coinResetIndex (coinArrangement[107:96]), .coinPosY (5'h04), .presentCheck (presentCheck[107:96]), .emptyRow (rowCheck[8]));
coinRow row5 (.*, .coinResetIndex (coinArrangement[95:84]), .coinPosY (5'h05), .presentCheck (presentCheck[95:84]), .emptyRow (rowCheck[7]));
coinRow row6 (.*, .coinResetIndex (coinArrangement[83:72]), .coinPosY (5'h06), .presentCheck (presentCheck[83:72]), .emptyRow (rowCheck[6]));
coinRow row7 (.*, .coinResetIndex (coinArrangement[71:60]), .coinPosY (5'h07), .presentCheck (presentCheck[71:60]), .emptyRow (rowCheck[5]));
coinRow row8 (.*, .coinResetIndex (coinArrangement[59:48]), .coinPosY (5'h08), .presentCheck (presentCheck[59:48]), .emptyRow (rowCheck[4]));
coinRow row9 (.*, .coinResetIndex (coinArrangement[47:36]), .coinPosY (5'h09), .presentCheck (presentCheck[47:36]), .emptyRow (rowCheck[3]));
coinRow row10 (.*, .coinResetIndex (coinArrangement[35:24]), .coinPosY (5'h0a), .presentCheck (presentCheck[35:24]), .emptyRow (rowCheck[2]));
coinRow row11 (.*, .coinResetIndex (coinArrangement[23:12]), .coinPosY (5'h0b), .presentCheck (presentCheck[23:12]), .emptyRow (rowCheck[1]));
coinRow row12 (.*, .coinResetIndex (coinArrangement[11:0]), .coinPosY (5'h0c), .presentCheck (presentCheck[11:0]), .emptyRow (rowCheck[0]));

endmodule
