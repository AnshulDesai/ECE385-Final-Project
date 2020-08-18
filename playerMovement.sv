module playerMovement (input Clk, Reset, input [155:0] xWalls, yWalls, input [15:0] keycode, output [9:0] playerX, playerY, size, output [1:0] playerDir);

	parameter [9:0] boardMin = 0;
	parameter [9:0] boardXMax = 639;
	parameter [9:0] boardYMax = 479;
	parameter [9:0] boardXCenter = 320;
	parameter [9:0] boardYCenter = 240;
	parameter [9:0] playerXOrigin = 320;
	parameter [9:0] playerYOrigin = 320;
	parameter [9:0] playerStep = 1;

	logic [15:0] keyA, keyD, keyW, keyS;
	logic [9:0] posX, posXInertia, posXInertiaInc, posXInertiaEnd, posXTurn, posXTurnPrev, posY, posYInertia, posYInertiaInc, posYInertiaEnd, posYTurn, posYTurnPrev, posSize;
	logic [2:0] dirTurn;
	logic crossroadCheck, pivotCheck, moveCheck, leftTurnCheck, rightTurnCheck, upTurnCheck, downTurnCheck, leftMoveCheck, rightMoveCheck, upMoveCheck, downMoveCheck;
	
	assign keyA = 16'h0004;
	assign keyD = 16'h0007;
	assign keyW = 16'h001a;
	assign keyS = 16'h0016;
	assign posSize = 4;
	
	wallVerify playerWall (.*, .posX( posX[9:5] ), .posY( posY[9:5] ));
	
	always_comb
		begin
			if (keycode == keyS)
			begin
				posXTurn = 10'd0;
				posYTurn = playerStep;
				dirTurn = 3'b011;
				pivotCheck = ~downTurnCheck;
			end
			else if (keycode == keyW)
			begin
				posXTurn = 10'd0;
				posYTurn = (~(playerStep) + 1'b1);
				dirTurn = 3'b010;
				pivotCheck = ~upTurnCheck;
			end
			else if (keycode == keyD)
			begin
				posXTurn = playerStep;
				posYTurn = 10'd0;
				dirTurn = 3'b001;
				pivotCheck = ~rightTurnCheck;
			end
			else if (keycode == keyA)
			begin
				posXTurn = (~(playerStep) + 1'b1);
				posYTurn = 10'd0;
				dirTurn = 3'b000;
				pivotCheck = ~leftTurnCheck;
			end
			
			else
			
			begin
				posXTurn = posXTurnPrev;
				posYTurn = posYTurnPrev;
				dirTurn = 3'b111;
				pivotCheck = 1'b1;
			end
			
			crossroadCheck = ~(posX[0] | posX[1] | posX[2] | posX[3] | posX[4] | posY[0] | posY[1] | posY[2] | posY[3] | posY[4]);
			
			leftMoveCheck = posXInertia[9];
			rightMoveCheck = posXInertia[0] & ~(posXInertia[9]);
			upMoveCheck = posYInertia[9];
			downMoveCheck = posYInertia[0] & ~(posYInertia[9]);
			
			if (crossroadCheck == 1'b1)
			begin
				if(rightMoveCheck == 1'b1 && rightTurnCheck == 1'b1)
				begin
					posXInertiaInc = playerStep;
					posYInertiaInc = 10'd0;
				end
				else if (leftMoveCheck == 1'b1 && leftTurnCheck == 1'b1)
				begin
					posXInertiaInc = (~(playerStep) + 1'b1);
					posYInertiaInc = 10'd0;
				end
				else if (upMoveCheck == 1'b1 && upTurnCheck == 1'b1)
				begin
					posXInertiaInc = 10'd0;
					posYInertiaInc = (~(playerStep) + 1'b1);
				end
				else if (downMoveCheck == 1'b1 && downTurnCheck == 1'b1)
				begin
					posXInertiaInc = 10'd0;
					posYInertiaInc = playerStep;
				end
				else
				begin
					posXInertiaInc = 10'd0;
					posYInertiaInc = 10'd0;
				end
			end
			else
			begin
				if (dirTurn == 3'b000 && rightMoveCheck == 1'b1)
				begin
					posXInertiaInc = (~(playerStep) + 1'b1);
					posYInertiaInc = 10'd0;
				end
				else if (dirTurn == 3'b001 && leftMoveCheck == 1'b1)
				begin
					posXInertiaInc = playerStep;
					posYInertiaInc = 10'd0;
				end
				else if (dirTurn == 3'b011 && upMoveCheck == 1'b1)
				begin
					posXInertiaInc = 10'd0;
					posYInertiaInc = playerStep;
				end
				else if (dirTurn == 3'b010 && downMoveCheck == 1'b1)
				begin
					posXInertiaInc = 10'd0;
					posYInertiaInc = (~(playerStep) + 1'b1);
				end
				else
				begin
					posXInertiaInc = posXInertia;
					posYInertiaInc = posYInertia;
				end
			end
			
			if (crossroadCheck == 1'b0 || pivotCheck == 1'b1)
			begin
				posXInertiaEnd = posXInertiaInc;
				posYInertiaEnd = posYInertiaInc;
			end
			else
			begin
				posXInertiaEnd = posXTurn;
				posYInertiaEnd = posYTurn;
			end
		end
	
	always_ff @ (posedge Reset or posedge Clk)
		begin : playerMove
			if (Reset)
			begin
				posXInertia <= 10'd0;
				posYInertia <= 10'd0;
				posX <= playerXOrigin;
				posY <= playerYOrigin;
				posXTurnPrev <= 10'd0;
				posYTurnPrev <= 10'd0;
			end
			else
			begin
				posXTurnPrev <= posXTurn;
				posYTurnPrev <= posYTurn;
				posXInertia <= posXInertiaEnd;
				posYInertia <= posYInertiaEnd;
				posX <= (posX + posXInertiaEnd);
				posY <= (posY + posYInertiaEnd);
			end
		end
	
	always_comb
		begin
			if (posXTurn == playerStep)
			begin
				playerDir = 2'b00;
			end
			else if (posXTurn == (~(playerStep) + 1'b1))
			begin
				playerDir = 2'b01;
			end
			else if (posYTurn == playerStep)
			begin
				playerDir = 2'b11;
			end
			else
			begin
				playerDir = 2'b10;
			end
		end
	
	assign playerX = posX;
	assign playerY = posY;
	assign size = posSize;

endmodule
