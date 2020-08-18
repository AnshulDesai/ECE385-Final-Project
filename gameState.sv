module gameState (input Clk, input Reset, input [15:0] keycode, input gameOver, input screenCheck, output [2:0] temp, output resetGame, check, level);

	enum logic [2:0] { LEVEL1, BEAT1, NEWGAME } state, next_state;
	logic [15:0] keyEnter;
	assign keyEnter = 16'h0028;
	logic resetGameNext;
	
	assign temp = state;
	
	always_ff @ (posedge Clk or posedge Reset)
		begin
			if (Reset == 1'b1)
			begin
				state <= NEWGAME;
				resetGame <= 1'b1;
			end
			else
			begin
				state <= next_state;
				resetGame <= resetGameNext;
			end
		end
	
	always_comb begin
		next_state = state;
		resetGameNext = resetGame;
		
		if (gameOver == 1'b1)
		begin
			next_state = NEWGAME;
			resetGameNext = 1'b1;
		end
		else
		begin
			case (state)
			NEWGAME : begin
				resetGameNext = 1'b0;
				if (keycode == keyEnter)
				begin
					next_state = LEVEL1;
				end
				else
				begin
					next_state = NEWGAME;
				end
			end
			LEVEL1 : begin
				if (screenCheck == 1'b1)
				begin
					next_state = LEVEL1;
					resetGameNext = 1'b0;
				end
				else
				begin
					next_state = BEAT1;
					resetGameNext = 1'b0;
				end
			end
			BEAT1 : begin
				resetGameNext = 1'b0;
				if (keycode == keyEnter)
				begin
					next_state = LEVEL1;
				end
				else
				begin
					next_state = BEAT1;
				end
			end
			endcase
		end	
	end
	
	always_comb
		begin
			check = 1'b0;
			case (state)
			NEWGAME : begin
				level = 1'b1;
				check = 1'b1;
			end
			LEVEL1 : begin
				level = 1'b1;
			end
			BEAT1 : begin
				level = 1'b1;
				check = 1'b1;
			end
			endcase
		end
		
endmodule
