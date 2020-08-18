//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module color_mapper (input [0:143] coinLocs, input [9:0] playerX, playerY, DrawX, DrawY, playerSize, redGhostX, redGhostY, orangeGhostX, orangeGhostY, blueGhostX, blueGhostY, pinkGhostX, pinkGhostY, input [1:0] dir, input level, output logic [7:0] VGA_R, VGA_G, VGA_B);
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 logic [415:0] levelSprite;
	 logic [31:0] ghostRedSprite, ghostOrangeSprite, ghostBlueSprite, ghostPinkSprite;
	 logic [0:31] playerSprite;
	 logic [9:0] levelADDR, xStretch, yStretch, tmp;
	 logic [7:0] playerADDR, ghostRedADDR, ghostOrangeADDR, ghostBlueADDR, ghostPinkADDR;
	 logic [2:0] coinADDR;
	 logic [1:0] coinSprite;
	 logic playerCheck, redGhostCheck, orangeGhostCheck, blueGhostCheck, pinkGhostCheck, wallCheck, coinCheck;
	 
	 assign xStretch = (DrawX - 30);
	 assign yStretch = (DrawY - 30);
	 assign tmp = (DrawY - playerY + playerSize + 96 + (32 * dir));
	 
	 playerBank player( .renderSelect(playerADDR), .spriteOut(playerSprite) );
	 playerBank redGhost( .renderSelect(ghostRedADDR), .spriteOut(ghostRedSprite) );
	 playerBank orangeGhost( .renderSelect(ghostOrangeADDR), .spriteOut(ghostOrangeSprite) );
	 playerBank blueGhost( .renderSelect(ghostBlueADDR), .spriteOut(ghostBlueSprite) );
	 playerBank pinkGhost( .renderSelect(ghostPinkADDR), .spriteOut(ghostPinkSprite) );
	 levelData map( .renderSelect(levelADDR), .levelOut(levelSprite) );
	 coinBank coinEntity( .renderSelect(coinADDR), .spriteOut(coinSprite) );
	 
	 always_comb
		begin
			if ( (DrawX >= (playerX - playerSize)) && (DrawX <= (playerX + playerSize)) && (DrawY >= (playerY - playerSize)) && (DrawY <= (playerY + playerSize)) )
			begin
				playerADDR = tmp[7:0];
				playerCheck = 1'b1;
			end
			else
			begin
				playerADDR = 7'b0000000;
				playerCheck = 1'b0;
			end
			
			if ( (DrawX >= (redGhostX - playerSize)) && (DrawX <= (redGhostX + playerSize)) && (DrawY >= (redGhostY - playerSize)) && (DrawY <= (redGhostY - playerSize)) )
			begin
				ghostRedADDR = (DrawY - redGhostX + playerSize + 224);
				redGhostCheck = 1'b1;
			end
			else
			begin
				ghostRedADDR = 7'b0000000;
				redGhostCheck = 1'b0;
			end
			
			if ( (DrawX >= (orangeGhostX - playerSize)) && (DrawX <= (orangeGhostX + playerSize)) && (DrawY >= (orangeGhostY - playerSize)) && (DrawY <= (orangeGhostY - playerSize)) )
			begin
				ghostOrangeADDR = (DrawY - orangeGhostX + playerSize + 224);
				orangeGhostCheck = 1'b1;
			end
			else
			begin
				ghostOrangeADDR = 7'b0000000;
				orangeGhostCheck = 1'b0;
			end
			
			if ( (DrawX >= (blueGhostX - playerSize)) && (DrawX <= (blueGhostX + playerSize)) && (DrawY >= (blueGhostY - playerSize)) && (DrawY <= (blueGhostY - playerSize)) )
			begin
				ghostBlueADDR = (DrawY - blueGhostX + playerSize + 224);
				blueGhostCheck = 1'b1;
			end
			else
			begin
				ghostBlueADDR = 7'b0000000;
				blueGhostCheck = 1'b0;
			end

			if ( (DrawX >= (pinkGhostX - playerSize)) && (DrawX <= (pinkGhostX + playerSize)) && (DrawY >= (pinkGhostY - playerSize)) && (DrawY <= (pinkGhostY - playerSize)) )
			begin
				ghostPinkADDR = (DrawY - pinkGhostX + playerSize + 224);
				pinkGhostCheck = 1'b1;
			end
			else
			begin
				ghostPinkADDR = 7'b0000000;
				pinkGhostCheck = 1'b0;
			end
			
			if (DrawX > 16 && DrawY > 16 && DrawX < 410 && DrawY <= 400 && coinLocs[ yStretch[9:5] * 12 + xStretch[9:5] ] == 1'b1 && xStretch[4:0] <= 3 && yStretch[4:0] <= 3)
			begin
				coinADDR = yStretch[2:0];
				coinCheck = 1'b1;
			end
			else
			begin
				coinADDR = 3'b100;
				coinCheck = 1'b0;
			end
			
			if (DrawX < 416 && DrawY <= 400)
				begin
					if (level == 1'b1)
					begin
						levelADDR = DrawY + 220;
					end
					else
					begin
						levelADDR = DrawY + 624;
					end
					wallCheck = 1'b1;
				end
			else	
			begin
				levelADDR = 10'b0000000000;
				wallCheck = 1'b0;
			end
		end
		
	always_comb
	begin : RGB
		if (playerCheck == 1'b1 && playerSprite[DrawX - playerX + playerSize] == 1'b1)
		begin
			Red = 8'h00;
			Green = 8'hff;
			Blue = 8'h00;
		end
		else if (redGhostCheck == 1'b1 && ghostRedSprite[DrawX - redGhostX + playerSize] == 1'b1)
		begin
			Red = 8'hff;
			Green = 8'h5f;
			Blue = 8'h5f;
		end
		else if (orangeGhostCheck == 1'b1 && ghostOrangeSprite[DrawX - orangeGhostX + playerSize] == 1'b1)
		begin
			Red = 8'hff;
			Green = 8'hb8;
			Blue = 8'h51;
		end
		else if (blueGhostCheck == 1'b1 && ghostBlueSprite[DrawX - blueGhostX + playerSize] == 1'b1)
		begin
			Red = 8'h01;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if (pinkGhostCheck == 1'b1 && ghostPinkSprite[DrawX - pinkGhostX + playerSize] == 1'b1)
		begin
			Red = 8'hff;
			Green = 8'hb8;
			Blue = 8'hff;
		end
		else if (coinCheck == 1'b1 && coinSprite[xStretch[1:0]] == 1'b1)
		begin
			Red = 8'h00;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if (wallCheck == 1'b1 && levelSprite[DrawX] == 1'b1)
		begin
			Red = 8'hff;
			Green = 8'h00;
			Blue = 8'hff;
		end
		else
		begin
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
		end
	end

endmodule 
