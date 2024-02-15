`default_nettype none `timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end
	
	parameter gs = 8;
  // Wire up the inputs and outputs:
  reg clk = 1'b0;
  reg rst_n = 1'b0;
  reg ena = 1'b0;
  reg [7:0] ui_in = 8'b0;
  reg [7:0] uio_in = 8'b0;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Replace tt_um_example with your module name:
  tt_um_flappy_bird (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );
  
  always begin
		#5 clk_i = ~clk_i;
	end
	
	/* verilator lint_on STMTDLY */

	initial begin
		$dumpfile("tt_um_flappy_bird_tb.vcd");
		$dumpvars;

		/* verilator lint_off STMTDLY */
		#20 ena = 1'b1;
		#20 rst_n = 1'b1 ; // deassert reset
		#500 rst_n = 1'b0;
		#300 ui_in = 8'b0000_0010 ;//down
		#300 ui_in = 8'b0000_0001 ;//up
		#300 ui_in = 8'b0000_0010 ;//up
		#300 ui_in = 8'b0000_0010 ;//up
		#300 ui_in = 8'b0000_0001 ;//up
		#300 ui_in = 8'b0000_0001 ;//up
		#300 ui_in = 8'b0000_0010 ;//up
		#300 ui_in = 8'b0000_0000 ;//up
		
		#4500 $finish ; // finish
		/* verilator lint_on STMTDLY */
	end


endmodule
