module rowWallVerify (input [0:12] yWalls, input [0:11] top, bottom, input [0:4] posX, output logic leftTurn, rightTurn, upTurn, downTurn);

	always_comb
		begin
			unique case (posX)
			5'h00 : begin
				leftTurn = 1'b0;
				rightTurn = 1'b1;
				upTurn = 1'b0;
				downTurn = 1'b0;
			end
			5'h01 : begin
				leftTurn = ~yWalls[0];
				rightTurn = ~yWalls[1];
				upTurn = ~top[0];
				downTurn = ~bottom[0];
			end
			5'h02 : begin
				leftTurn = ~yWalls[1];
				rightTurn = ~yWalls[2];
				upTurn = ~top[1];
				downTurn = ~bottom[1];
			end
			5'h03 : begin
				leftTurn = ~yWalls[2];
				rightTurn = ~yWalls[3];
				upTurn = ~top[2];
				downTurn = ~bottom[2];
			end
			5'h04 : begin
				leftTurn = ~yWalls[3];
				rightTurn = ~yWalls[4];
				upTurn = ~top[3];
				downTurn = ~bottom[3];
			end
			5'h05 : begin
				leftTurn = ~yWalls[4];
				rightTurn = ~yWalls[5];
				upTurn = ~top[4];
				downTurn = ~bottom[4];
			end
			5'h06 : begin
				leftTurn = ~yWalls[5];
				rightTurn = ~yWalls[6];
				upTurn = ~top[5];
				downTurn = ~bottom[5];
			end
			5'h07 : begin
				leftTurn = ~yWalls[6];
				rightTurn = ~yWalls[7];
				upTurn = ~top[6];
				downTurn = ~bottom[6];
			end
			5'h08 : begin
				leftTurn = ~yWalls[7];
				rightTurn = ~yWalls[8];
				upTurn = ~top[7];
				downTurn = ~bottom[7];
			end
			5'h09 : begin
				leftTurn = ~yWalls[8];
				rightTurn = ~yWalls[9];
				upTurn = ~top[8];
				downTurn = ~bottom[8];
			end
			5'h0a : begin
				leftTurn = ~yWalls[9];
				rightTurn = ~yWalls[10];
				upTurn = ~top[9];
				downTurn = ~bottom[9];
			end
			5'h0b : begin
				leftTurn = ~yWalls[10];
				rightTurn = ~yWalls[11];
				upTurn = ~top[10];
				downTurn = ~bottom[10];
			end
			5'h0c : begin
				leftTurn = ~yWalls[11];
				rightTurn = ~yWalls[12];
				upTurn = ~top[11];
				downTurn = ~bottom[11];
			end
			default : begin
				leftTurn = 1'b1;
				rightTurn = 1'b0;
				upTurn = 1'b0;
				downTurn = 1'b0;
			end
			endcase
		end
endmodule

module wallVerify (input [0:155] xWalls, yWalls, input [0:4] posX, posY, output logic leftTurnCheck, rightTurnCheck, upTurnCheck, downTurnCheck);
	
	logic [0:11] leftTurn, rightTurn, upTurn, downTurn;
	
	rowWallVerify wall1 (.*, .top( xWalls[0:11] ), .bottom( xWalls[12:23] ), .yWalls( yWalls[0:12] ), .leftTurn( leftTurn[0] ), .rightTurn( rightTurn[0] ), .upTurn( upTurn[0] ), .downTurn( downTurn[0] ));
	rowWallVerify wall2 (.*, .top( xWalls[12:23] ), .bottom( xWalls[24:35] ), .yWalls( yWalls[13:25] ), .leftTurn( leftTurn[1] ), .rightTurn( rightTurn[1] ), .upTurn( upTurn[1] ), .downTurn( downTurn[1] ));
	rowWallVerify wall3 (.*, .top( xWalls[24:35] ), .bottom( xWalls[36:47] ), .yWalls( yWalls[26:38] ), .leftTurn( leftTurn[2] ), .rightTurn( rightTurn[2] ), .upTurn( upTurn[2] ), .downTurn( downTurn[2] ));
	rowWallVerify wall4 (.*, .top( xWalls[36:47] ), .bottom( xWalls[48:59] ), .yWalls( yWalls[39:51] ), .leftTurn( leftTurn[3] ), .rightTurn( rightTurn[3] ), .upTurn( upTurn[3] ), .downTurn( downTurn[3] ));
	rowWallVerify wall5 (.*, .top( xWalls[48:59] ), .bottom( xWalls[60:71] ), .yWalls( yWalls[52:64] ), .leftTurn( leftTurn[4] ), .rightTurn( rightTurn[4] ), .upTurn( upTurn[4] ), .downTurn( downTurn[4] ));
	rowWallVerify wall6 (.*, .top( xWalls[60:71] ), .bottom( xWalls[72:83] ), .yWalls( yWalls[65:77] ), .leftTurn( leftTurn[5] ), .rightTurn( rightTurn[5] ), .upTurn( upTurn[5] ), .downTurn( downTurn[5] ));
	rowWallVerify wall7 (.*, .top( xWalls[72:83] ), .bottom( xWalls[84:95] ), .yWalls( yWalls[78:90] ), .leftTurn( leftTurn[6] ), .rightTurn( rightTurn[6] ), .upTurn( upTurn[6] ), .downTurn( downTurn[6] ));
	rowWallVerify wall8 (.*, .top( xWalls[84:95] ), .bottom( xWalls[96:107] ), .yWalls( yWalls[91:103] ), .leftTurn( leftTurn[7] ), .rightTurn( rightTurn[7] ), .upTurn( upTurn[7] ), .downTurn( downTurn[7] ));
	rowWallVerify wall9 (.*, .top( xWalls[96:107] ), .bottom( xWalls[108:119] ), .yWalls( yWalls[104:116] ), .leftTurn( leftTurn[8] ), .rightTurn( rightTurn[8] ), .upTurn( upTurn[8] ), .downTurn( downTurn[8] ));
	rowWallVerify wall10 (.*, .top( xWalls[108:119] ), .bottom( xWalls[120:131] ), .yWalls( yWalls[117:129] ), .leftTurn( leftTurn[9] ), .rightTurn( rightTurn[9] ), .upTurn( upTurn[9] ), .downTurn( downTurn[9] ));
	rowWallVerify wall11 (.*, .top( xWalls[120:131] ), .bottom( xWalls[132:143] ), .yWalls( yWalls[130:142] ), .leftTurn( leftTurn[10] ), .rightTurn( rightTurn[10] ), .upTurn( upTurn[10] ), .downTurn( downTurn[10] ));
	rowWallVerify wall12 (.*, .top( xWalls[132:143] ), .bottom( xWalls[144:155] ), .yWalls( yWalls[143:155] ), .leftTurn( leftTurn[11] ), .rightTurn( rightTurn[11] ), .upTurn( upTurn[11] ), .downTurn( downTurn[11] ));
	
	always_comb
		begin
			unique case (posY)
			5'h00 : begin
				leftTurnCheck = 1'b0;
				rightTurnCheck = 1'b0;
				upTurnCheck = 1'b0;
				downTurnCheck = 1'b1;
			end
			5'h01 : begin
				leftTurnCheck = leftTurn[0];
				rightTurnCheck = rightTurn[0];
				upTurnCheck = upTurn[0];
				downTurnCheck = downTurn[0];
			end
			5'h02 : begin
				leftTurnCheck = leftTurn[1];
				rightTurnCheck = rightTurn[1];
				upTurnCheck = upTurn[1];
				downTurnCheck = downTurn[1];
			end
			5'h03 : begin
				leftTurnCheck = leftTurn[2];
				rightTurnCheck = rightTurn[2];
				upTurnCheck = upTurn[2];
				downTurnCheck = downTurn[2];
			end
			5'h04 : begin
				leftTurnCheck = leftTurn[3];
				rightTurnCheck = rightTurn[3];
				upTurnCheck = upTurn[3];
				downTurnCheck = downTurn[3];
			end
			5'h05 : begin
				leftTurnCheck = leftTurn[4];
				rightTurnCheck = rightTurn[4];
				upTurnCheck = upTurn[4];
				downTurnCheck = downTurn[4];
			end
			5'h06 : begin
				leftTurnCheck = leftTurn[5];
				rightTurnCheck = rightTurn[5];
				upTurnCheck = upTurn[5];
				downTurnCheck = downTurn[5];
			end
			5'h07 : begin
				leftTurnCheck = leftTurn[6];
				rightTurnCheck = rightTurn[6];
				upTurnCheck = upTurn[6];
				downTurnCheck = downTurn[6];
			end
			5'h08 : begin
				leftTurnCheck = leftTurn[7];
				rightTurnCheck = rightTurn[7];
				upTurnCheck = upTurn[7];
				downTurnCheck = downTurn[7];
			end
			5'h09 : begin
				leftTurnCheck = leftTurn[8];
				rightTurnCheck = rightTurn[8];
				upTurnCheck = upTurn[8];
				downTurnCheck = downTurn[8];
			end
			5'h0a : begin
				leftTurnCheck = leftTurn[9];
				rightTurnCheck = rightTurn[9];
				upTurnCheck = upTurn[9];
				downTurnCheck = downTurn[9];
			end
			5'h0b : begin
				leftTurnCheck = leftTurn[10];
				rightTurnCheck = rightTurn[10];
				upTurnCheck = upTurn[10];
				downTurnCheck = downTurn[10];
			end
			5'h0c : begin
				leftTurnCheck = leftTurn[11];
				rightTurnCheck = rightTurn[11];
				upTurnCheck = upTurn[11];
				downTurnCheck = downTurn[11];
			end
			default : begin
				leftTurnCheck = 1'b0;
				rightTurnCheck = 1'b0;
				upTurnCheck = 1'b1;
				downTurnCheck = 1'b0;
			end
			endcase
		end
endmodule 
