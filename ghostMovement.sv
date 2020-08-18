module ghostMovement (input Clk, Reset, input [155:0] xWalls, yWalls, input [15:0] generation, input [9:0] playerX, playerY, input [4:0] fiveXStart, fiveYStart, output [9:0] ghostX, ghostY, output killPlayer);

	parameter [9:0] boardMin = 0;
	parameter [9:0] boardXMax = 639;
	parameter [9:0] boardYMax = 479;
	parameter [9:0] boardXCenter = 320;
	parameter [9:0] boardYCenter = 240;
	parameter [9:0] ghostStep = 1;

	logic [9:0] xaCompare, yaCompare, xbCompare, ybCompare, xDifference, yDifference, xContact, yContact, lenContact;
	logic [3:0] directions;
	logic [1:0] rSelect;
	logic leftPass, rightPass, upPass, downPass, xBound, xTileBound, yBound, yTileBound;
	
	logic [9:0] xStart, posX, posXInertia, posXInertiaInc, posXInertiaEnd, posXTurn, posXTurnPrev, yStart, posY, posYInertia, posYInertiaInc, posYInertiaEnd, posYTurn, posYTurnPrev, posSize;
	logic [2:0] dirTurn, generationCount, generationInc;
	logic crossroadCheck, pivotCheck, moveCheck, leftTurnCheck, rightTurnCheck, upTurnCheck, downTurnCheck, leftMoveCheck, rightMoveCheck, upMoveCheck, downMoveCheck;
	
	wallVerify ghostWall (.*, .posX( posX[9:5] ), .posY( posY[9:5] ));
	
	assign posSize = 4;
	assign directions = { leftTurnCheck, rightTurnCheck, upTurnCheck, downTurnCheck };
	assign xStart = { fiveXStart, 5'b0 };
	assign yStart = { fiveYStart, 5'b0 };
	assign lenContact = 10'h010;
	
	always_comb begin
		xbCompare = (~(posX) + 1'b1) + (playerX);
		ybCompare = (~(posY) + 1'b1) + (playerY);
		xaCompare = posX + (~(playerX) + 1'b1);
		yaCompare = posY + (~(playerY) + 1'b1);
		
		if (xaCompare[9])
		begin
			xDifference = xbCompare;
		end
		else
		begin
			xDifference = xaCompare;
		end
		if (yaCompare[9])
		begin
			yDifference = ybCompare;
		end
		else
			yDifference = yaCompare;
		
		xContact = xDifference + (~(lenContact) + 1'b1);
		yContact = yDifference + (~(lenContact) + 1'b1);
		
		if ((!xContact && yContact[9]) || (!yContact && xContact[9]))
		begin
			killPlayer = 1'b1;
		end
		else
			killPlayer = 1'b0;
		if (!xaCompare[9] && xaCompare)
		begin
			leftPass = 1'b0;
			rightPass = 1'b1;
		end
		else
		begin
			rightPass = 1'b0;
			if (xaCompare)
			begin
				leftPass = 1'b1;
			end
			else
			begin
				leftPass = 1'b0;
			end
		end
		if (!yaCompare[9] && yaCompare)
		begin
			upPass = 1'b0;
			downPass = 1'b1;
		end
		else
		begin
			downPass = 1'b0;
			if (yaCompare)
			begin
				upPass = 1'b1;
			end
			else
			begin
				upPass = 1'b0;
			end
		end
		
		unique case (generationCount)
			3'h0 : rSelect = generation[1:0];
			3'h1 : rSelect = generation[3:2];
			3'h2 : rSelect = generation[5:4];
			3'h3 : rSelect = generation[7:6];
			3'h4 : rSelect = generation[9:8];
			3'h5 : rSelect = generation[11:10];
			3'h6 : rSelect = generation[13:12];
			3'h7 : rSelect = generation[15:14];
			default : rSelect = generation[1:0];
		endcase
		
		xTileBound = ~(posX[0] | posX[1] | posX[2] | posX[3] | posX[4]);
		yTileBound = ~(posY[0] | posY[1] | posY[2] | posY[3] | posY[4]);
		crossroadCheck = xTileBound & yTileBound;
		
		leftMoveCheck = posXInertia[9];
		rightMoveCheck = posXInertia[0] & ~(posXInertia[9]);
		upMoveCheck = posYInertia[9];
		downMoveCheck = posYInertia[0] & ~(posYInertia[9]);
		
		unique case (directions)
			4'h0 : begin
				posXTurn = 10'd0;
				posYTurn = (~(ghostStep) + 1'b1);
			end
			4'h1 : begin
				posXTurn = 10'd0;
				posYTurn = ghostStep;
			end
			4'h2 : begin
				posXTurn = 10'd0;
				posYTurn = (~(ghostStep) + 1'b1);
			end
			4'h4 : begin
				posXTurn = ghostStep;
				posYTurn = 10'd0;
			end
			4'h8 : begin
				posXTurn = (~(ghostStep) + 1'b1);
				posYTurn = 10'd0;
			end
			4'hc : begin
				if (rSelect == 2'b11)
				begin
					if (leftMoveCheck)
					begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
					else
					begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
				end
				else
				begin
					if (leftMoveCheck)
					begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
					else
					begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
				end
			end
			4'ha : begin
				if (rSelect == 2'b11)
				begin
					if (downMoveCheck)
					begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
					else
					begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
				end
				else
				begin
					if (downMoveCheck)
					begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
					else
					begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
				end
			end
			4'h9 : begin
				if (rSelect == 2'b11)
				begin
					if (upMoveCheck == 1'b1)
					begin
						posXTurn = 10'd0;
						posYTurn = ghostStep;
					end
					else
					begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
				end
				else
				begin
					if (upMoveCheck == 1'b1)
					begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
					else
					begin
						posXTurn = 10'd0;
						posYTurn = ghostStep;
					end
				end
			end
			4'h6 : begin
				if (rSelect == 2'b11)
				begin
					if (downMoveCheck)
					begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
					else
					begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
				end
				else
				begin
					if (downMoveCheck)
					begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
					else
					begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
				end
			end
			4'h5 : begin
				if (rSelect == 2'b11)
				begin
					if (upMoveCheck)
					begin
						posXTurn = 10'd0;
						posYTurn = ghostStep;
					end
					else
					begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
				end
				else
				begin
					if (upMoveCheck)
					begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
					else
					begin
						posXTurn = 10'd0;
						posYTurn = ghostStep;
					end
				end
			end
			4'h3 : begin
				if (rSelect == 2'b11)
				begin
					if (upMoveCheck == 1'b1)
					begin
						posXTurn = 10'd0;
						posYTurn = ghostStep;
					end
					else
					begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
				end
				else
				begin
					if (upMoveCheck)
					begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
					else
					begin
						posXTurn = 10'd0;
						posYTurn = ghostStep;
					end
				end
			end
			4'he : begin
				if (downPass)
				begin
					posXTurn = 10'd0;
					posYTurn = (~(ghostStep) + 1'b1);
				end
				else if (rightPass)
				begin
					posXTurn = (~(ghostStep) + 1'b1);
					posYTurn = 10'd0;
				end
				else
				begin
					posXTurn = ghostStep;
					posYTurn = 10'd0;
				end
			end
			4'hd : begin
				if (upPass)
				begin
					posXTurn = 10'd0;
					posYTurn = ghostStep;
				end
				else if (rightPass)
				begin
					posXTurn = (~(ghostStep) + 1'b1);
					posYTurn = 10'd0;
				end
				else
				begin
					posXTurn = ghostStep;
					posYTurn = 10'd0;
				end
			end
			4'hb : begin
				if (rightPass)
				begin
					posXTurn = (~(ghostStep) + 1'b1);
					posYTurn = 10'd0;
				end
				else if (downPass)
				begin
					posXTurn = 10'd0;
					posYTurn = (~(ghostStep) + 1'b1);
				end
				else
				begin
					posXTurn = 10'd0;
					posYTurn = ghostStep;
				end
			end
			4'h7 : begin
				if (leftPass)
				begin
					posXTurn = ghostStep;
					posYTurn = 10'd0;
				end
				else if (downPass)
				begin
					posXTurn = 10'd0;
					posYTurn = (~(ghostStep) + 1'b1);
				end
				else
				begin
					posXTurn = 10'd0;
					posYTurn = ghostStep;
				end
			end
			4'hf : begin
				unique case (rSelect)
					2'b00 : begin
						posXTurn = (~(ghostStep) + 1'b1);
						posYTurn = 10'd0;
					end
					2'b01 : begin
						posXTurn = ghostStep;
						posYTurn = 10'd0;
					end
					2'b10 : begin
						posXTurn = 10'd0;
						posYTurn = (~(ghostStep) + 1'b1);
					end
					2'b11 : begin
						posXTurn = 10'd0;
						posYTurn = (ghostStep);
					end
				endcase
			end
		endcase
		
		posXInertiaInc = posXInertia;
		posYInertiaInc = posYInertia;
		
		if (crossroadCheck == 1'b0)
		begin
			posXInertiaEnd = posXInertiaInc;
			posYInertiaEnd = posYInertiaInc;
			generationInc = generationCount;
		end
		else
		begin
			posXInertiaEnd = posXTurn;
			posYInertiaEnd = posYTurn;
			
			unique case (generationCount)
				3'h0 : generationInc = 3'h1;
				3'h1 : generationInc = 3'h2;
				3'h2 : generationInc = 3'h3;
				3'h3 : generationInc = 3'h4;
				3'h4 : generationInc = 3'h5;
				3'h5 : generationInc = 3'h6;
				3'h6 : generationInc = 3'h7;
				3'h7 : generationInc = 3'h0;
				default : generationInc = 3'h1;
			endcase
		end
	end
	
	always_ff @ (posedge Reset or posedge Clk)
		begin : ghostMove
		if (Reset)
			begin
				posXInertia <= 10'd0;
				posYInertia <= 10'd0;
				posX <= xStart;
				posY <= yStart;
				posXTurnPrev <= 10'd0;
				posYTurnPrev <= 10'd0;
				generationCount <= 3'h0;
			end
			else
			begin
				posXTurnPrev <= posXTurn;
				posYTurnPrev <= posYTurn;
				posXInertia <= posXInertiaEnd;
				posYInertia <= posYInertiaEnd;
				posX <= (posX + posXInertiaEnd);
				posY <= (posY + posYInertiaEnd);
				generationCount <= generationInc;
			end
		end
		
	assign ghostX = posX;
	assign ghostY = posY;
	
endmodule
