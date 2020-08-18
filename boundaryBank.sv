module boundaries (input level, startCheck, output [155:0] xWalls, yWalls);

	logic [155:0] defaultX, defaultY, levelX, levelY;
	
	always_comb begin
		if (startCheck == 1'b1)
		begin
			xWalls = defaultX;
			yWalls = defaultY;
		end
		else
		begin
			unique case (level)
			1'b0 : begin
				xWalls = defaultX;
				yWalls = defaultY;
			end
			1'b1 : begin
				xWalls = levelX;
				yWalls = levelY;
			end
			default : begin
				xWalls = { 156 {1'b1} };
				yWalls = { 156 {1'b1} };
			end
			endcase
		end
	end
	
	assign defaultY = {
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff,
		13'h1fff
	};
	
	assign defaultX = {
		{ 12 {1'b1} },
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff,
		12'hfff
	};
	
	assign levelY = {
		13'h1803,
		13'h1fff,
		13'h1843,
		13'h1fff,
		13'h1803,
		13'h1000, // fbf
		13'h1000,
		13'h1803,
		13'h1fff,
		13'h1843,
		13'h1fff,
		13'h1803
	};
	
	assign levelX = {
		{ 12 {1'b1} },
		12'ha95,
		12'ha95,
		12'ha95,
		12'ha95,
		12'hb0d,
		12'h000, //b6d
		12'h000,
		12'ha95,
		12'ha95,
		12'ha95,
		12'ha95,
		12'hfff
	};
	
endmodule

module coinBoundaries (input level, output [143:0] origCoinLocs);

	logic [143:0] defaultCoins, levelCoins;
	
	always_comb begin
		unique case (level)
			1'b0 : begin
				origCoinLocs = defaultCoins;
			end
			1'b1 : begin
				origCoinLocs = levelCoins;
			end
			default : begin
				origCoinLocs = defaultCoins;
			end
		endcase
	end
	
	
	assign defaultCoins = {
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
		12'h000,
	};
	
	assign levelCoins = {
		12'h7fe,
		12'h56a,
		12'h7fe,
		12'h56a,
		12'h7fe,
		12'h492,
		12'h492,
		12'h7fe,
		12'h56a,
		12'h7fe,
		12'h56a,
		12'h7fe
	};
	
endmodule
