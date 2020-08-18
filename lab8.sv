//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
	
   always_ff @ (posedge Clk) begin
       Reset_h <= ~(KEY[0]);        // The push buttons are active low
   end
	
	logic [155:0] xWalls, yWalls;
	logic [143:0] origCoinLocs, coinLocs;
	logic [15:0] keycode, redGenerate, orangeGenerate, blueGenerate, pinkGenerate;
	logic [9:0] playerPosX, playerPosY, drawPosX, drawPosY, playerPosSize, redPosX, redPosY, orangePosX, orangePosY, bluePosX, bluePosY, pinkPosX, pinkPosY;
	logic [3:0] playerHitDetect;
	logic level, startCheck, boardCheck, gameOver, gameReset, gameResetAll, playerHitDetectFinal;
	
	assign gameReset = gameResetAll | Reset_h;
	assign playerHitDetectFinal = (playerHitDetect[0] | playerHitDetect[1] | playerHitDetect[2] | playerHitDetect[3]);
	
	boundaries wallBundaryModule(.*); // Done
	
	coinBoundaries coinBoundaryModule(.*); // Done
	
	coinAssembler caModule(.*, .Clk(Clk), .Reset(gameReset), .coinArrangement(origCoinLocs), .presentCheck(coinLocs)); // Done
	
	logic Clk, Reset_h;
	assign Clk = CLOCK_50;
	
	logic [2:0] temp;	
	gameState gameStateModule(.*, .Clk(Clk), .Reset(Reset_h), .gameOver(playerHitDetectFinal), .screenCheck(boardCheck), .resetGame(gameResetAll), .check(startCheck)); // Done
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	
	logic [17:0] count;
	logic [17:0] ghostCount;
	logic clkDivide;
	logic clkGhost;
	always_ff @ (posedge Clk or posedge Reset_h)
	begin
		if (Reset_h)
		begin
			count <= { 18 {1'b0} };
			ghostCount <= { 18 {1'b0} };
			clkDivide <= 1'b0;
			clkGhost <= 1'b0;
		end
		else
		begin
			count <= count + 1;
			ghostCount <= ghostCount + 1;
			if (count >= 200000)
			begin
				count <= { 18 {1'b0} };
				clkDivide <= ~(clkDivide);
			end
			if (ghostCount >= 262000)
			begin
				ghostCount <= { 18 {1'b0} };
				clkGhost <= ~(clkGhost);
			end
		end
	end
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(KEY[0]),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset),
									  .bluegenerate_export(blueGenerate),
									  .orangegenerate_export(orangeGenerate),
									  .pinkgenerate_export(pinkGenerate),
									  .redgenerate_export(redGenerate)
    );
	 
	 VGA_controller vgaControllerModule(.*, .Reset(Reset_h), .DrawX(drawPosX), .DrawY(drawPosY));
	 
	 logic [4:0] redStartX, redStartY, orangeStartX, orangeStartY, blueStartX, blueStartY, pinkStartX, pinkStartY, ghostStart;
	 assign ghostStart = 5'h06;
	 assign redStartX = ghostStart;
	 assign redStartY = ghostStart;
	 assign orangeStartX = ghostStart;
	 assign orangeStartY = ghostStart;
	 assign blueStartX = ghostStart;
	 assign blueStartY = ghostStart;
	 assign pinkStartX = ghostStart;
	 assign pinkStartY = ghostStart;
	 
	 logic [9:0] garbage;
	 logic [1:0] testDir;
	 
	 ghostMovement redGhostMovementModule(.*, .Clk(clkGhost), .Reset(gameReset), .ghostX(redPosX), .ghostY(redPosY), .playerX(playerPosX), .playerY(playerPosY), .fiveXStart(redStartX), .fiveYStart(redStartY), .generation(redGenerate), .killPlayer(playerHitDetect[0]));
	 ghostMovement orangeGhostMovementModule(.*, .Clk(clkGhost), .Reset(gameReset), .ghostX(orangePosX), .ghostY(orangePosY), .playerX(playerPosX), .playerY(playerPosY), .fiveXStart(orangeStartX), .fiveYStart(orangeStartY), .generation(orangeGenerate), .killPlayer(playerHitDetect[1]));    
	 ghostMovement blueGhostMovementModule(.*, .Clk(clkGhost), .Reset(gameReset), .ghostX(bluePosX), .ghostY(bluePosY), .playerX(playerPosX), .playerY(playerPosY), .fiveXStart(blueStartX), .fiveYStart(blueStartY), .generation(blueGenerate), .killPlayer(playerHitDetect[2]));
	 ghostMovement pinkGhostMovementModule(.*, .Clk(clkGhost), .Reset(gameReset), .ghostX(pinkPosX), .ghostY(pinkPosY), .playerX(playerPosX), .playerY(playerPosY), .fiveXStart(pinkStartX), .fiveYStart(pinkStartY), .generation(pinkGenerate), .killPlayer(playerHitDetect[3])); 
	 playerMovement playerMovementModule(.*, .Clk(clkDivide), .Reset(gameReset), .playerX(playerPosX), .playerY(playerPosY), .size(garbage), .playerDir(testDir));
	 
	 assign playerPosSize = 16;
	 
	 color_mapper color_instance(.*, .DrawX(drawPosX), .DrawY(drawPosY), .playerX(playerPosX), .playerY(playerPosY), .playerSize(playerPosSize), .dir(testDir), .redGhostX(redPosX), .redGhostY(redPosY), .orangeGhostX(orangePosX), .orangeGhostY(orangePosY), .blueGhostX(bluePosX), .blueGhostY(bluePosY), .pinkGhostX(pinkPosX), .pinkGhostY(pinkPosY));
 // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // Display keycode on hex display		
    HexDriver hex_inst_0 ({playerPosX[5:2]}, HEX0);
    HexDriver hex_inst_1 ({testDir, 2'b00}, HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
